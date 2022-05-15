

react_db <- reactiveVal(value = NULL)
react_index <- reactiveVal(value = NULL)

observeEvent(input$loadDatabase, {

  # error message is only generated once and after this process here has been
  # finished for the first time, the dialog doesnt show the spinner anymore
  # i don't know how to fix that
  # ...

  shinyjs::hide("load.success_msg")
  showModal(busy_dialog)


  try_project <- try(sofa::doc_get(cushion = login_connection,
                    dbname = input$select_project,
                    docid = "project"), silent = TRUE)

  if (class(try_project) == "list" & "resource" %in% names(try_project)) {
    newDB <- get_complete_db(connection = login_connection,
                             projectname = input$select_project)
    react_db(newDB)
    newIndex <- get_index(source = react_db())
    react_index(newIndex)
    rm(newDB, newIndex)
    output$load.success_msg <- renderText(paste("Project selected! You are currently using the project:",
                                                isolate(input$select_project)))
    shinyjs::show("load.success_msg")
    output$current_project <- renderText({input$select_project})
    removeModal()
  } else {
    output$load.error_msg <- renderText("An error has occured.")
    shinyjs::show("load.error_msg")
  }
})

observeEvent(input$close_busy_dialog,{
  removeModal()
})

observeEvent(input$select_project, {
  hide('load.success_msg')
  is_milet <<- grepl("milet", as.character(input$select_project))
  if (is_milet) {
    reorder_periods <<- TRUE
  } else {
    reorder_periods <<- FALSE
  }
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


