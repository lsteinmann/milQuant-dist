## app.R ##
library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(forcats)
library(reshape2)
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
        selectInput("operation", "Choose Operation to work with",
                    choices = operations, multiple = FALSE,
                    selected = operations[1]),
        menuItem("Pottery", tabName = "pottery_all", icon = icon("trophy"),
                 menuSubItem("Pottery (single)", tabName = "pottery", icon = icon("wine-glass-alt")),
                 menuSubItem("Pottery Quantification A", tabName = "potteryQA", icon = icon("glass-cheers")),
                 menuSubItem("Pottery Quantification B", tabName = "potteryQB", icon = icon("glass-cheers"))
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

    # Operation Selector -- Return the requested dataset
    output$selected_operation <- renderText({
        paste(input$operation)
    })

    milet_active <- reactive({

        get_idaifield_data() %>%
            select_by(by = "isRecordedIn", value = as.character(input$operation))

    })

    source('source/server/overview_inout.R', local = TRUE)
    source('source/server/pottery_inout.R', local = TRUE)
    source('source/server/potteryQA_inout.R', local = TRUE)
    #source('source/server/potteryQB_inout.R', local = TRUE)


}

shinyApp(ui, server)
