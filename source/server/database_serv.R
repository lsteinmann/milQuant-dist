# create a reactive object that serves as the index (UIDlist!)
# loads once
react_db <- reactiveVal()
react_index <- reactiveVal()
react_db <- reactiveVal(get_complete_db(connection = idaif_conn))
react_index <- reactiveVal(get_index(source = isolate(react_db())))

observeEvent(input$tab_connect.connect, {
  reactiveVal(get_complete_db(connection = login_connection))
  reactiveVal(get_index(source = isolate(react_db())))
})

# rebuild the Index when Refresh Button is pushed
observeEvent(input$refresh, {
  newDB <- get_complete_db(connection = login_connection)
  newIndex <- get_index(source = newDB)
  react_db(newDB)
  react_index(newIndex)
  rm(newDB)
  rm(newIndex)
})

observeEvent(input$select_project, {
  newDB <- get_complete_db(connection = login_connection,
                           projectname = input$select_project)
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


