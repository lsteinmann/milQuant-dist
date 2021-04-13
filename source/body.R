body <- dashboardBody(
  tabItems(
    # First tab content
    tabItem(tabName = "home",
            h2("Welcome to milQuant - Quantitative Analysis from iDAI.field 2"),
            fluidRow(
              box(title = "Overview", status = "primary",
                  solidHeader = TRUE, collapsible = TRUE,
                  width = 12, height = 600,
                  plotOutput("overview",
                             height = 250))
            )
    ),
    # Pottery tab content
    tabItem(tabName = "pottery",
            h2("Pottery")
    ),



    # Sculpture tab content
    tabItem(tabName = "sculpture",
            h2("Sculpture")
    )
  )
)
