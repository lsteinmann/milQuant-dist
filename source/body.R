
source("source/tabs/connect.R")
source("source/tabs/pottery_tab.R")
source("source/tabs/potteryQA_tab.R")
source("source/tabs/potteryQB_tab.R")
source("source/tabs/sculpture_tab.R")
source("source/tabs/buildings_tab.R")

body <- dashboardBody(
  tabItems(
    # First tab content
    tabItem(tabName = "home",
            fluidPage(
              fluidRow(
                h2("Welcome to milQuant - Quantitative Analysis
                   with Data from iDAI.field"),
                   p("With this App, you can view and download various
                   plots of data from an iDAI.field-Database,
                   that is otherwise usually inaccessible.
                   In order for the App to work, you need to have
                   iDAI.field 2 or Field Desktop running on your computer.
                   Below are a few settings that probably need to be adjusted
                   before you can start.")
                ),
              fluidRow(
                column(6,
                       fluidRow(uiOutput("select_project"))),
                column(6,
                       fluidRow(uiOutput("select_place")))
              ),



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
            )),
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
