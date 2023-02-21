# shiny-electron: build a standalone distributable shiny-app with electron

This is a template to build a standalone shiny-app with [electron-quick-start](https://github.com/electron/electron-quick-start). The main part (`main.js`) is based off [COVAIL](https://github.com/COVAIL/electron-quick-start/) and slightly adjusted. This template will only work for windows. 

In this repository, I merged the updates from [electron-quick-start](https://github.com/electron/electron-quick-start) into the fork from [COVAIL/electron-quick-start](https://github.com/COVAIL/electron-quick-start). As long as I use it myself, I will be fetching updates from [electron-quick-start](https://github.com/electron/electron-quick-start). 

# Some tutorials and a warning
See some other tutorials and approaches to deploy shiny with electron: 

* Using electron quick start:
    * [COVAIL](https://github.com/COVAIL/electron-quick-start)
    * [Dirk Schumacher](https://github.com/dirkschumacher/r-shiny-electron)
    * [Travis Hinkelmann](https://github.com/hinkelman/r-shiny-electron)
* [How to Make an R Shiny Electron App](https://github.com/lawalter/r-shiny-electron-app)
* [DesktopDeployR](https://github.com/wleepang/DesktopDeployR)
* [RInno](https://github.com/ficonsulting/RInno)
* [chasemc/electricShine](https://github.com/chasemc/electricShine)

I just put this together as a reminer for myself and in the hopes that someone might be able to use it. But I don't actually know javascript, so while this all seems to work just fine, please take it with a grain of salt.

# How to make it work
Get a repository with the template and clone it, e.g. into `your-app-dir`. Download R-Portable from [SourceForge](https://sourceforge.net/projects/rportable/) and extract the .exe somewhere temporary. From the resulting folder, move the contents of `./App/R-Portable/` into your cloned repositories `R-win-port`-directory so that it contains: bin, etc, doc, include, library, modules, share, src, Tcl, tests and some files. To safe a moderate amount of space, you can remove the directories `doc` and `tests`. Now, you need to install all the packages you will need for your shiny app into `./R-win-port/library`. As an example, I tried to do that with `./R-win-port/load_packages.R`. You need to run this manually with the `R.exe` located at `./R-win-port/bin/`:

```r
setwd("../")
# check to see if the working directory is 'your-app-dir/R-win-port/'
getwd()
source("load_packages.R")
```
Choose a mirror. This will install a bunch of packages into the local library. Check if they are actually in the right place, i.e. in `./R-win-port/library/`. R should now work. You can try it by setting the working directory to your app directory and running the app, a browser windows with the sample app should open:

```r
setwd("../shiny")
# check to see if the working directory is 'your-app-dir/'
getwd()
source("app.R")
runApp()
```

If this works, you can now try to make electron run it! To do this, you need Node.js with npm installed. You can find some more general instructions and helpful learning resources at [electron-quick-start](https://github.com/electron/electron-quick-start).

Open your `your-app-dir/` in your IDE or a terminal and run:
```bash
# While in 'your-app-dir/', install dependencies:
npm install
# Run the app
npm start
```

If you want to produce a setup and other executables for you app, you need to run:
```bash
# Produce executables etc. of the app
npm make
```
It is configured for windows only, but changing some things in `main.js` again, you should be able to easily make this work for other operating systems. Just make sure to have the correct R-Portable versions available for every OS and have `main.js` point at the correct R-executable. 

## Using your own app

If you want to include your own app, list your apps dependencies in `./R-win-port/load_packages.R` and run it again as explained above. Replace `app.R` in the `shiny`-folder with your own app. You can have `app.R` point to other directories within `your-app-dir/shiny/`. 

Also, though `main.js` kills the R-process on exit: Remember to include 
``` r
session$onSessionEnded(function() {
      stopApp()
    })
```
in the server function of your app, or R/shiny might not stop correctly and block resources untill you force it to quit. For your own custom icon, replace `images/quant-icon.ico`.

## License

Same as [electron-quick-start](https://github.com/electron/electron-quick-start): [CC0 1.0 (Public Domain)](LICENSE.md)
Icon from [icon-icons.com](https://icon-icons.com/icon/quant-qnt/245484)