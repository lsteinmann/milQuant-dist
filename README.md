# milQuant -- Quantitative Analysis with Data from Field Desktop (Standalone electron app) <a href='https://www.miletgrabung.uni-hamburg.de/'><img src='shiny/www/quant-icon.png' align="right" height="139" /></a>

The milQuant-Shiny Dashboard provides quick quantitative overviews of the data in a [Field Desktop](https://github.com/dainst/idai-field)-project. It can connect to any database Client in the same Local Area Network and can plot various graphs to provide quantitative visualizations for the project focused on find-resources.

The dashboard has been developed and is meant to be used with the milet-configuration and within the framework of the [Miletus Excavation Project](https://www.miletgrabung.uni-hamburg.de/). While very limited, some functionality and general overviews may also work with other project-configurations. The repository of the shiny-dashboard is located at [lsteinmann/milQuant](https://github.com/lsteinmann/milQuant).

## Usage
This distribution is meant for the team of the Miletus Excavation. If you encounter a white screen after startup, select View > Reload or restart the app. On load, a login screen asks the user to input the address for synchronization and the password. The preset adress will usually work (except for the password). The password is the password recorded in your Field Desktop app under "settings". You can safe default settings for the app under "*Settings*" > "*Change connection settings*". After connecting, select a project in the main screen and click "Load Database". With the Miletus database, and depending on your computer, loading it may take a minute or two. 

#### Refresh Index
When pressing the *Refresh Index* button, milQuant will import the index of the selected project database again. This way you can get new resources that have been entered while milQuant was running without restarting the app. This takes as long as loading the database to begin with. 

#### Project overview
This plot gives a very broad overview on all resources in the project database. It simply shows how many resources of each type (e.g. Pottery, Coin, Layer) are present in the database and informs you of the total number of resources in the upper right corner. 

### Sidebar selection: Places, Operations, Trenches
In the sidebar to the left, select an 'Operation' (meaning a Place or a Group of Trenches) to work with, e.g. 'Insula UV/8-9' for our current project. In the dropdown below, need to select the trenches you want to work with. This selection process exists solely to make working with the app easier and faster. Generally, the more *Operations* / *Places* / *Trenches* you select, the longer it will take to load the plots. This selection impacts all the other tabs you can see in the sidebar below the two dropdowns. Only resources from the selected *Operations* will be loaded in those tabs. (Categories of Operations are: *Maßnahme/Operation*, *Schnitt/Trench*, *Bauwerk/Building*, *Survey-Areal/Survey*.)

#### Workflow
The workflow tab lists all resources were certain checkboxes in the *Workflow*-field have been ticked or not, and is meant to give an overview of the state of find processing and help with finding specific resources to work on. 

#### Finds Overview
The "Finds Overview"-tabs display all the different categories of *Find* resources at once, selected by the layers you can choose from the dropdown next to the plot. There is one tab for inventoried finds, which means single finds where one object has its own database resource, and a tab for displaying all different kinds of find quantifications together. 

#### Pottery
The variable and color-selector of the pottery plot is automatically generated, and may contain many variables that you deem unusable. The period selector can be used to display only objects dated between two specific periods. I have not solved the problem of displaying multiple periods yet, though the selector works well in this case. I also still need to remove the period "groups" from this selector. You can choose between the the single find pottery, and the two forms of quantification. 

#### Bricks and Tiles
Same as with pottery, there is one tab for barplots of single finds, and one tab for the evaluation of brick quantification forms. 

#### Coins
There is a regular barplot for coins, as well as a currently not very useful 'aoristic' plot that shows the distribution of dating for the selected coins. For more info on this, see [datplot](https://doi.org/10.1017/aap.2021.8). 

#### Loomweights
The barplot for loomweights works just as the one for pottery and bricks. The histogram plot is a bit more curated. Here, you may want to select only complete loomweights using the radio buttons. The number of bins of the histogram can be adjusted, and using the "weight range" selector you can remove outliers from the plot (if you so wish), or only look at loomweights of a certain weight group. 

#### Other finds
All the tabs you can see under the 'Other finds'-group contain automatically generated barplots. They are not produced with a lot of love, but they are functional and at least give you the option of looking at these finds. 

### General
All plots can be given custom titles and subtitles. As most of the plots are generated with plotly, you can get some information by hovering your cursor over the bars, or use the plotly options in the upper right corner to modify the plot. You can also play with the legend. The plots can be saved as an HTML using the Download-button. If you want to export the plot as an image, you can click on the camera icon in the upper right corner of the plot when hovering the cursor over it. In many plots, you can click on a bar to display a table of all objects that would be contained in that (section of the) bar, and even select which columns to display in the table. 

## Dependencies and other info

This app uses the [idaifieldR](https://github.com/lsteinmann/idaifieldR) package (not on CRAN) to import data from Field Desktop. For more info about the package, see [this article](https://doi.org/10.34780/068b-q6c7). Apart from that there is a variety of other packages used in the dashboard, all of which can be found on CRAN and are automatically installed when trying to run the app.

This repository contains a distributable version of milQuant built with electron and based off [electron-quick-start](https://github.com/electron/electron-quick-start) and [COVAIL](https://github.com/COVAIL/electron-quick-start/blob/master/main.js) (see also: [lsteinmann/shiny-electron](https://github.com/lsteinmann/shiny-electron).) The directory R-win-port (locally) contains an R-portable distribution for windows, which I do not include in the online repository, but is packed in the downloadable exe attached to each release. 
