// Modules to control application life and create native browser window
const { app, BrowserWindow, ipcMain } = require('electron');
const path = require('path');
const fs = require('fs');
const child = require('child_process');

const { readDefaultSettings, settingsFileName } = require('./imports/settings');
const { getmilQuantVersion, checkForUpdate } = require('./imports/milQuant-version');

// this will ensure that squirrel does a few things, such as 
// make the setup produce a desktop shortcut after install and register
// the program to be found by windows
// you can configure icons, authors etc. in the forge.config.js
// for options see: 
// https://www.electronforge.io/config/makers/squirrel.windows
// https://js.electronforge.io/interfaces/_electron_forge_maker_squirrel.InternalOptions.Options.html
var handleSquirrelEvent = function () {
  if (process.platform != 'win32') {
    return false;
  };

  function executeSquirrelCommand(args, done) {
    var updateDotExe = path.resolve(path.dirname(process.execPath),
      '..', 'update.exe');
    var sqchild = child.spawn(updateDotExe, args, { detached: true });

    sqchild.on('close', function (code) {
      done();
    });
  };

  function install(done) {
    var target = path.basename(process.execPath);
    executeSquirrelCommand(["--createShortcut", target], done);
  };

  function uninstall(done) {
    var target = path.basename(process.execPath);
    executeSquirrelCommand(["--removeShortcut", target], done);
  };

  var squirrelEvent = process.argv[1];

  switch (squirrelEvent) {

    case '--squirrel-install':
      install(app.quit);
      return true;

    case '--squirrel-updated':
      install(app.quit);
      return true;

    case '--squirrel-obsolete':
      app.quit();
      return true;

    case '--squirrel-uninstall':
      uninstall(app.quit);
      return true;
  }

  return false;
};


if (handleSquirrelEvent()) {
  return;
};


// function to spawn a child process that executes RScript
function spawnR(call) {
  var execPath = path.join(app.getAppPath(), "R-win-port", "bin", "RScript.exe");
  return child.spawn(execPath, ["-e", call]);
};


// names of the child processes to be spawned later
let milQuantUpdater;
let milQuantShiny;

// current version of the R-package to possibly influence the update process
var milQuantVersion = getmilQuantVersion();
var updatemilQuant = true;

// send it to the loading.html window
ipcMain.on('version-request', (event) => {
  event.sender.send('version-reply', milQuantVersion);
});

// Function to send messages to the renderer process
function sendToRenderer(channel, data) {
  mainWindow.webContents.send(channel, data);
};

// this repeats everything R tells us in the developer tools console for debugging in the client
function logROutput(process) {
  process.stdout.on('data', (data) => {
    //console.log(`R Output: ${data}`)
    sendToRenderer('stdout', data.toString());
  })
  process.stderr.on('data', (data) => {
    //console.log(`R: ${data}`);
    sendToRenderer('stderr', data.toString());
  })
};

// updateShinyApp() spawns R to install the milQuant-package, which will automatically 
// skip the update if the version is the current one on github anyway
// but only if "updatemilQuant" is true (which may be of use later)
const updateShinyApp = async () => {

  var updatemilQuant = await checkForUpdate(milQuantVersion);

  return new Promise((resolve, reject) => {
    if (updatemilQuant) {
      mainWindow.loadFile('pages/update.html');
      ipcMain.once('update', function (event, value) {
        mainWindow.loadFile('pages/loading.html');
        if (value == "no") {
          resolve(true);
        } else {
          if (value == "all") {
            var deps = ["TRUE", "always"];
          } else {
            var deps = ["FALSE", "never"];
          };
          console.log("Trying to update milQuant-package.");
          milQuantUpdater = spawnR(`remotes::install_github('lsteinmann/milQuant', dependencies = ${deps[0]}, upgrade = '${deps[1]}')`);
          //milQuantUpdater = spawnR('message("DONE (milQuant)")');

          logROutput(milQuantUpdater);
          milQuantUpdater.stderr.on('data', (data) => {
            if (data.includes('DONE (milQuant)')) {
              milQuantUpdater.kill();
              console.log('Shutting down R after Update, moving on.');
              resolve(true);
            }
            if (data.includes("Skipping install of 'milQuant'")) {
              console.log(data.toString());
              milQuantUpdater.kill();
              resolve(true);
            }
          });

          milQuantUpdater.on('error', (error) => {
            console.error('Error during R update:', error.message);
            reject(error);
          });

        };
      });
    } else {
      console.log("Not updating milQuant, moving on.");
      resolve(true);
    };
  });
};

