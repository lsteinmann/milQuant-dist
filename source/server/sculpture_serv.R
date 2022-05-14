sculpture_all <- reactive({
  milet_active() %>%
    select_by(by = "type", value = "Sculpture") %>%
    prep_for_shiny()
})


output$sculpture_overview <- renderText({
  n_objects <- nrow(sculpture_all())
  paste("There is a total of ", n_objects, " objects in the operation (",
        paste(input$operation, collapse = ", "),
        "). Kolay gelsin.",
        sep = "")
})
