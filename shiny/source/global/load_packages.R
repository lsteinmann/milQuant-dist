packages <- c("shiny", "shinydashboard",
              "shinycssloaders", "shinyjs", "shinyWidgets",
              "ggplot2", "plotly", "viridis",
              "dplyr", "reshape2", "forcats", "tidyr", "DT",
              "remotes", "idaifieldR",
              "glue")

idf_version <- "0.2.3"

for (p in packages) {
  if (!suppressWarnings(require(p, character.only = TRUE))) {
    if (p == "idaifieldR") {
      remotes::install_github(paste0("lsteinmann/idaifieldR@v", idf_version))
    } else {
      install.packages(p, repos = "https://cloud.r-project.org")
    }
  } else if (p == "idaifieldR") {
    if (packageVersion("idaifieldR") != idf_version) {
      unloadNamespace("idaifieldR")
      remotes::install_github(paste0("lsteinmann/idaifieldR@v", idf_version))
    }
  }
  library(p, character.only = TRUE)
}
rm(packages, p)
