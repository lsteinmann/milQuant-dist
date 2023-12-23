const { ipcMain } = require('electron');

const { spawnR } = require('./rmodules');
const { logROutput } = require('./bridge');
const { getmilQuantVersion, checkForUpdate } = require('./milQuant-version');

const runInstallGithub = async (mainWindow, RPkgUpdater, package, deps) => {
    return new Promise((resolve, reject) => {
        console.log("runInstallGithub() is trying to update: ", package);
        RPkgUpdater = spawnR(`remotes::install_github('${package}', dependencies = ${deps[0]}, upgrade = '${deps[1]}')`);

        logROutput(mainWindow, RPkgUpdater);
        RPkgUpdater.stderr.on('data', (data) => {
            if (data.includes('DONE')) {
                RPkgUpdater.kill();
                console.log('Shutting down R after Update, moving on.');
                resolve(true);
            }
            if (data.includes("Skipping install of")) {
                console.log(data.toString());
                RPkgUpdater.kill();
                resolve(true);
            }
        });

        RPkgUpdater.on('error', (error) => {
            console.error('Error during R update:', error.message);
            reject(error);
        });
    });
};

// updateShinyApp() spawns R to install the milQuant-package, which will automatically 
// skip the update if the version is the current one on github anyway
// but only if "updatemilQuant" is true (which may be of use later)
const updateShinyApp = async (mainWindow, RPkgUpdater, milQuantVersion) => {

    var updatemilQuant = await checkForUpdate(milQuantVersion);

    return new Promise((resolve, reject) => {
        if (updatemilQuant) {
            mainWindow.loadFile('pages/update.html');
            ipcMain.once('update', async (event, value) => {
                mainWindow.loadFile('pages/loading.html');
                ipcMain.on('context-request', (event) => {
                    event.sender.send('context-reply', "update", "updating");
                });

                if (value == "no") {
                    resolve(true);
                } else {
                    if (value == "all") {
                        var deps = ["TRUE", "always"];
                    } else {
                        var deps = ["FALSE", "never"];
                    };
                    await runInstallGithub(mainWindow, RPkgUpdater, "lsteinmann/idaifieldR", deps);
                    await runInstallGithub(mainWindow, RPkgUpdater, "lsteinmann/milQuant", deps);
                    resolve(true);
                };
                console.log('Timeout completed after 10 seconds');
            });
        } else {
            console.log("Not updating milQuant, moving on.");
            resolve(true);
        };
    });
};


// loadShinyURLWhenReady() : spawns the RScript that will host the shiny app and
// loads the URL that shiny states in "Listening on..."
const loadShinyURLWhenReady = async (mainWindow, milQuantShiny) => {
    milQuantShiny = spawnR("library(milQuant); milQuant::run_milQuant_app()");
    logROutput(mainWindow, milQuantShiny);

    milQuantShiny.stderr.on('data', (data) => {
        if (data.includes('Listening on')) {
            shinyURL = data.toString().replace('Listening on ', '');
            console.log(`Loading shiny on ${shinyURL}`);
            mainWindow.loadURL(shinyURL);
        };
    });
    milQuantShiny.stdout.on('data', (data) => {
        if (data.includes("Shiny: EXIT")) {
            mainWindow.close();
        };
    });
};

// checkAndLoadShiny() loads the loading.html with the spinner and version number, 
// and waits for the update process to finish to then call 
// loadShinyURLWhenReady()
const checkAndLoadShiny = async (mainWindow, milQuantShiny, RPkgUpdater, milQuantVersion) => {
    //mainWindow.loadFile('pages/loading.html');
    try {
        const updateReady = await updateShinyApp(mainWindow, RPkgUpdater, milQuantVersion);
        if (updateReady) {
            mainWindow.loadFile('pages/loading.html');
            ipcMain.on('context-request', (event) => {
                event.sender.send('context-reply', "start", milQuantVersion);
            });
            console.log("updateShinyApp() has finished.");
            await loadShinyURLWhenReady(mainWindow, milQuantShiny);
        } else {
            console.log('updateShinyApp() has finished and did not return true.');
        }
    } catch (error) {
        console.error('An error occurred:', error);
    }
}

module.exports = { checkAndLoadShiny, updateShinyApp };