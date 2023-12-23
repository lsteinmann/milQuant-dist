const { app } = require("electron")


// quit the app, and if a child exists, kill it
function cleanUpApplication(child) {

    if (child) {
        child.kill();
        console.log('Shutting down R');
    };

    app.quit();
};

module.exports = { cleanUpApplication };