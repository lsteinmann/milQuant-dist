/*
 * The preload script runs before the mainWindow. 
*/
const { contextBridge, ipcRenderer } = require('electron');

window.addEventListener('DOMContentLoaded', () => {
  const replaceText = (selector, text) => {
    const element = document.getElementById(selector);
    if (element) element.innerText = text;
  };

  for (const type of ['chrome', 'node', 'electron']) {
    replaceText(`${type}-version`, process.versions[type]);
  };
});

// Code for loading.html
window.addEventListener('DOMContentLoaded', () => {
  ipcRenderer.send('context-request');

  ipcRenderer.on('context-reply', function (event, context, data) {
    let spinnerSubtitle;

    if (context == "start") {
      console.log(`Using milQuant R-package with version: ${data.toString()}`);
      spinnerSubtitle = `Using milQuant (Shiny) Version: ${data}`;
    } else if (context == "update") {
      console.log("Currently updating R-packages...");
      spinnerSubtitle = "Updating R-Packages...";
    }

    window.dispatchEvent(new CustomEvent('spinnerSubtitleDisplay', { detail: spinnerSubtitle }));
  });
});

// Code for update.html
window.addEventListener('DOMContentLoaded', () => {
  // error when not currently on update.html
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


// Code to display messages from logROutput() in Developer Tools Console:
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