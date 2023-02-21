// Modules to control application life and create native browser window
const {app, BrowserWindow} = require('electron')
const path = require('path')

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
var handleSquirrelEvent = function() {
  if (process.platform != 'win32') {
     return false;
  }

  function executeSquirrelCommand(args, done) {
     var updateDotExe = path.resolve(path.dirname(process.execPath), 
        '..', 'update.exe');
     var sqchild = child.spawn(updateDotExe, args, { detached: true });

     sqchild.on('close', function(code) {
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
var appPath = path.join(app.getAppPath(), "shiny/app.R" ).replace(/\\/g, "\\\\")
var execPath = path.join(app.getAppPath(), "R-win-port", "bin", "RScript.exe" )


// creates the childProcess const that will start R and tell it to run the Shiny App as app.R from the 
// app directory of the electron app
const childProcess = child.spawn(execPath, ["-e", "shiny::runApp(file.path('"+appPath+"'), port="+port+")"])

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
  mainWindow.loadURL('http://127.0.0.1:'+port)
};

// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is garbage collected.
let mainWindow

function createWindow () {
  // Create the browser window.
  console.log('Creating the main window here')

  mainWindow = new BrowserWindow({
    width: 1400,
    height: 900,
    show: false,
    webPreferences: {
      nodeIntegration:false
    }
  })

  // delayedLoad() loads the shiny url to the windows after waiting
  delayedLoad()
  // actually shows the mainWindow
  mainWindow.show()
}

// quit the app, and if a child exists, kill it
function cleanUpApplication(){
  app.quit()
  
  if(childProcess){
    childProcess.kill(); 
  }
}


// This app does not need a gpu
// app.disableHardwareAcceleration()


// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.whenReady().then(() => {
  createWindow()
  app.on('activate', function () {
    // On macOS it's common to re-create a window in the app when the
    // dock icon is clicked and there are no other windows open.
    if (BrowserWindow.getAllWindows().length === 0) createWindow()
  })
})

// Quit when all windows are closed, except on macOS. There, it's common
// for applications and their menu bar to stay active until the user quits
// explicitly with Cmd + Q.
app.on('window-all-closed', function () {
  console.log('EVENT::window-all-closed')
  cleanUpApplication()
})
