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
      width = 3, height = 600,
      textInput(inputId = "bricksQPlot_1_title", label = "Title",
                placeholder = "Enter title here"),
      textInput(inputId = "bricksQPlot_1_subtitle", label = "Subtitle",
                placeholder = "Enter subtitle here"),
      htmlOutput("bricksQ_layer_selector"),
      downloadButton("bricksQPlot_1_png", label = "Download plot (png)"),
      downloadButton("bricksQPlot_1_pdf", label = "Download plot (pdf)")
    ),
    box(
      width = 9, height = 600,
      plotOutput("bricksQPlot_1", height = 570) %>% mq_spinner()
    )
  )
)
