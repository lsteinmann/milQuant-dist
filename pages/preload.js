/*
 * The preload script runs before loading.html. 
*/
window.addEventListener('DOMContentLoaded', () => {
  const replaceText = (selector, text) => {
    const element = document.getElementById(selector);
    if (element) element.innerText = text;
  };

  for (const type of ['chrome', 'node', 'electron']) {
    replaceText(`${type}-version`, process.versions[type]);
  };
});

const { contextBridge, ipcRenderer } = require('electron');

let cur_milQuantVersion;

window.addEventListener('DOMContentLoaded', () => {

  ipcRenderer.send('version-request');

  ipcRenderer.on('version-reply', function (event, milQuantVersion) {
    console.log(`Using milQuant R-package with version: ${milQuantVersion.toString()}`);
    cur_milQuantVersion = milQuantVersion;
    window.dispatchEvent(new Event('milQuantVersionDisplay'));
  });

  // Check if currently on update.html
  try {
    document.getElementById('update').addEventListener('click', () => {
      ipcRenderer.send('update', 'milQuant');
    });

    document.getElementById('alldeps').addEventListener('click', () => {
      ipcRenderer.send('update', 'all');
    });

    document.getElementById('cancel').addEventListener('click', () => {
      ipcRenderer.send('update', 'no');
    });
  } catch (error) {
    console.log("Not on Update-Window.")
  };

});

contextBridge.exposeInMainWorld('electron', {
  getmilQuantVersionNumber: () => {
    return cur_milQuantVersion;
  }
});




// Listen for messages from the main process
ipcRenderer.on('stdout', (event, data) => {
  // Log stdout messages to the developer tools
  console.log('R Output: ', data);
});

ipcRenderer.on('stderr', (event, data) => {
  // Log stderr messages to the developer tools
  if (data.toLowerCase().includes("error")) {
    console.error('R Error: ', data);
  } else if (data.toLowerCase().includes("warning")) {
    console.log('R Warning: ', data);
  } else {
    console.log('R Message: ', data);
  };
});