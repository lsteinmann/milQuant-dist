const { app } = require('electron');
const fs = require('fs');
const path = require('path');


const descriptionFileName = path.join(app.getAppPath(), 'R-win-port/library/milQuant/DESCRIPTION').replace(/\\/g, '\\\\');



// Section for the Settings modal
function getmilQuantVersion() {

    var fileContents = fs.readFileSync(descriptionFileName, 'utf8', (err, data) => {
        if (err) {
            console.error(`Error in getmilQuantVersion(): ${err.message}`);
            var check = false;
            return check;
        } else {
            return data;
        };
    });

    const versionMatch = fileContents.match(/Version:\s*(\S+)/);

    if (versionMatch && versionMatch[1]) {
        const versionNumber = versionMatch[1];
        return versionNumber;
    } else {
        console.error('Version number not found in DESCRIPTION file.');
        var check = false;
        return check;
    };
};


async function getLatestmilQuantReleaseVersion() {
    const repository = 'lsteinmann/milQuant';
    try {
        const response = await fetch(`https://api.github.com/repos/${repository}/releases/latest`);
        const data = await response.json();

        if (response.ok) {
            const latestVersion = data.tag_name.replace("v", "");
            console.log(`Latest release version of ${repository}: ${latestVersion}`);
            return latestVersion;
        } else {
            console.error(`Failed to fetch latest release for ${repository}. Status: ${response.status}`);
            return false;
        }
    } catch (error) {
        console.error(`Error fetching latest release for ${repository}: ${error.message}`);
        return false;
    };
};

const checkForUpdate = async (milQuantVersion) => {
    try {
        const latestRelease = await getLatestmilQuantReleaseVersion();
        //const latestRelease = "3.0.0";

        console.log(`Current milQuant version: ${milQuantVersion}`);
        console.log(`Latest release of milQuant on GitHub: ${latestRelease}`);

        var latestVersion = latestRelease.toString().split(".").map(Number);
        var currentVersion = milQuantVersion.toString().split(".").map(Number);
        var newVersionAvailable = false;

        for (let i = 0; i < latestVersion.length; i++) {
            if (latestVersion[i] > currentVersion[i]) {
                newVersionAvailable = true;
                break;
            };
        };

        return newVersionAvailable;

    } catch (error) {
        console.error('An error occurred:', error);
        return false;
    };
};



module.exports = { getmilQuantVersion, checkForUpdate };