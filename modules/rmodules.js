
const { app } = require('electron');
const path = require('path');
const child = require('child_process');

const RPath = path.join(app.getAppPath(), "R-win-port", "bin");


// function to spawn a child process that executes RScript
function spawnR(call) {
    try {
        var execPath = path.join(RPath, "RScript.exe");
        return child.spawn(execPath, ["-e", call]);
    } catch (error) {
        console.error('Error trying to run RScript:', error.message);
    }
};


function openRConsole() {
    try {
        var execPath = path.join(RPath, "R.exe");
        child.spawn(execPath, ['--no-save', '--no-environ'], { shell: true, detached: true });
    } catch (error) {
        console.error('Error opening R Console:', error.message);
    };
};

module.exports = { spawnR, openRConsole };