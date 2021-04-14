


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
                        width = 3, height = 400,
                        selectInput("layer", "Choose one or many contexts",
                                    choices = c("all", uidlist %>%
                                            filter(type == "Layer") %>%
                                            arrange(identifier) %>%
                                            pull("identifier")),
                                    multiple = TRUE),
                        selectInput("types", "Choose variable one (x-axis)",
                                    choices = list("a", "b", "c")),
                        selectInput("types", "Choose variable two (fill)",
                                    choices = list("a", "b", "c"))
                ),
                box(
                        tableOutput("values")
                )
        )

)
