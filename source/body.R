
source("source/tabs/pottery_tab.R")
source("source/tabs/potteryQA_tab.R")
source("source/tabs/potteryQB_tab.R")
source("source/tabs/sculpture_tab.R")
source("source/tabs/buildings_tab.R")

body <- dashboardBody(
  tabItems(
    # First tab content
    tabItem(tabName = "home",
            h2("Welcome to milQuant - Quantitative Analysis with Data from iDAI.field"),
            fluidRow(
              infoBox(
                title = "This is a test.",
                value = "This App is meant to be used with the Miletus-configuration and has only been tested on data sets from that config.",
                icon = icon("vial"),
                color = "teal",
                width = 10),
              valueBox(
                uiOutput("overview_n"),
                "Total Resources",
                icon = icon("file-alt"),
                color = "teal",
                width = 2
              )

            ),
            fluidRow(
              box(title = "Overview", status = "primary",
                  solidHeader = TRUE, collapsible = FALSE,
                  width = 12, height = 600,
                  plotOutput("overview"))
              )
            ),
    # Pottery tabs content
    pottery_tab,
    potteryQA_tab,
    potteryQB_tab,



    # Sculpture tab content
    sculpture_tab,

    # Buildings tab
    buildings_tab
  )
)
