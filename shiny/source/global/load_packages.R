packages <- c("shiny", "shinydashboard",
              "shinycssloaders", "shinyjs", "shinyWidgets",
              "ggplot2", "dplyr", "reshape2", "viridis", "forcats", "tidyr",
              "remotes", "idaifieldR",
              "glue")

for (p in packages) {
  if (!suppressWarnings(require(p, character.only = TRUE))) {
    if (p == "idaifieldR") {
      remotes::install_github("lsteinmann/idaifieldR@v0.2.2")
    } else {
      install.packages(p, repos = "https://cloud.r-project.org")
    }
  } else if (p == "idaifieldR") {
    if (packageVersion("idaifieldR") != "0.2.2") {
      unloadNamespace("idaifieldR")
      remotes::install_github("lsteinmann/idaifieldR@v0.2.2")
    }
  }
  library(p, character.only = TRUE)
}
rm(packages, p)
