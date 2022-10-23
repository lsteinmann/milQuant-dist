
bricks_tab <- tabItem(
  tabName = "bricks",
  fluidPage(
    h1("Charts from Form: Bricks and Tiles"),
    fluidRow(
      infoBox(title = "Info", value = textOutput("bricks_overview"),
              icon = icon("list"),
              color = "olive", width = 12),
    ),
    fluidRow(
      box(width = 3, height = 600,
          htmlOutput("bricks_layer_selector"),
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
          downloadButton("bricksPlot_1_png", label = "Download plot (png)"),
          downloadButton("bricksPlot_1_pdf", label = "Download plot (pdf)")
      ),
      box(
        width = 9, height = 600,
        plotOutput("bricksPlot_1", height = 570) %>% mq_spinner()
      )


    )

  )

)
