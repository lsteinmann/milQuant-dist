

// Modules to control application life and create native browser window
const {app, BrowserWindow} = require('electron')

const path = require('path')

const url = require('url')
// not great to do that, maybe try to choose a random port?
const port = "3002"
const child = require('child_process');
const WINDOWS = "win32"

const delay = ms => new Promise(res => setTimeout(res, ms));

var appPath = path.join(app.getAppPath(), "app.R" )
// try path.join(__dirname, 'preload.js')
var execPath = "RScript"


if(process.platform == WINDOWS){
  appPath = appPath.replace(/\\/g, "\\\\");
  execPath = path.join(app.getAppPath(), "R-win-port", "bin", "RScript.exe" )
} else {
  console.log("not on windows?")
  throw new Error("not on windows?")
}

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


console.log(process.env)

const childProcess = child.spawn(execPath, ["-e", "shiny::runApp(file.path('"+appPath+"'), port="+port+")"])

childProcess.stdout.on('data', (data) => {
  console.log(`stdout:${data}`)
})
childProcess.stderr.on('data', (data) => {
  console.log(`stderr:${data}`)
})

// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is garbage collected.
let mainWindow

const delayedLoad = async () => {
  mainWindow.loadFile('loading.html')
  await delay(3000);
  mainWindow.loadURL('http://127.0.0.1:'+port)
};


// Create the browser window.
function createWindow () {
  console.log('create-window')

    // open a windows while loading, with a custom loading screen
    let loading = new BrowserWindow({show: false, frame: false})
    console.log(new Date().toISOString()+'::showing loading');
    loading.loadFile('preload.html')

    // the actual browser window of the app
    loading.once('show', () => {
      console.log(new Date().toISOString()+'::show loading')
      mainWindow = new BrowserWindow({
        width: 1400,
        height: 900,
        frame: true,
        show: false,
        webPreferences: {
          nodeIntegration:false
        }
      })
      mainWindow.webContents.once('dom-ready', () => {
        console.log(new Date().toISOString()+'::mainWindow loaded')
        setTimeout( () => {
          mainWindow.show()
          loading.hide()
          loading.close()
        }, 2000)

      })
      console.log(port)
      // loading shiny url, but 3 seconds later to avoid white screen
      // if the windows loads before shiny is actually ready
      delayedLoad()

      mainWindow.webContents.on('did-finish-load', function() {
        console.log(new Date().toISOString()+'::did-finish-load')
      });

      mainWindow.webContents.on('did-start-load', function() {
        console.log(new Date().toISOString()+'::did-start-load')
      });

      mainWindow.webContents.on('did-stop-load', function() {
        console.log(new Date().toISOString()+'::did-stop-load')
      });
      mainWindow.webContents.on('dom-ready', function() {
        console.log(new Date().toISOString()+'::dom-ready')
      });

      // Open the DevTools.
      // mainWindow.webContents.openDevTools()

      // Emitted when the window is closed.
      mainWindow.on('closed', function () {
        console.log(new Date().toISOString()+'::mainWindow.closed()')
        cleanUpApplication()
      })
    })

    loading.show()

}


function cleanUpApplication(){

  app.quit()
  
  if(childProcess){
    childProcess.kill(); 
  }
}
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
  // On OS X it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q
  cleanUpApplication()
  // On macOS it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q
  //if (process.platform !== 'darwin') app.quit()

})

// In this file you can include the rest of your app's specific main process
// code. You can also put them in separate files and require them here.
