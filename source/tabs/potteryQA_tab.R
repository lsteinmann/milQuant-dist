potteryQA_tab <- tabItem(
  tabName = "potteryQA",
  h1("Charts from Form: Pottery Quantification A"),
  fluidRow(
    infoBox(title = "Info", value = textOutput("potQA_overview"),
            icon = icon("list-alt"),
            color = "teal", width = 12),
  ),
  fluidRow(
    box(
      width = 3, height = 600,
      htmlOutput("QA_layer_selector"),
      prettyRadioButtons(inputId = "QApotPlot_1_display",
                   label = "Display Options", icon = icon("check"),
                   inline = FALSE, animation = "jelly",
                   choices = list("Do not display Context" = "none",
                                  "Context as color" = "fill",
                                  "Context on x-Axis" = "x")),
      prettyRadioButtons(inputId = "QApotPlot_1_bars",
                   label = "Position of Bars", icon = icon("check"),
                   inline = TRUE, animation = "jelly",
                   choices = list("Dodged Bars" = "dodge2",
                                  "Stacked Bars" = "stack")),
      downloadButton("QApotPlot_1_png", label = "Download plot (png)"),
      downloadButton("QApotPlot_1_pdf", label = "Download plot (pdf)")
    ),
    box(
      width = 9, height = 600,
      plotOutput("QApotPlot_1", height = 570)
    )
  )

)
