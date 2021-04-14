## app.R ##
library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(forcats)
library(viridis)

source("source/get_data.R")
source("source/vars_funs.R")

header <- dashboardHeader(title = img(src = "Logo.png",
                                      height = 44,
                                      width = 45))

sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("Home", tabName = "home", icon = icon("graduation-cap"),
                 badgeLabel = "new"),
        menuItem("Pottery", tabName = "pottery_all", icon = icon("mug-hot"),
                 menuSubItem("Pottery (single)", tabName = "pottery", icon = icon("mug-hot")),
                 menuSubItem("Pottery Quantification A", tabName = "potteryQA", icon = icon("mug-hot")),
                 menuSubItem("Pottery Quantification B", tabName = "potteryQB", icon = icon("mug-hot"))
                ),
        menuItem("Sculpture", tabName = "sculpture", icon = icon("horse-head"),
                 badgeLabel = "new", badgeColor = "green"),
        menuItem("Issues / Contact", icon = icon("file-code-o"),
                 href = "https://github.com/lsteinmann/milQuant")
    )
)

source("source/body.R")

ui <- dashboardPage(header, sidebar, body)

server <- function(input, output, session) {

    source('source/server/overview_inout.R', local = TRUE)
    source('source/server/pottery_inout.R', local = TRUE)


}

shinyApp(ui, server)
