potteryQA_tab <- tabItem(
  tabName = "potteryQA",
  h1("Charts from Form: Pottery Quantification A"),
  fluidRow(
    infoBox(title = "titel", value = textOutput("potQA_overview"),
            icon = icon("list-alt"),
            color = "orange", width = 12),
  ),
  fluidRow(
    box(
      width = 3, height = 500,
      htmlOutput("QA_layer_selector"),
      prettyRadioButtons(inputId = "QApotPlot_1_display",
                   label = "Display Options", icon = icon("check"),
                   inline = FALSE, animation = "jelly",
                   choices = list("Context on x-Axis" = "x",
                                  "Context as color" = "fill",
                                  "Do not display Context" = "none")),
      prettyRadioButtons(inputId = "QApotPlot_1_bars",
                   label = "Position of Bars", icon = icon("check"),
                   inline = TRUE, animation = "jelly",
                   choices = list("Dodged Bars" = "dodge",
                                  "Stacked Bars" = "stack")),
      downloadButton("QApotPlot_1_png", label = "Download plot (png)"),
      downloadButton("QApotPlot_1_pdf", label = "Download plot (pdf)")
    ),
    box(
      width = 9, height = 500,
      plotOutput("QApotPlot_1")
    )
  )

)
