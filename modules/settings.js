const { app, BrowserWindow } = require('electron');
const fs = require('fs');
const path = require('path');


const settingsFileName = path.join(
  app.getAppPath(), 'R-win-port', 'library', 
  'milQuant', 'app', 'www', 'settings', 
  'shared_settings.R'
);

function showDefaultSettingsModal(mainWindow) {
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
      preload: path.join(app.getAppPath(), 'pages', 'modal-preload.js')
    }
  });
  // Load the HTML content into the window
  settingsModal.loadFile('pages/settings.html');

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
  };
};

// Function to handle variable requests
const handleSettingsRequest = (event, arg) => {
  const defaultAppSettings = readDefaultSettings();
  event.sender.send('settings-reply', [defaultAppSettings[arg[0]], defaultAppSettings[arg[1]], , defaultAppSettings[arg[3]]]);
};

// Function to handle default settings
const handleDefaultSettings = (event, data) => {
  const { username, synchpw } = data;

  const settings = `list("username" = "${username}", "synchpw" = "${synchpw}")`;

  // Save the form data to a file or database:
  fs.writeFile(settingsFileName, settings, (err) => {
    if (err) {
      console.error(err);
      return;
    }
    console.log(`Data saved successfully to file: ${settingsFileName}`);
  });
};

// Export the functions in this file so they can be used elsewhere
module.exports = { 
  settingsFileName, 
  showDefaultSettingsModal, 
  readDefaultSettings, 
  handleSettingsRequest,
  handleDefaultSettings 
};
