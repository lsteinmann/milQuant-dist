# build second selected db from complete react_db() when changing the place
# in the input
selected_db <- reactiveVal()
observeEvent(input$select_trench, {

  selected <- react_db() %>%
    select_by(by = "isRecordedIn", value = input$select_trench) %>%
    simplify_idaifield(uidlist = react_index(),
                       keep_geometry = FALSE, replace_uids = TRUE) %>%
    prep_for_shiny(reorder_periods = reorder_periods) #%>%
    #filter(id %in% uid_by_operation(filter_operation = input$select_operation,
    #                                index = react_index()))

  selected_db(selected)
  rm(selected)
})
