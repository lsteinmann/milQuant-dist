packages <- c("shiny", "shinydashboard", "ggplot2", "dplyr", "reshape2",
              "forcats", "remotes", "idaifieldR", "shinyWidgets", "tidyr",
              "viridis",
              #"leaflet", "sp", "rgdal", "rgeos",
              "shinycssloaders", "shinyjs", "glue")
for (p in packages) {
  if(!require(p, character.only = TRUE)) {
    if (p == "idaifieldR") {
      remotes::install_github("lsteinmann/idaifieldR")
    } else {
      install.packages(p)
    }
  }
  library(p, character.only = TRUE)
}
rm(packages, p)
