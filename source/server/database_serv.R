# query db when changing the place
# in the input

db_trench <- reactive({input$selected_trenches}) %>% debounce(2000)

selected_db <- reactive({
  message("Invalidating and querying DB now:")
  uids <- react_index() %>%
    filter(isRecordedIn %in% db_trench()) %>%
    filter(category %in% c(find_categories, quant_categories)) %>%
    pull(UID)

  selected <- idf_uid_query(login_connection(), uids)
  message("Processing data (simplify_idaifield(), prep_for_shiny()).\nMay point out possible problems:")
  selected <- selected %>%
    simplify_idaifield(uidlist = react_index(),
                       keep_geometry = FALSE, replace_uids = TRUE) %>%
    prep_for_shiny(reorder_periods = reorder_periods)

  message("Done.")
  selected
})

