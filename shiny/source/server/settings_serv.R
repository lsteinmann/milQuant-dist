

observeEvent(input$tab_connect.connect, {
  validate(
    need(exists("projects"), "Project list not available.")
  )
  output$select_project <- renderUI({
    selectizeInput(inputId = "select_project",
                   label = "Choose a Project to work with",
                   choices = projects, multiple = FALSE,
                   selected = selection_settings$select_project,
                   options = list(
                     placeholder = 'Please select an option below'#,
                     #onInitialize = I('function() { this.setValue(""); }')
                   ))
  })
})


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
    output$load.success_msg <- renderText(paste("Using project:",
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
  is_milet <<- input$select_project == "milet"
  if (is_milet) {
    reorder_periods <<- TRUE
  } else {
    reorder_periods <<- FALSE
  }
})

# Produces the List of Places to select from the reactive Index
# may not update when index is refreshed
operations <- reactive({
  tmp_operations <- react_index() %>%
    pull(Place) %>%
    unique()
  tmp_operations <- tmp_operations[!is.na(tmp_operations)]
  operations <- sort(tmp_operations)
  rm(tmp_operations)
  return(operations)
})


trenches <- reactive({
  validate(
    need(input$select_operation, "No operation selected.")
  )
  if (input$select_operation[1] == "select everything") {
    tmp_trenches <- react_index() %>%
      pull(isRecordedIn) %>%
      unique()
  } else {
    tmp_trenches <- react_index() %>%
    filter(Place %in% input$select_operation) %>%
    pull(isRecordedIn) %>%
    unique()
  }

  tmp_trenches <- tmp_trenches[!is.na(tmp_trenches)]
  trenches <- sort(tmp_trenches)
  rm(tmp_trenches)
  return(trenches)
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
  choices <- operations()
  if (length(choices) == 0) {
    choices <- c("select everything")
  }
  pickerInput(inputId = "select_operation",
              label = "Choose one or more Places / Operations to work with",
              choices = choices,
              selected = selection_settings$select_operation,
              multiple = TRUE,
              options = list("actions-box" = TRUE,
                             "live-search" = TRUE,
                             "live-search-normalize" = TRUE,
                             "live-search-placeholder" = "Search here..."))
})

output$select_trench <- renderUI({
  validate(
    need(react_index(), "No project selected.")
  )
  pickerInput(inputId = "select_trench",
              label = "Choose one or more Trenches to work with",
              choices = trenches(),
              selected = selection_settings$select_trench,
              multiple = TRUE,
              options = list("actions-box" = TRUE,
                             "live-search" = TRUE,
                             "live-search-normalize" = TRUE,
                             "live-search-placeholder" = "Search here..."))
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


observeEvent(input$close_app,{
  selection_settings <- list("select_project" = input$select_project,
                             "select_operation" = input$select_operation,
                             "select_trench" = input$select_trench)
  saveRDS(selection_settings, "defaults/selection_settings.RDS")
  print("Shiny: EXIT")
  stopApp()
})
