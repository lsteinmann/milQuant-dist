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
  
module.exports = { handleSquirrelEvent };