potteryQB_tab <- tabItem(
  tabName = "potteryQB",
  h1("Charts from Form: Pottery Quantification B"),
  fluidRow(
    infoBox(title = "titel", value = textOutput("potQB_overview"),
            icon = icon("list-alt"),
            color = "orange", width = 12),
  ),
  fluidRow(
    box(
      width = 3, height = 500,
      htmlOutput("QB_layer_selector"),
      prettyRadioButtons(inputId = "QBpotPlot_1_display",
                   label = "Display Options", icon = icon("check"),
                   inline = FALSE, animation = "jelly",
                   choices = list("Context as Color" = "fill",
                                  "Context as Subplot" = "wrap",
                                  "Do not display Context" = "none")),
      prettyRadioButtons(inputId = "QBpotPlot_1_bars",
                   label = "Position of Bars", icon = icon("check"),
                   inline = TRUE, animation = "jelly",
                   choices = list("Dodged Bars" = "dodge",
                                  "Stacked Bars" = "stack")),
      downloadButton("QBpotPlot_1_png", label = "Download plot (png)"),
      downloadButton("QBpotPlot_1_pdf", label = "Download plot (pdf)")
    ),
    box(
      width = 9, height = 500,
      plotOutput("QBpotPlot_1")
    )
  )

)
