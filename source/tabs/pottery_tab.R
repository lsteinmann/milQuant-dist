
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
                        width = 3, height = 600,
                        htmlOutput("POT_layer_selector"),
                        htmlOutput("potPlot_1_x_selector"),
                        htmlOutput("potPlot_1_fill_selector"),
                        htmlOutput("potPlot_1_period_selector"),
                        p("Please note: The period selector currently only works for the milet-configuration."),
                        downloadButton("potPlot_1_png", label = "Download plot (png)"),
                        downloadButton("potPlot_1_pdf", label = "Download plot (pdf)")
                ),
                box(
                        width = 9, height = 600,
                        plotOutput("potPlot_1", height = 570) %>% mq_spinner()
                )
        )
)
