# milQuant 1.0.2 _tba_

# milQuant 1.0.1 _2023-03-08_
* clean up main.js a lot, restructure directory
* restructure the menu bar at the top and add links to GitHub, the Miletus Excavation Homepage, and an about-window
* add a modal for default settings to the topmenu so users have custom default connection settingson their computer and don't need to reenter password
* remove bug where app would exit on every output from shiny
* add electron-updater/autoUpdater
* from milQuant: 
    * the connection settings (name/pw) are reusable (with milQuant-dist)
    * improved plot legends and added bar plot display options
    * fixed period order in pottery & quant B plots
    * fixed issue with dates
    * use plotly for all graphs
    * add a workflow overview
    * add object table to pottery plot
    * project, operation and trench(es) are saved and restored on exit by button

# milQuant 1.0.0 _2023-02-21_
* first "release" (version number changed to be same as the standalone version)
* no more fluidPage()
* fixed if-condition for trench selection
* proper installer for standalone app

# milQuant 0.2.3 _2023-02-18_

* use idaifieldR v0.2.2 (fixing a problem where with an if-condition)
* rudimentary form for bricks and brick quantification added
* fix downloading plot in Finds, Loomweights and Bricks
* fix error handling in connection (now actually displays the error)
* proper label in period selector
* custom titles and subtitles for all plots
* add logo/icon and custom spinner
* restructure directories and connect/home/overview pages

# milQuant 0.2.1 _2022-05-15_

* uses idaifieldR v0.2.1
* WIP

# milQuant 0.2.0 _2022-05-15_

* First executable version
* login screen to change connection details (ip, username, password) to suit different field clients and projects
* contains plot generation and download for: find overview, pottery (single), pottery quantification forms A & B from the milt-configuration, loomweight (milet configuration)
* uses idaifieldR v0.2
* not perfect, but currently working for miletus
