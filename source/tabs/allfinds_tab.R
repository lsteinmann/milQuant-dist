allfinds_tab <- tabItem(
  tabName = "allfinds",
  h1("Overview of all find resources"),
  fluidRow(
    infoBox(title = "Info", value = textOutput("allFinds_overview"),
            icon = icon("list"),
            color = "olive", width = 10),
    valueBox(
      uiOutput("allfinds_n"),
      "Total Resources",
      icon = icon("file"),
      color = "olive",
      width = 2)
  ),
  fluidRow(
    box(
      width = 3, height = 700,
      textInput(inputId = "allFinds_title", label = "Title",
                value = "Distribution of Find-Categories"),
      textInput(inputId = "allFinds_subtitle", label = "Subtitle",
                placeholder = "Enter subtitle here"),
      uiLayerSelector("allFinds_layers"),
      htmlOutput("allFinds_var_selector"),
      prettyRadioButtons(inputId = "allFinds_axis",
                   label = "Choose how to display the selected variable",
                   choices = list("as Colour" = "var_is_fill",
                                  "on X-Axis" = "var_is_x"),
                   icon = icon("check"),
                   inline = TRUE, animation = "jelly"),
      prettyRadioButtons(inputId = "allFinds_bars",
                   label = "Choose how to display the bars",
                   choices = list("stacked" = "stack",
                                  "dodging" = "dodge",
                                  "percentage" = "fill"),
                   icon = icon("check"),
                   inline = TRUE, animation = "jelly"),
      htmlOutput("allFinds_period_selector"),
      downloadPlotButtons("allFindsPlot_download")
    ),
    box(
      width = 9, height = 700,
      plotlyOutput("allFindsPlot", height = 670) %>% mq_spinner())
  )
)
