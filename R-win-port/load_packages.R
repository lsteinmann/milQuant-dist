packages <- c("shiny", "shinyWidgets", "glue")

for (p in packages) {
  install.packages(p, lib = "library/")#, dependencies = TRUE)
  # or try something with automagic?
}
rm(packages, p)
