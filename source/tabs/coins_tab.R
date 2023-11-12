coins_tab <- tabItem(
  tabName = "coins",
  h1("Charts from Form: Coins"),
  fluidRow(
    infoBox(title = "Info", value = textOutput("coins_overview"),
            icon = icon("list"),
            color = "olive", width = 12),
  ),
  fluidRow(
    box(width = 3, height = 650,
        textInput(inputId = "coinsPlot_1_title", label = "Title",
                  placeholder = "Enter title here"),
        textInput(inputId = "coinsPlot_1_subtitle", label = "Subtitle",
                  placeholder = "Enter subtitle here"),
        uiLayerSelector("coins_layers"),

        htmlOutput("coinsPlot_1_period_selector"),
        downloadPlotButtons("coinsPlot_1_download")
    ),
    box(
      width = 9, height = 650,
      plotlyOutput("coinsPlot_1", height = 620) %>% mq_spinner()
    )


  )
)