// checkAndLoadShiny() loads the loading.html with the spinner and version number, 
// and waits for the update process to finish to then call 
// loadShinyURLWhenReady()
const checkAndLoadShiny = async () => {
  mainWindow.loadFile('pages/loading.html');
  try {
    const updateReady = await updateShinyApp();
    if (updateReady) {
      console.log("updateShinyApp() has finished.");
      loadShinyURLWhenReady();
    } else {
      console.log('updateShinyApp() has finished and did not return true.');
    }
  } catch (error) {
    console.error('An error occurred:', error);
  }
}


// loadShinyURLWhenReady() : spawns the RScript that will host the shiny app and
// loads the URL that shiny states in "Listening on..."
const loadShinyURLWhenReady = async () => {
  milQuantShiny = spawnR("library(milQuant); milQuant::run_milQuant_app()");
  logROutput(milQuantShiny);

  milQuantShiny.stderr.on('data', (data) => {
    if (data.includes('Listening on')) {
      shinyURL = data.toString().replace('Listening on ', '');
      console.log(`Loading shiny on ${shinyURL}`);
      mainWindow.loadURL(shinyURL);
    };
  });
  milQuantShiny.stdout.on('data', (data) => {
    if (data.includes("Shiny: EXIT")) {
      mainWindow.close();
    };
  });
};

// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is garbage collected.
let mainWindow;


// Create the browser window.
function createWindow() {
  // Create the browser window.
  console.log('Creating the main window.');

  mainWindow = new BrowserWindow({
    width: 1400,
    height: 900,
    frame: true,
    show: false,
    webPreferences: {
      nodeIntegration: false,
      preload: path.join(__dirname, 'pages/preload.js')
    }
  });

  // delayedLoad() loads the shiny url to the windows after it is ready
  checkAndLoadShiny();

  // actually shows the mainWindow
  mainWindow.show();


  mainWindow.on('closed', function () {
    console.log('mainWindow has been closed');
    cleanUpApplication();
  });


  // this will build the custom top menu bar
  require('./imports/topmenu');
};

// quit the app, and if a child exists, kill it
function cleanUpApplication() {

  if (milQuantShiny) {
    milQuantShiny.kill();
    console.log('Shutting down R');
  };

  app.quit();
};


// get the settings from the file in shiny/defaults
var defaultAppSettings = readDefaultSettings();
// requested by modal-preload.js and sent back
ipcMain.on('variable-request', function (event, arg) {
  event.sender.send('variable-reply', [defaultAppSettings[arg[0]], defaultAppSettings[arg[1]], , defaultAppSettings[arg[3]]]);
});

// get the settings from the form in the modal that you can load
// from the top menu
ipcMain.on('default-settings', (event, data) => {
  const { username, synchpw } = data;

  var settings = `list("username" = "${username}", "synchpw" = "${synchpw}")`;

  // Save the form data to a file or database:
  fs.writeFile(settingsFileName, settings, (err) => {
    if (err) {
      console.error(err);
      return;
    };
    console.log(`Data saved successfully to file: ${settingsFileName}`);
  });
});


app.whenReady().then(() => {
  createWindow();
});

app.on('window-all-closed', function () {
  console.log("window-all-closed");
  cleanUpApplication();
});


// export mainWindow so it can be used in the modules in ./imports/
module.exports = { mainWindow };