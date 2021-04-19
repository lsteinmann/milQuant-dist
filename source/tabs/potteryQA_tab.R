potteryQA_tab <- tabItem(
  tabName = "potteryQA",
  h1("Charts from Form: Pottery Quantification A"),
  fluidRow(
    box(
      width = 3, height = 500,
      htmlOutput("QA_layer_selector"),
      radioButtons(inputId = "QApotPlot_1_display",
                   label = "x-Axis",
                   inline = TRUE,
                   choices = list("Context on x-Axis" = "x",
                                  "Context as color" = "fill")),
      radioButtons(inputId = "QApotPlot_1_bars",
                   label = "Position of Bars",
                   inline = TRUE,
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
