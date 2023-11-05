

observeEvent(input$tab_connect.connect, {
  validate(
    need(exists("projects"), "Project list not available.")
  )
  output$selected_project <- renderUI({
    selectizeInput(inputId = "selected_project",
                   label = "Choose a Project to work with",
                   choices = projects, multiple = FALSE,
                   selected = selection_settings$selected_project,
                   options = list(
                     placeholder = "Please select an option below")
                   )
  })
})


react_index <<- reactiveVal(value = NULL)

observeEvent(input$loadDatabase, {

  # error message is only generated once and after this process here has been
  # finished for the first time, the dialog doesnt show the spinner anymore
  # i don't know how to fix that
  # ...

  shinyjs::hide("load.success_msg")
  showModal(busy_dialog)


  message("Trying to connect to the project:")
  try_project <- tryCatch({
    client <- idaifieldR:::proj_idf_client(login_connection(), include = "query",
                                           project = input$selected_project)
    query <- paste0(
      '{
      "selector": { "resource.id": "project" },
      "fields": [ "resource.id", "resource.identifier" ]
       }')
    response <- idaifieldR:::response_to_list(client$post(body = query))
    input$selected_project %in% unlist(response)
  }, warning = function(w) {
    conditionMessage(w)
  }, error = function(e) {
    conditionMessage(e)
  })

  if (try_project) {
    new_login_connection <- login_connection()
    new_login_connection$project <- input$selected_project
    login_connection(new_login_connection)
    message("Success! Getting the Index:")
    newIndex <- get_index(source = login_connection())
    react_index(newIndex)
    message("Done.")
    rm(newIndex)
    output$load.success_msg <- renderText(paste("Using project:",
                                                isolate(input$selected_project)))
    shinyjs::show("load.success_msg")
    output$current_project <- renderText({input$selected_project})
    removeModal()
  } else {
    output$load.error_msg <- renderText(paste("An error has occured: ",
                                              try_project))
    shinyjs::show("load.error_msg")
  }
})

observeEvent(input$close_busy_dialog,{
  removeModal()
})

observeEvent(input$selected_project, {
  hide('load.success_msg')
  is_milet <<- input$selected_project %in% c("milet", "milet-test")
  if (is_milet) {
    reorder_periods <<- TRUE
  } else {
    reorder_periods <<- FALSE
  }
})


observeEvent(input$refreshIndex, {
  message("Fetching the Index again...")
  newIndex <- get_index(source = login_connection())
  react_index(newIndex)
  message("Done.")
  rm(newIndex)
})


# Produces the List of Places to select from the reactive Index
# may not update when index is refreshed
operations <- reactive({
  tmp_operations <- react_index() %>%
    filter(category %in% c(find_categories, quant_categories)) %>%
    pull(Place) %>%
    unique()
  tmp_operations <- tmp_operations[!is.na(tmp_operations)]
#  ind <- tmp_operations %in% c("Bauwerkskatalog", "Inschriften",
#                               "Milet_Stadt", "Steindepot",
#                               "HU_Streufunde", "Kalabaktepe",
#                               "Südstadt", "Typenkatalog")
#  tmp_operations <- tmp_operations[!ind]
  operations <- sort(tmp_operations)
  rm(tmp_operations)
  return(operations)
})


db_operations <<- reactive({input$selected_operations}) %>% debounce(2000)

trenches <- reactive({
  validate(
    need(db_operations(), "No operation selected.")
  )
  if (db_operations()[1] == "select everything") {
    tmp_trenches <- react_index() %>%
      pull(isRecordedIn) %>%
      unique()
  } else {
    tmp_trenches <- react_index() %>%
    filter(Place %in% db_operations()) %>%
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
#  paste(input$selected_operations)
#})
output$selected_operations <- renderUI({
  validate(
    need(react_index(), "No project selected.")
  )
  choices <- operations()
  if (length(choices) == 0) {
    choices <- c("select everything")
  }
  pickerInput(inputId = "selected_operations",
              label = "Choose one or more Places / Operations to work with",
              choices = choices,
              selected = selection_settings$selected_operations,
              multiple = TRUE,
              options = list("actions-box" = TRUE,
                             "live-search" = TRUE,
                             "live-search-normalize" = TRUE,
                             "live-search-placeholder" = "Search here..."))
})

output$selected_trenches <- renderUI({
  validate(
    need(react_index(), "No project selected.")
  )
  pickerInput(inputId = "selected_trenches",
              label = "Choose one or more Trenches to work with",
              choices = trenches(),
              selected = selection_settings$selected_trenches,
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
#  config <- get_configuration(login_connection, projectname = input$selected_project)
#  return(react_periods)
#})


observeEvent(input$close_app,{
  selection_settings <- list("selected_project" = input$selected_project,
                             "selected_operations" = input$selected_operations,
                             "selected_trenches" = input$selected_trenches)
  saveRDS(selection_settings, "defaults/selection_settings.RDS")
  print("Shiny: EXIT")
  stopApp()
})
