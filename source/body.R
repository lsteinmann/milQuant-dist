
source("source/tabs/pottery_tab.R")
source("source/tabs/potteryQA_tab.R")
#source("source/tabs/potteryQB_tab.R")
source("source/tabs/sculpture_tab.R")

body <- dashboardBody(
  tabItems(
    # First tab content
    tabItem(tabName = "home",
            h2("Welcome to milQuant - Quantitative Analysis with Data from iDAI.field 2"),
            fluidRow(
              infoBox(
                title = "This is a test.",
                icon = icon("vial"),
                color = "yellow",
                width = 8),
              valueBox(
                uiOutput("overview_n"),
                "Total Resources",
                icon = icon("file-alt"),
                color = "teal",
                width = 4
              )

            ),
            fluidRow(
              box(title = "Overview", status = "primary",
                  solidHeader = TRUE, collapsible = FALSE,
                  width = 12, height = 600,
                  plotOutput("overview",
                             height = 250))
              )
            ),
    # Pottery tabs content
    pottery_tab,
    potteryQA_tab,
    #potteryQB_tab,



    # Sculpture tab content
    sculpture_tab
  )
)
