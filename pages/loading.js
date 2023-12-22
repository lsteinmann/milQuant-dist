// Wait for the DOM to be fully loaded
window.addEventListener('DOMContentLoaded', () => {
    // Wait for the event to that version will not be undefined
    window.addEventListener('milQuantVersionDisplay', () => {
        // get the number
        const milQuantVersionNumber = electron.getmilQuantVersionNumber();
        // and display in HTML
        document.getElementById('milQuantVersion').innerText = `milQuant-Version (shiny): ${milQuantVersionNumber}`;
    });
});

console.log("This is a message in loading.js");