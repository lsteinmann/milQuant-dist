# shiny-electron

This is totally hacked together from different tutorials and I do not recommend copying any of it. 

Template from: [electron-quick-start](https://github.com/electron/electron-quick-start)

Copied main.js from [COVAIL](https://github.com/COVAIL/electron-quick-start/blob/master/main.js), since that is the only approach I could get to work with the current template from electron.

See some other tutorials and approaches to deploy shiny with electron: 

* Using electron quick start, all based on each other:
    * [COVAIL](https://github.com/COVAIL/electron-quick-start)
    * [Dirk Schumacher](https://github.com/dirkschumacher/r-shiny-electron)
    * [Travis Hinkelmann](https://github.com/hinkelman/r-shiny-electron)
* [How to Make an R Shiny Electron App](https://github.com/lawalter/r-shiny-electron-app)
* [DesktopDeployR](https://github.com/wleepang/DesktopDeployR)
* [RInno](https://github.com/ficonsulting/RInno)



## Instructions
R-win-port contains the contents of an R-portable distribution (get it from [SourceForge](https://sourceforge.net/projects/rportable/) and copy only the contents of App/R-Portable/, doc and tests can be deleted to safe space, moderately). I manually installed the needed packages to the local R library before continuing (see `R-win-port/bin/load_packages.R`). 


## License

[CC0 1.0 (Public Domain)](LICENSE.md)

Icon from [icon-icons.com](https://icon-icons.com/icon/quant-qnt/245484)