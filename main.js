// Modules to control application life and create native browser window
const { app, BrowserWindow, ipcMain } = require('electron')
const path = require('path')
const fs = require('fs');


// not great to do that, maybe try to choose a random port?
const port = "3002"
const child = require('child_process');

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
var appPath = path.join(app.getAppPath(), "shiny/app.R").replace(/\\/g, "\\\\")
var execPath = path.join(app.getAppPath(), "R-win-port", "bin", "RScript.exe")
var settingsFileName = path.join(app.getAppPath(), 'shiny/defaults/settings.R').replace(/\\/g, '\\\\')


// creates the childProcess const that will start R and tell it to run the Shiny App as app.R from the 
// app directory of the electron app
const childProcess = child.spawn(execPath, ["-e", "shiny::runApp(file.path('" + appPath + "'), port=" + port + ")"])

// this starts the childProcess and also
// repeats everything R tells us to the console
childProcess.stderr.on('data', (data) => {
  console.log(`stderr:${data}`)
})

// with delayedLoad() : first, an empty loading.html is loaded, then after a 3-second timeout, the shiny url
// this avoids the white screen that occurs if the windows loads before shiny is actually ready
const delay = ms => new Promise(res => setTimeout(res, ms));
const delayedLoad = async () => {
  mainWindow.loadFile('loading.html')
  await delay(3000);
  mainWindow.loadURL('http://127.0.0.1:' + port)
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
      nodeIntegration: false
    }
  })

  // delayedLoad() loads the shiny url to the windows after waiting
  delayedLoad()
  // actually shows the mainWindow
  mainWindow.show()


  mainWindow.on('closed', function () {
    console.log(new Date().toISOString() + '::mainWindow.closed()')
    cleanUpApplication()
  })


  // this will build the custom top menu bar
  require('./imports/topmenu')
}

// quit the app, and if a child exists, kill it
function cleanUpApplication() {
  app.quit()

  if (childProcess) {
    childProcess.kill();
  }
}


// This app does not need a gpu
// app.disableHardwareAcceleration()


function showDefaultSettingsModal() {
  const settingsModal = new BrowserWindow({
    parent: mainWindow, // Set the parent window (if you have one)
    modal: true, // Set the window to be modal
    alwaysOnTop: true,
    show: false,
    useContentSize: true,
    width: 375,
    height: 165,
    resizable: false,
    movable: false,
    frame: false,
    webPreferences: {
        nodeIntegration: false, // Enable Node.js integration
        contextIsolation: false,
        preload: path.join(app.getAppPath(), 'modal-preload.js')
    }
  });
  // Load the HTML content into the window
  settingsModal.loadFile('settings.html');

  // Show the window when it's ready
  settingsModal.once('ready-to-show', () => {
    settingsModal.show();
  });
}

// Section for the Settings modal
function readDefaultSettings() {
  // Read the contents of the default settings file
  var fileContents = fs.readFileSync(settingsFileName, 'utf-8');

  // Define a regular expression to extract the data from the R-list
  const listRregex = /list\((.*)\)/;
  const rawSettings = fileContents.match(listRregex);

  // If there is a match, extract the data
  if (rawSettings) {
    var data = rawSettings[1]
      .replace(/"/g, '') // Remove any quotes
      .split(', ') // Split into an array of key-value pairs
      .map(pair => {
        var [key, value] = pair.split('=');
        return [key.trim(), value.trim()];
      });

    var defaultAppSettings = Object.fromEntries(data);

    console.log(defaultAppSettings);

    return defaultAppSettings;
  }
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



// Export the mainWindow variable so I can use it in topmenu
module.exports = { showDefaultSettingsModal };


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
