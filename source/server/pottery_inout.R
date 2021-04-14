# Return the requested dataset
output$selected_operation <- renderText({
  paste("You have selected", input$operation)
})

pottery_overview_data <- reactive({

  milet %>%
    select_by(by = "type", value = "Pottery") %>%
    select_by(by = "isRecordedIn", value = as.character(input$operation)) %>%
    idaifield_as_matrix() %>%
    as.data.frame() %>%
    filter(!grepl("Quant", type)) %>%
    mutate_all(~ as.character(.))
})

output$pottery_overview <- renderText({
  n_objects <- nrow(pottery_overview_data())
  n_layers <- length(unique(pottery_overview_data()$relation.liesWithinLayer))
  paste("This operation contains a total of ", n_objects,
        " pottery resources from ", n_layers, " contexts. Kolay gelsin.",
        sep = "")
})

pottery_data <- reactive({
  if ("all" %in% input$layer) {
    pottery_data <- pottery_overview_data()
  } else {
    select_layer <- input$layer[-which(input$layer == "all")]
    pottery_data <- pottery_overview_data() %>%
      filter(relation.liesWithinLayer == select_layer)
  }
})





#"Insula UV/8-9") %>%#
