// Wait for the DOM to be fully loaded
window.addEventListener('DOMContentLoaded', () => {
    // Wait for the event to that version will not be undefined

    window.addEventListener('spinnerSubtitleDisplay', function (event) {
        // Access the data using event.detail
        console.log('Received spinnerSubtitleDisplay event with data:', event.detail);
        // Update the UI based on the data
        document.getElementById('spinnerSubtitle').innerText = event.detail.toString();
    });
});

console.log("This is a message in loading.js");