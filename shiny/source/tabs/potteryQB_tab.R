potteryQB_tab <- tabItem(
  tabName = "potteryQB",
  h1("Charts from Form: Pottery Quantification B"),
  fluidRow(
    infoBox(title = "Info", value = textOutput("potteryQB_overview"),
            icon = icon("list"),
            color = "olive", width = 12),
  ),
  fluidRow(
    box(
      width = 3, height = 650,
      textInput(inputId = "potteryQBPlot_1_title", label = "Title",
                value = "", placeholder = "Enter title here"),
      textInput(inputId = "potteryQBPlot_1_subtitle", label = "Subtitle",
                placeholder = "Enter subtitle here"),
      uiLayerSelector("potteryQB_layers"),
      prettyRadioButtons(inputId = "potteryQBPlot_1_display_context",
                         label = "Display Options", icon = icon("check"),
                         inline = FALSE, animation = "jelly",
                         choices = list("Do not display Context" = "none",
                                        "Context as Subplot" = "wrap")),
      prettyRadioButtons(inputId = "potteryQBPlot_1_display_xaxis",
                         label = "Display Options", icon = icon("check"),
                         inline = FALSE, animation = "jelly",
                         choices = list("Function on x-axis" = "function",
                                        "Period on x-axis" = "period")),
      prettyRadioButtons(inputId = "potteryQBPlot_1_bars",
                   label = "Position of Bars", icon = icon("check"),
                   inline = TRUE, animation = "jelly",
                   choices = list("Dodged Bars" = "dodge",
                                  "Stacked Bars" = "stack")),
      htmlOutput("potteryQBPlot_1_period_selector"),
      downloadPlotButtons("potteryQBPlot_1_download")
    ),
    box(
      width = 9, height = 650,
      plotlyOutput("potteryQBPlot_1", height = 620) %>% mq_spinner()
    )
  )
)
