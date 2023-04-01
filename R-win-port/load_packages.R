packages <- c("shiny", "shinydashboard", "shinycssloaders", "shinyjs", "shinyWidgets",
              "ggplot2", "dplyr", "reshape2", "viridis", "forcats", "tidyr", "DT",
              "remotes", "idaifieldR", "sofa", "plotly",
              "glue")
for (p in packages) {
    if (p == "idaifieldR") {
      remotes::install_github("lsteinmann/idaifieldR@v0.2.4", lib = "library/", force = TRUE)
    } else {
      install.packages(p, lib = "library/", repos='http://cran.us.r-project.org')
    }
}
rm(packages, p)