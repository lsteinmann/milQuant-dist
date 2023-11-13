overview_tab <- tabItem(
  tabName = "overview",
  title = "Overview",

  fluidRow(
    infoBox(
      title = "Info",
      value = "This is an overview of all resources in the selected database, excluding images and types.
        All other tabs display resources from the selected Trenches.",
      icon = icon("vial"),
      color = "light-blue",
      width = 10),
    valueBox(
      uiOutput("overview_n"),
      "Total Resources",
      icon = icon("file"),
      color = "light-blue",
      width = 2)),
  fluidRow(
    box(title = "Overview", status = "primary",
        solidHeader = TRUE, collapsible = FALSE,
        width = 12, height = 750,
        fluidRow(width = 12, height = 670,
                 column(width = 12,
                        plotlyOutput("overview", height = 570) %>%
                          mq_spinner())),

        fluidRow(width = 12, height = 100,
                 title = "Plot Controls",
                 column(width = 1),
                 column(width = 3,
                        prettyRadioButtons(inputId = "overviewPlot_barmode",
                                           label = "bar display",
                                           icon = icon("check"),
                                           inline = TRUE, animation = "jelly",
                                           choices = list("stacked" = "stack",
                                                          "dodging" = "group"))),
                 column(width = 3,
                        prettyRadioButtons(inputId = "overviewPlot_display_x",
                                           label = "x-axis",
                                           icon = icon("check"),
                                           inline = TRUE, animation = "jelly",
                                           choices = list("Place" = "Place",
                                                          "Operation" = "Operation",
                                                          "Category" = "category"),
                                           selected = "Place")),
                 column(width = 3,
                        prettyRadioButtons(inputId = "overviewPlot_display_color",
                                           label = "bar color",
                                           icon = icon("check"),
                                           inline = TRUE, animation = "jelly",
                                           choices = list("Place" = "Place",
                                                          "Operation" = "Operation",
                                                          "Category" = "category"),
                                           selected = "category")),
                 column(width = 2))
        )
    )
)
