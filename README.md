# milQuant - Quantitative Analysis with Data from Field Desktop (Standalone electron app)

The milQuant-Shiny Dashboard provides quick quantitative overviews of the data in a [Field Desktop](https://github.com/dainst/idai-field)-project. It connects to the database automatically (when running on the same machine) and can plot various graphs to provide quantitative visualizations for the project focused on find-resources. 

The dashboard has been developed and is meant to be used with the milet-configuration and within the framework of the [Miletus Excavation Project](https://www.miletgrabung.uni-hamburg.de/). While very limited, some functionality and general overviews may also work with other project-configurations. In any case, the App could be adapted to work for different configurations! Feel free to modify it according to your needs. 

![Screenshot from the Dashboard: Finds](readme/03_Finds.png "Screenshot from the Dashboard: Finds")
![Screenshot from the Dashboard: Pottery Quantification A](readme/05_Pottery_Quant_A.png "Screenshot from the Dashboard: Pottery Quantification A")
![Screenshot from the Dashboard: Loomweights](readme/07_Loomweights.png "Screenshot from the Dashboard: Loomweights")

## Current Status

The main functionality of the dashboard is currently operational. On load, a login screen asks the user to input the address for synchronization and the password. Projects can be switched while the app is running. 

Please note that in many cases, the app will simply shut down if it encounters an error, as I have implemented virtually no error handling. Currently, you just need to restart it in those cases. It may happen when the app cannot connect, e.g. because Field Desktop is not running. 

## Dependencies

This app uses the [idaifieldR](https://github.com/lsteinmann/idaifieldR) package at version 0.2.2. The package is currently only available on GitHub, and is used to import data from Field Desktop / iDAI.field into R. You can install it using `devtools` or `remotes`, but running milQuant should take care of that automatically.

Apart from that there is a variety of other packages used in the dashboard, all of which can be found on CRAN and are automatically installed when trying to run the app: 
```
require("shiny", "shinydashboard", "shinycssloaders", "shinyjs", "ggplot2", "dplyr", "reshape2", "forcats", "remotes", "idaifieldR", "shinyWidgets", "tidyr", "viridis", "glue")
```

This repository contains a distributable version of milQuant built with electron and based off [electron-quick-start](https://github.com/electron/electron-quick-start) and [COVAIL](https://github.com/COVAIL/electron-quick-start/blob/master/main.js).

The directory R-win-port (locally) contains an R-portable distribution for windows.

Icon from [icon-icons.com](https://icon-icons.com/icon/quant-qnt/245484).

## Adaptation

If you wish to try the app, you only need to clone the repository, open the project in R-Studio and click on "Run App" with "app.R" from the main directory open. Make sure to enter your local IP address and the password your client uses for synchronization. You can find this info in the settings of your Field Desktop Client. The app can only work if the client is running. 

As stated, this app will not be very useful with configurations other than "milet". I would be more than happy is you wanted to adapt this for other configurations, though it may not be easy, as I admit the code is a bit of a mess. But still, feel free to clone and change this to your own needs or contact me if you want to discuss about it.
