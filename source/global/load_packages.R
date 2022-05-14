packages <- c("shiny", "shinydashboard", "ggplot2", "dplyr", "reshape2",
              "forcats", "idaifieldR", "shinyWidgets", "tidyr", "viridis",
              #"leaflet", "sp", "rgdal", "rgeos",
              "shinyjs", "glue")
for (p in packages) {
  if(!require(p, character.only = TRUE)) {
    if (p == "idaifieldR") {
      devtools::install_github("lsteinmann/idaifieldR")
    } else {
      install.packages(p)
    }
  }
  library(p, character.only = TRUE)
}
rm(packages, p)
