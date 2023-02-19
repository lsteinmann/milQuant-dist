packages <- c("shiny", "shinydashboard",
              "shinycssloaders", "shinyjs", "shinyWidgets",
              "ggplot2", "dplyr", "reshape2", "viridis", "forcats", "tidyr",
              "remotes", "idaifieldR", "sofa",
              "glue")

for (p in packages) {
    if (p == "idaifieldR") {
      remotes::install_github("lsteinmann/idaifieldR@v0.2.2", lib = "../library/", force = TRUE)
    } else {
      install.packages(p, lib = "../library/")#, dependencies = TRUE)
    }
}
rm(packages, p)
