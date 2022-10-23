bricksQ_tab <- tabItem(
  tabName = "bricksQ",
  h1("Charts from Form: Brick Quantification"),
  fluidRow(
    infoBox(title = "Info", value = textOutput("bricksQ_overview"),
            icon = icon("list"),
            color = "olive", width = 12),
  )
)
