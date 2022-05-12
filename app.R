## app.R ##
source("source/load_packages.R")
source("source/get_data.R")
source("source/global_vars.R")
source("source/helpers.R")

header <- dashboardHeader(title = img(src = "loewe.png",
                                      height = 44))


sidebar <- dashboardSidebar(
    sidebarMenu(
        actionButton("refresh", "Reload DB"),
        uiOutput("select_place"),
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
        menuItem("Issues / Contact", icon = icon("fa-solid fa-file-signature"),
                 href = "https://github.com/lsteinmann/milQuant")
    )
)

source("source/body.R")

ui <- dashboardPage(header, sidebar, body)

server <- function(input, output, session) {

  # create a reactive object that serves as the index (UIDlist!)
  # loads once
  react_db <- reactiveVal()
  react_db <- reactiveVal(get_complete_db())
  react_index <- reactiveVal()
  react_index <- reactiveVal(get_index(source = isolate(react_db())))

  # rebuild the Index when Refresh Button is pushed
  observeEvent(input$refresh, {
    newDB <- get_complete_db()
    newIndex <- get_index(source = newDB)
    react_db(newDB)
    react_index(newIndex)
    rm(newDB)
    rm(newIndex)
  })


  # build second selected db from complete react_db() when changing the place
  # in the input
  selected_db <- reactiveVal()
  observeEvent(input$select_place, {
    selected <- react_db() %>%
      # also prep it to be better readable
      prep_for_shiny(reorder_periods = TRUE) %>%
      filter(id %in% uid_to_filter(place = input$select_place,
                                   index = react_index()))
    selected_db(selected)
    rm(selected)
  })

  # Produces the List of Places to select from the reactive Index
  # may not update when index is refreshed
  places <- reactive({
    places <- c("all", sort(na.omit(unique(react_index()$Place))))
    return(places)
  })
  #Place Selector -- Return the requested dataset as text
  # apparently i do not use this anywhere??
  #output$selected_place <- renderText({
  #  paste(input$select_place)
  #})
  output$select_place <- renderUI({
    selectInput(inputId = "select_place",
                label = "Choose an Area or Survey to work with",
                choices = places(), multiple = FALSE,
                selected = places()[1])
  })





  # server code only for main page
  source('source/server/overview_inout.R', local = TRUE)

  # server code only for pottery form (single)
  source('source/server/pottery_inout.R', local = TRUE)

  # server code only for pottery quantification A form
  source('source/server/potteryQA_inout.R', local = TRUE)
  # server code only for pottery quantification B form
  source('source/server/potteryQB_inout.R', local = TRUE)
    #source('source/server/sculpture_inout.R', local = TRUE)
    #source('source/server/buildings_inout.R', local = TRUE)

}

shinyApp(ui, server)
