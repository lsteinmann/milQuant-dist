## app.R ##
source("source/load_packages.R")
source("source/get_data.R")
source("source/global_vars.R")
source("source/helpers.R")

header <- dashboardHeader(title = img(src = "loewe.png",
                                      height = 44))


sidebar <- dashboardSidebar(
    sidebarMenu(
        selectInput("operation", "Choose an Area or Survey to work with",
                    choices = operations, multiple = FALSE,
                    selected = operations[1]),
        menuItem("Home", tabName = "home", icon = icon("graduation-cap")),
        menuItem("Pottery", tabName = "pottery_all", icon = icon("trophy"),
                 menuSubItem("Pottery (single)", tabName = "pottery", icon = icon("wine-glass-alt")),
                 menuSubItem("Pottery Quantification A", tabName = "potteryQA", icon = icon("glass-cheers")),
                 menuSubItem("Pottery Quantification B", tabName = "potteryQB", icon = icon("glass-cheers"))
                ),
        menuItem("Sculpture", tabName = "sculpture", icon = icon("horse-head"),
                 badgeLabel = "empty", badgeColor = "red"),
        menuItem("Buildings", tabName = "buildings", icon = icon("landmark"),
                 badgeLabel = "wip", badgeColor = "yellow"),
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
        if (input$operation == "all") {
            get_idaifield_data()
        } else {
            inp_operation <- as.character(input$operation)
            type <- uidlist$type[which(uidlist$identifier == inp_operation)]
            if (type == "Place") {
                UIDs <- get_uid_list(get_idaifield_data(),
                                     verbose = TRUE,
                                     gather_trenches = TRUE) %>%
                    filter(Place == inp_operation) %>%
                    pull(UID)

                get_idaifield_data() %>%
                    select_by(by = "UID", value = UIDs)
            } else {
                get_idaifield_data() %>%
                    select_by(by = "isRecordedIn", value = inp_operation)
            }
        }
    })

    source('source/server/overview_inout.R', local = TRUE)
    source('source/server/pottery_inout.R', local = TRUE)
    source('source/server/potteryQA_inout.R', local = TRUE)
    source('source/server/potteryQB_inout.R', local = TRUE)
    source('source/server/sculpture_inout.R', local = TRUE)
    source('source/server/buildings_inout.R', local = TRUE)

}

shinyApp(ui, server)
