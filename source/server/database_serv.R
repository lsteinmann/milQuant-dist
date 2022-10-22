# build second selected db from complete react_db() when changing the place
# in the input
selected_db <- reactiveVal()
observeEvent(input$select_operation, {

  selected <- react_db() %>%
    #select_by(by = "type", value = c(find_types,
    #                                 "Pottery_Quantification_A",
    #                                 "Pottery_Quantification_B")) %>%
    # also prep it to be better readable
    prep_for_shiny(reorder_periods = reorder_periods) %>%
    filter(id %in% uid_by_operation(filter_operation = input$select_operation,
                                    index = react_index()))

  selected_db(selected)
  rm(selected)
})
