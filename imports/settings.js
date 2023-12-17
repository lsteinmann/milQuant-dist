const { app, BrowserWindow } = require('electron')
const fs = require('fs');
const path = require('path')
const settingsFileName = path.join(app.getAppPath(), 'R-win-port/library/milQuant/app/www/settings/shared_settings.R').replace(/\\/g, '\\\\')
const mainWindow = require('../main')

function showDefaultSettingsModal() {
  const settingsModal = new BrowserWindow({
    parent: mainWindow, // Set the parent window (if you have one)
    modal: true, // Set the window to be modal
    alwaysOnTop: true,
    show: false,
    useContentSize: true,
    width: 375,
    height: 225,
    resizable: false,
    movable: false,
    frame: false,
    webPreferences: {
      nodeIntegration: false, // Enable Node.js integration
      contextIsolation: true,
      preload: path.join(app.getAppPath(), 'modal-preload.js')
    }
  });
  // Load the HTML content into the window
  settingsModal.loadFile('settings.html');

  // Show the window when it's ready
  settingsModal.once('ready-to-show', () => {
    settingsModal.show();
  });
}

// Section for the Settings modal
function readDefaultSettings() {
  // Read the contents of the default settings file
  var fileContents = fs.readFileSync(settingsFileName, 'utf-8');

  // Define a regular expression to extract the data from the R-list
  const listRregex = /list\((.*)\)/;
  const rawSettings = fileContents.match(listRregex);

  // If there is a match, extract the data
  if (rawSettings) {
    var data = rawSettings[1]
      .replace(/"/g, '') // Remove any quotes
      .split(', ') // Split into an array of key-value pairs
      .map(pair => {
        var [key, value] = pair.split('=');
        return [key.trim(), value.trim()];
      });

    var defaultAppSettings = Object.fromEntries(data);

    console.log(defaultAppSettings);

    return defaultAppSettings;
  }
}

// Export the functions in this file so they can be used elsewhere
module.exports = { showDefaultSettingsModal, readDefaultSettings, settingsFileName };
