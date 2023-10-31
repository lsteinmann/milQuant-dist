
bricks_tab <- tabItem(
  tabName = "bricks",
  h1("Charts from Form: Bricks and Tiles"),
  fluidRow(
    infoBox(title = "Info", value = textOutput("bricks_overview"),
            icon = icon("list"),
            color = "olive", width = 12),
  ),
  fluidRow(
    box(width = 3, height = 650,
        textInput(inputId = "bricksPlot_1_title", label = "Title",
                  placeholder = "Enter title here"),
        textInput(inputId = "bricksPlot_1_subtitle", label = "Subtitle",
                  placeholder = "Enter subtitle here"),
        uiLayerSelector("bricks_layers"),
        #sliderInput(inputId = "bins", label = "Number of bins:",
        #            min = 1,
        #            max = 100,
        #            value = 30),
        #htmlOutput("lwplot_1_fill_selector"),
        #radioButtons("lw_condition_filter",
        #             label = "Filter for condition:",
        #             choices = list("complete" = "intakt",
        #                            "75% to complete" = "Fragmentarisch_75-100",
        #                            "display all objects" = "all"),
        #             selected = "all", inline = TRUE),
        #htmlOutput("lw_weight_slider"),
        htmlOutput("bricks_period_selector"),
        downloadPlotButtons("bricksPlot_1_download")
    ),
    box(
      width = 9, height = 650,
      plotlyOutput("bricksPlot_1", height = 620) %>% mq_spinner()
    )


  )
)
