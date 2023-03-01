// Modules to control application life and create native browser window
const { app, BrowserWindow, ipcMain } = require('electron')
const path = require('path')
const fs = require('fs');
const child = require('child_process');

const { readDefaultSettings, settingsFileName } = require('./imports/settings');
const { handleSquirrelEvent } = require('./imports/squirrel-handler')


// not great to do that, maybe try to choose a random port?
const port = "3002"


if (handleSquirrelEvent()) {
  return;
}


// (remodel) change forward slashes to escaped backslashes to hand the path to R/shiny
// anything else but windows is not supported here at all and this part has to be redone
// if you want to distribute to something other than windows
var shinyPath = path.join(app.getAppPath(), "shiny/app.R").replace(/\\/g, "\\\\")
var execPath = path.join(app.getAppPath(), "R-win-port", "bin", "RScript.exe")


// creates the childProcess const that will start R and tell it to run the Shiny App as app.R from the 
// app directory of the electron app
const childProcess = child.spawn(execPath, ["-e", "shiny::runApp(file.path('" + shinyPath + "'), port=" + port + ")"])

// this starts the childProcess and also
// repeats everything R tells us to the console
childProcess.stdout.on('data', (data) => {
  console.log(`stdout:${data}`)
  if (data.includes("Shiny: EXIT")) {
    cleanUpApplication()
  }
})
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