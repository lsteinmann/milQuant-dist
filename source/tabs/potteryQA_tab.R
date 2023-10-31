potteryQA_tab <- tabItem(
  tabName = "potteryQA",
  h1("Charts from Form: Pottery Quantification A"),
  fluidRow(
    infoBox(title = "Info", value = textOutput("potQA_overview"),
            icon = icon("list"),
            color = "olive", width = 12),
  ),
  fluidRow(
    box(
      width = 3, height = 650,
      textInput(inputId = "QApotPlot_1_title", label = "Title",
                value = "", placeholder = "Enter title here"),
      textInput(inputId = "QApotPlot_1_subtitle", label = "Subtitle",
                placeholder = "Enter subtitle here"),
      uiLayerSelector("QA_layers"),
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
      downloadPlotButtons("QApotPlot_1_download")
    ),
    box(
      width = 9, height = 650,
      plotlyOutput("QApotPlot_1", height = 620) %>% mq_spinner()
    )
  )
)
