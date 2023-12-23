const { ipcMain } = require('electron');

const { spawnR } = require('./rmodules');
const { logROutput } = require('./bridge');
const { getmilQuantVersion, checkForUpdate } = require('./milQuant-version');


// updateShinyApp() spawns R to install the milQuant-package, which will automatically 
// skip the update if the version is the current one on github anyway
// but only if "updatemilQuant" is true (which may be of use later)
const updateShinyApp = async (mainWindow, milQuantUpdater, milQuantVersion) => {

    var milQuantVersion = getmilQuantVersion();
    var updatemilQuant = await checkForUpdate(milQuantVersion);

    return new Promise((resolve, reject) => {
        if (updatemilQuant) {
            mainWindow.loadFile('pages/update.html');
            ipcMain.once('update', function (event, value) {
                mainWindow.loadFile('pages/loading.html');
                if (value == "no") {
                    resolve(true);
                } else {
                    if (value == "all") {
                        var deps = ["TRUE", "always"];
                    } else {
                        var deps = ["FALSE", "never"];
                    };
                    console.log("Trying to update milQuant-package.");
                    milQuantUpdater = spawnR(`remotes::install_github('lsteinmann/milQuant', dependencies = ${deps[0]}, upgrade = '${deps[1]}')`);
                    //milQuantUpdater = spawnR('message("DONE (milQuant)")');

                    logROutput(mainWindow, milQuantUpdater);
                    milQuantUpdater.stderr.on('data', (data) => {
                        if (data.includes('DONE (milQuant)')) {
                            milQuantUpdater.kill();
                            console.log('Shutting down R after Update, moving on.');
                            resolve(true);
                        }
                        if (data.includes("Skipping install of 'milQuant'")) {
                            console.log(data.toString());
                            milQuantUpdater.kill();
                            resolve(true);
                        }
                    });

                    milQuantUpdater.on('error', (error) => {
                        console.error('Error during R update:', error.message);
                        reject(error);
                    });

                };
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
const checkAndLoadShiny = async (mainWindow, milQuantShiny, milQuantUpdater) => {
    mainWindow.loadFile('pages/loading.html');
    try {
        const updateReady = await updateShinyApp(mainWindow, milQuantUpdater);
        if (updateReady) {
            console.log("updateShinyApp() has finished.");
            await loadShinyURLWhenReady(mainWindow, milQuantShiny);
        } else {
            console.log('updateShinyApp() has finished and did not return true.');
        }
    } catch (error) {
        console.error('An error occurred:', error);
    }
}

module.exports = { loadShinyURLWhenReady, checkAndLoadShiny, updateShinyApp };