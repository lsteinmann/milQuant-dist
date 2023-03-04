
pottery_tab <- tabItem(
        tabName = "pottery",
        h1("Charts from Form: Pottery"),
        fluidRow(
                infoBox(title = "Info", value = textOutput("pottery_overview"),
                        icon = icon("list"),
                        color = "olive", width = 12),
        ),
        fluidRow(
                box(
                        width = 3, height = 650,
                        textInput(inputId = "potPlot_title", label = "Title",
                                  placeholder = "Enter title here"),
                        textInput(inputId = "potPlot_subtitle", label = "Subtitle",
                                  placeholder = "Enter subtitle here"),
                        htmlOutput("POT_layer_selector"),
                        htmlOutput("potPlot_1_x_selector"),
                        htmlOutput("potPlot_1_fill_selector"),
                        prettyRadioButtons(inputId = "potPlot_1_bars",
                                     label = "Choose how to display the bars",
                                     icon = icon("check"),
                                     inline = TRUE, animation = "jelly",
                                     choices = list("stacked" = "stack",
                                                    "dodging" = "dodge",
                                                    "percentage" = "fill")),
                        htmlOutput("potPlot_1_period_selector"),
                        p("Please note: The period selector currently only works for the milet-configuration."),
                        downloadButton("potPlot_1_png", label = "Download plot (png)"),
                        downloadButton("potPlot_1_pdf", label = "Download plot (pdf)")
                ),
                box(
                        width = 9, height = 650,
                        plotlyOutput("potPlot_1", height = 620) %>% mq_spinner()
                )
        ),
        fluidRow(
          box(width = 12,
              h1("Click a bar to display object table"),
              htmlOutput("potPlot_1_clickData_check"),
              dataTableOutput("potPlot_1_clickData")
          )
        )
)
