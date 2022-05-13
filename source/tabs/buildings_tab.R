buildings_tab <- tabItem(
  tabName = "buildings",
  h2("BLA"),
  fluidRow(
    box(radioButtons(inputId = 1, label = "this doesnt do anything now",
                     choices = list("one", "two", "three"), selected = "one",
                     inline = TRUE))
    )#,
  #fluidRow(
  #  box(width = 12,
  #      leafletOutput("buildings_leaf", height = 750))
  #)
)
