home_tab <- tabItem(
  tabName = "home",
  title = "Home",

  fluidPage(
    fluidRow(
      infoBox(
        title = "Development",
        value = "This App is still under development. However, just try it!",
        icon = icon("vial"),
        color = "teal",
        width = 10),
      valueBox(
        uiOutput("overview_n"),
        "Total Resources",
        icon = icon("file-alt"),
        color = "teal",
        width = 2)),
    fluidRow(
      box(title = "Overview", status = "primary",
          solidHeader = TRUE, collapsible = FALSE,
          width = 12, height = 600,
          plotOutput("overview")))
  )
)
