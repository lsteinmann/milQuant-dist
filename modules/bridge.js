
// Function to send messages to the renderer process
function sendToRenderer(mainWindow, channel, data) {
    if (mainWindow) {
        mainWindow.webContents.send(channel, data);
    } else {
        console.error("Cannot reach mainWindow in sendRoRenderer().");
    };
};

// this repeats everything R tells us in the developer tools console for debugging in the client
function logROutput(mainWindow, process) {
    process.stdout.on('data', (data) => {
        //console.log(`R Output: ${data}`)
        sendToRenderer(mainWindow, 'stdout', data.toString());
    })
    process.stderr.on('data', (data) => {
        //console.log(`R: ${data}`);
        sendToRenderer(mainWindow, 'stderr', data.toString());
    })
};

module.exports = { sendToRenderer, logROutput};