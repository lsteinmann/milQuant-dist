# query db when changing the place
# in the input
selected_db <- reactiveVal()

observeEvent(input$select_trench, {
  uids <- react_index() %>%
    filter(isRecordedIn %in% input$select_trench) %>%
    filter(category %in% c(find_categories, quant_categories)) %>%
    pull(UID)

  selected <- idf_uid_query(login_connection(), uids) %>%
    simplify_idaifield(uidlist = react_index(),
                       keep_geometry = FALSE, replace_uids = TRUE) %>%
    prep_for_shiny(reorder_periods = reorder_periods)

  selected_db(selected)
  rm(selected)
}) %>% debounce(2000)

