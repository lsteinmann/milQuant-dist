// Modules to control application life and create native browser window
const { app, BrowserWindow, ipcMain } = require('electron')
const path = require('path')
const fs = require('fs');
const child = require('child_process');

const { readDefaultSettings, settingsFileName } = require('./imports/settings');

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
  }

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
}


// (remodel) change forward slashes to escaped backslashes to hand the path to R/shiny
// anything else but windows is not supported here at all and this part has to be redone
// if you want to distribute to something other than windows
var execPath = path.join(app.getAppPath(), "R-win-port", "bin", "RScript.exe")


// app directory of the electron app
const milQuantShiny = child.spawn(execPath, ["-e", "library(milQuant); milQuant::run_milQuant_app()"])

// Function to send messages to the renderer process
function sendToRenderer(channel, data) {
  mainWindow.webContents.send(channel, data);
}

// this repeats everything R tells us to the console and in developer tools
function logROutput(process) {
  process.stdout.on('data', (data) => {
    console.log(`R Output: ${data}`)
    sendToRenderer('stdout', data.toString());
  })
  process.stderr.on('data', (data) => {
    console.log(`R: ${data}`);
    sendToRenderer('stderr', data.toString());
  })
}

// with delayedLoad() : first, an empty loading.html is loaded, then after shiny is ready
// it will load the URL that shiny states in "Listening on..."
const delayedLoad = async () => {
  mainWindow.loadFile('loading.html')
  milQuantShiny.stderr.on('data', (data) => {
    if (data.includes('Listening on')) {
      shinyURL = data.toString().replace('Listening on ', '')
      mainWindow.loadURL(shinyURL)
    }
  })
  milQuantShiny.stdout.on('data', (data) => {
    if (data.includes("Shiny: EXIT")) {
      cleanUpApplication()
    }
  })
  logROutput(milQuantShiny)
};

// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is garbage collected.
let mainWindow


// Create the browser window.
function createWindow() {
  // Create the browser window.
  console.log('Creating the main window here')

  mainWindow = new BrowserWindow({
    width: 1400,
    height: 900,
    frame: true,
    show: false,
    webPreferences: {
      nodeIntegration: false,
      preload: path.join(__dirname, 'preload.js')
    }
  })

  // delayedLoad() loads the shiny url to the windows after it is ready
  delayedLoad()
  // actually shows the mainWindow
  mainWindow.show()


  mainWindow.on('closed', function () {
    console.log('Electron: mainWindow.closed()')
    cleanUpApplication()
  })


  // this will build the custom top menu bar
  require('./imports/topmenu')
}

// quit the app, and if a child exists, kill it
function cleanUpApplication() {

  if (milQuantShiny) {
    milQuantShiny.kill();
    console.log('Electron: Shutting down R')
  }

  app.quit()
}


// get the settings from the file in shiny/defaults
var defaultAppSettings = readDefaultSettings()
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
    }
    console.log('Data saved successfully!');
    console.log(settingsFileName)
  });
});


// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.whenReady().then(() => {
  createWindow()
  app.on('activate', function () {
    // On macOS it's common to re-create a window in the app when the
    // dock icon is clicked and there are no other windows open.
    if (BrowserWindow.getAllWindows().length === 0) createWindow()
    // mainWindow.reload();
  })
})

// Quit when all windows are closed, except on macOS. There, it's common
// for applications and their menu bar to stay active until the user quits
// explicitly with Cmd + Q.
app.on('window-all-closed', function () {
  console.log('EVENT::window-all-closed')
  cleanUpApplication()
})


// export mainWindow so it can be used in the modules in ./imports/
module.exports = { mainWindow };