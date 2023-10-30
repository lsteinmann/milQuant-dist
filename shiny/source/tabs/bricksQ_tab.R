bricksQ_tab <- tabItem(
  tabName = "bricksQ",
  h1("Charts from Form: Brick Quantification"),
  fluidRow(
    infoBox(title = "Info", value = textOutput("bricksQ_overview"),
            icon = icon("list"),
            color = "olive", width = 12),
  ),
  fluidRow(
    box(
      width = 3, height = 650,
      textInput(inputId = "bricksQPlot_1_title", label = "Title",
                placeholder = "Enter title here"),
      textInput(inputId = "bricksQPlot_1_subtitle", label = "Subtitle",
                placeholder = "Enter subtitle here"),
      htmlOutput("bricksQ_layer_selector"),
      downloadPlotButtons("bricksQPlot_1_download")
    ),
    box(
      width = 9, height = 650,
      plotlyOutput("bricksQPlot_1", height = 620) %>% mq_spinner()
    )
  )
)
