
loomweight_tab <- tabItem(
  tabName = "loomweights",
  fluidPage(
    h1("Charts from Form: Loomweight"),
    fluidRow(
      infoBox(title = "Info", value = textOutput("loomweight_overview"),
              icon = icon("list-alt"),
              color = "olive", width = 12),
    ),
    fluidRow(
      box(width = 3, height = 600,
          htmlOutput("LW_layer_selector"),
          sliderInput(inputId = "bins", label = "Number of bins:",
                      min = 1,
                      max = 100,
                      value = 30),
          htmlOutput("lwplot_1_fill_selector"),
          radioButtons("lw_condition_filter",
                       label = "Filter for condition:",
                       choices = list("complete" = "intakt",
                                      "75% to complete" = "Fragmentarisch_75-100",
                                      "display all objects" = "all"),
                       selected = "all", inline = TRUE),
          htmlOutput("lw_weight_slider"),
          htmlOutput("LW_period_selector"),
          downloadButton("lwPlot_1_png", label = "Download plot (png)"),
          downloadButton("lwPlot_1_pdf", label = "Download plot (pdf)")
      ),
      box(
        width = 9, height = 600,
        plotOutput("lwPlot_1", height = 570) %>% mq_spinner()
      )


    )

  )

)
