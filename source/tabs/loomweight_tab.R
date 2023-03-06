
loomweight_tab <- tabItem(
  tabName = "loomweights",
    h1("Charts from Form: Loomweight"),
    fluidRow(
      infoBox(title = "Info", value = textOutput("loomweight_overview"),
              icon = icon("list"),
              color = "olive", width = 12),
    ),
    fluidRow(
      box(width = 3, height = 750,
          textInput(inputId = "lwPlot_1_title", label = "Title",
                    placeholder = "Enter title here"),
          textInput(inputId = "lwPlot_1_subtitle", label = "Subtitle",
                    placeholder = "Enter subtitle here"),
          htmlOutput("LW_layer_selector"),
          sliderInput(inputId = "bins", label = "Number of bins:",
                      min = 1,
                      max = 100,
                      value = 30),
          htmlOutput("lwplot_1_fill_selector"),
          prettyRadioButtons("lw_condition_filter",
                       label = "Filter for condition:",
                       icon = icon("check"),
                       inline = TRUE, animation = "jelly",
                       choices = list("complete" = "intakt",
                                      "75% to complete" = "75-100",
                                      "display all objects" = "all"),
                       selected = "intakt"),
          htmlOutput("lw_weight_slider"),
          htmlOutput("LW_period_selector"),
          downloadButton("lwPlot_1_png", label = "Download plot (png)"),
          downloadButton("lwPlot_1_pdf", label = "Download plot (pdf)")
      ),
      box(
        width = 9, height = 750,
        plotlyOutput("lwPlot_1", height = 720) %>% mq_spinner()
      )


    )


)
