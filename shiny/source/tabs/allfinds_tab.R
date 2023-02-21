allfinds_tab <- tabItem(
  tabName = "allfinds",
  h1("Overview of all find types"),
  fluidRow(
    infoBox(title = "Info", value = textOutput("allfinds_overview"),
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
      textInput(inputId = "findPlot_title", label = "Title",
                value = "Distribution of Find-Types"),
      textInput(inputId = "findPlot_subtitle", label = "Subtitle",
                placeholder = "Enter subtitle here"),
      htmlOutput("findPlot_layer_selector"),
      htmlOutput("findPlot_var_selector"),
      radioButtons(inputId = "findPlot_axis",
                   label = "Choose how to display the selected variable",
                   choices = list("as Colour" = "var_is_fill",
                                  "on X-Axis" = "var_is_x"),
                   selected = "var_is_fill",
                   inline = TRUE),
      radioButtons(inputId = "findPlot_bars",
                   label = "Choose how to display the bars",
                   choices = list("stacked" = "stack",
                                  "dodging" = "dodge",
                                  "percentage" = "fill"),
                   selected = "stack",
                   inline = TRUE),
      htmlOutput("findPlot_period_selector"),
      downloadButton("allFindsPlot_png", label = "Download plot (png)"),
      downloadButton("allFindsPlot_pdf", label = "Download plot (pdf)")
    ),
    box(
      width = 9, height = 700,
      plotOutput("allFindsPlot", height = 670, click = "allFindsPlot_click") %>% mq_spinner())
  ),
  fluidRow(
    htmlOutput("allFindsPlot_value"),
    verbatimTextOutput("allFindsPlot_selected_rows")
  )
)
