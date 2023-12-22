const { app } = require('electron')
const fs = require('fs');
const path = require('path')


const descriptionFileName = path.join(app.getAppPath(), 'R-win-port/library/milQuant/DESCRIPTION').replace(/\\/g, '\\\\')



// Section for the Settings modal
function getmilQuantVersion() {

    var fileContents = fs.readFileSync(descriptionFileName, 'utf8', (err, data) => {
        if (err) {
            console.error(`Error in getmilQuantVersion(): ${err.message}`)
            var check = false
            return check;
        } else {
            return data;
        }
    });

    const versionMatch = fileContents.match(/Version:\s*(\S+)/);

    if (versionMatch && versionMatch[1]) {
        const versionNumber = versionMatch[1];
        console.log(`Current milQuant-version Number: ${versionNumber}`);
        return versionNumber;
    } else {
        console.error('Version number not found in DESCRIPTION file.');
        var check = false;
        return check;
    }
}

module.exports = { getmilQuantVersion };