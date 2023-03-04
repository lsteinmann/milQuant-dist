potteryQB_tab <- tabItem(
  tabName = "potteryQB",
  h1("Charts from Form: Pottery Quantification B"),
  fluidRow(
    infoBox(title = "Info", value = textOutput("potQB_overview"),
            icon = icon("list"),
            color = "olive", width = 12),
  ),
  fluidRow(
    box(
      width = 3, height = 650,
      textInput(inputId = "QBpotPlot_1_title", label = "Title",
                value = "", placeholder = "Enter title here"),
      textInput(inputId = "QBpotPlot_1_subtitle", label = "Subtitle",
                placeholder = "Enter subtitle here"),
      htmlOutput("QB_layer_selector"),
      prettyRadioButtons(inputId = "QBpotPlot_1_display",
                         label = "Display Options", icon = icon("check"),
                         inline = FALSE, animation = "jelly",
                         choices = list("Do not display Context" = "none",
                                        "Context as Subplot" = "wrap")),
      prettyRadioButtons(inputId = "QBpotPlot_2_display",
                         label = "Display Options", icon = icon("check"),
                         inline = FALSE, animation = "jelly",
                         choices = list("Function on x-axis" = "function",
                                        "Period on x-axis" = "period")),
      prettyRadioButtons(inputId = "QBpotPlot_1_bars",
                   label = "Position of Bars", icon = icon("check"),
                   inline = TRUE, animation = "jelly",
                   choices = list("Dodged Bars" = "dodge",
                                  "Stacked Bars" = "stack")),
      htmlOutput("QBpotPlot_1_period_selector"),
      downloadButton("QBpotPlot_1_png", label = "Download plot (png)"),
      downloadButton("QBpotPlot_1_pdf", label = "Download plot (pdf)")
    ),
    box(
      width = 9, height = 650,
      plotlyOutput("QBpotPlot_1", height = 620) %>% mq_spinner()
    )
  )
)
