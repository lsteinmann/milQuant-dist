# milQuant - Quantitative Analysis with Data from iDAI.field 2

The milQuant-Shiny Dashboard provides quick quantitative overviews of the data in an [iDAI.field](https://github.com/dainst/idai-field)-project. It connects to the database automatically (when running on the same machine) and can plot various graphs to provide (currently very limited) quantitative visualizations for the project. It has been developed and is meant to be used with the milet-configuration and within the framework of the [Miletus Excavation Project](https://www.kulturwissenschaften.uni-hamburg.de/ka/forschung/lebensformen-megapolis.html). However, some functionality and general overviews also work with other project-configurations. In any case, the App can be adapted to work for different configurations! Feel free to modify it according to your needs. 

![Screenshot from the Dashboard](readme/readme_screenshot.png "Screenshot from the Dashboard")

## Current Status

The main functionality of the dashboard is currently operational. On load, a login screen asks the user to input the address for synchronization and the password. Projects can be switched while the app is running. Currently, there is only a broad overview of resource types and a flexible plot form for pottery resources available. For projects using the milet-configuration, the pottery quantification forms can also be evaluated.

## Dependencies

This app uses the [idaifieldR](https://github.com/lsteinmann/idaifieldR) package currently only available on GitHub to import data from iDAI.field into R. 

```
devtools::install_github("lsteinmann/idaifieldR", build_vignettes = TRUE)
```

Apart from that there is a variety of other packages used in this app, all of which can be found on CRAN: 

```
require("shiny", "shinyjs", "shinyWidgets", "shinydashboard", "ggplot2", "dplyr", "reshape2", "forcats", "tidyr", "viridis")
```

## Adaptation

Feel free to download and adapt this to you own needs. If you wish to try the app, you only need to clone the repository, open the project in R-Studio and click on "Run App" with "app.R" from the main directory open. Make sure to enter your local IP address and the password your client uses for synchronization. You can find this info in the settings of you iDAI.field Client. The app can only work if the client is running.
