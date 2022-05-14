



react_db <- reactiveVal(value = NULL)
react_index <- reactiveVal(value = NULL)

observeEvent(input$loadDatabase, {
  if (is.null(input$select_project)) {
    output$load.error_msg <- renderText("No project selected!")
  } else {
    newDB <- get_complete_db(connection = login_connection,
                             projectname = input$select_project)
    react_db(newDB)
    newIndex <- get_index(source = react_db())
    react_index(newIndex)
    rm(newDB, newIndex)
    output$load.success_msg <- renderText("Project selected!")
  }
  shinyjs::show("load.error_msg")
  shinyjs::show("load.success_msg")
})

observeEvent(input$select_project, {
  is_milet <<- grepl("milet", input$select_project)
})

# Produces the List of Places to select from the reactive Index
# may not update when index is refreshed
operations <- reactive({
  tmp_operations <- react_index()$Operation
  tmp_operations <- unique(tmp_operations)
  operations <- c("all", sort(na.omit(tmp_operations)))
  rm(tmp_operations)
  return(operations)
})
#Place Selector -- Return the requested dataset as text
# apparently i do not use this anywhere??
#output$selected_place <- renderText({
#  paste(input$select_operation)
#})
output$select_operation <- renderUI({
  validate(
    need(react_index(), "No project selected.")
  )
  selectInput(inputId = "select_operation",
              label = "Choose Place or Operation to work with",
              choices = operations(), multiple = FALSE,
              selected = operations()[1])
})

# TODO: try to get a periods list
# this is not going to work
#react_periods <- reactive({
#  validate(
#    need(react_index(), "No project selected.")
#  )
#  config <- get_configuration(login_connection, projectname = input$select_project)
#  return(react_periods)
#})



