// Modules to control application life and create native browser window
const { app, BrowserWindow, ipcMain, Menu } = require('electron');
const path = require('path');
const child = require('child_process');

const { saveDefaultSettings, handleSettingsRequest } = require('./modules/settings');
const { getmilQuantVersion } = require('./modules/milQuant-version');
const { checkAndLoadShiny } = require('./modules/loadShiny');
const { cleanUpApplication } = require('./modules/utility');

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

// Keep a global reference of objects, if you don't, the window will
// be closed automatically when the JavaScript object is garbage collected.
let mainWindow;
let RPkgUpdater;
let milQuantShiny;

// current version of the R-package to possibly influence the update process
var milQuantVersion = getmilQuantVersion();

// send it to the loading.html window
ipcMain.on('context-request', (event) => {
  event.sender.send('context-reply', "start", milQuantVersion);
});


// Create the browser window.
function createWindow() {
  // Create the browser window.
  console.log('Creating the main window.');

  mainWindow = new BrowserWindow({
    width: 1400,
    height: 900,
    frame: true,
    show: false,
    maximizable: true,
    webPreferences: {
      nodeIntegration: false,
      preload: path.join(__dirname, 'pages/preload.js')
    }
  });

  // delayedLoad() loads the shiny url to the windows after it is ready
  checkAndLoadShiny(mainWindow, milQuantShiny, RPkgUpdater, milQuantVersion);

  // actually shows the mainWindow
  mainWindow.show();
  mainWindow.maximize();


  mainWindow.on('closed', function () {
    console.log('mainWindow has been closed');
    cleanUpApplication(milQuantShiny);
  });


  // this will build the custom top menu bar
  require('./modules/topmenu');
};

// requested by modal-preload.js and sent back
ipcMain.on('settings-request', function (event) {
  handleSettingsRequest(event)
});

// get the settings from the form in the modal that you can load
// from the top menu
ipcMain.on('save-settings', (event, data) => {
  saveDefaultSettings(event, data)
});


app.whenReady().then(() => {
  createWindow();

  mainWindow.webContents.on('context-menu', (e, props) => {
    const contextMenu = Menu.buildFromTemplate([
      { role: 'copy' },
      { role: 'paste' }
    ]);

    contextMenu.popup({ window: mainWindow });
  });
});

app.on('window-all-closed', function () {
  console.log("window-all-closed");
  cleanUpApplication();
});


// export mainWindow so it can be used in the modules in ./imports/
module.exports = { mainWindow };