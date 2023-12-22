const { ipcRenderer } = require('electron');

function closeSettingsModal() {
  console.log("Closing Settings Modal!");
  window.parent.close();
};



window.addEventListener('DOMContentLoaded', () => {

    ipcRenderer.send('variable-request', ['username', 'synchpw']);

    ipcRenderer.on('variable-reply', function (event, defaultAppSettings) {
        document.getElementById('username').value = defaultAppSettings[0];
        document.getElementById('synchpw').value = defaultAppSettings[1];
    });

    const form = document.getElementById('default-settings-form');

    form.addEventListener('submit', (event) => {
        event.preventDefault();

        const username = document.getElementById('username').value;
        const synchpw = document.getElementById('synchpw').value;

        // Send the form data to the main process via IPC
        ipcRenderer.send('default-settings', { username, synchpw });

        closeSettingsModal();
    });

    document.getElementById("cancel").addEventListener("click", closeSettingsModal);

});
