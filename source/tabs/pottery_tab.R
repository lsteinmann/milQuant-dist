


pottery_tab <- tabItem(tabName = "pottery",
        h2("Pottery"),
        fluidRow(
                box(
                        width = 12, height = 100, status = "primary",
                        selectInput("operation", "Choose an Operation:",
                                    choices = operations)
                )
        ),
        fluidRow(
                box(
                        width = 12, height = 70, status = "warning",
                        verbatimTextOutput("pottery_overview")
                )
        ),
        fluidRow(
                box(
                        width = 3, height = 500,
                        htmlOutput("layer_selector"),
                        htmlOutput("potPlot_1_x_selector"),
                        htmlOutput("potPlot_1_fill_selector"),
                        downloadButton("potPlot_1_png", label = "Download plot (png)"),
                        downloadButton("potPlot_1_pdf", label = "Download plot (pdf)")
                ),
                box(
                        width = 9, height = 500,
                        plotOutput("potPlot_1")
                )
        )

)
