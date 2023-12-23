const { ipcRenderer } = require('electron');

function closeSettingsModal() {
  console.log("Closing Settings Modal!");
  window.parent.close();
};

window.addEventListener('DOMContentLoaded', () => {

    ipcRenderer.send('settings-request');

    ipcRenderer.on('settings-reply', function (event, defaultAppSettings) {
        document.getElementById('fieldhost').value = defaultAppSettings['fieldhost'];
        document.getElementById('username').value = defaultAppSettings['username'];
        document.getElementById('synchpw').value = defaultAppSettings['synchpw'];
    });

    const form = document.getElementById('default-settings-form');

    form.addEventListener('submit', (event) => {
        event.preventDefault();

        const fieldhost = document.getElementById('fieldhost').value;
        const username = document.getElementById('username').value;
        const synchpw = document.getElementById('synchpw').value;

        // Send the form data to the main process via IPC
        ipcRenderer.send('save-settings', { fieldhost, username, synchpw });

        closeSettingsModal();
    });

    document.getElementById("cancel").addEventListener("click", closeSettingsModal);

});
