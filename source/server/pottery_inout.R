# Return the requested dataset
output$selected_operation <- renderText({
  paste("You have selected", input$operation)
})

pottery_overview_data <- reactive({

  pottery_overview_data <- milet %>%
    select_by(by = "type", value = "^Pottery$") %>%
    select_by(by = "isRecordedIn", value = as.character(input$operation)) %>%
    idaifield_as_matrix() %>%
    as.data.frame() %>%
    mutate_all(~ as.character(.))

  na_cols <- rowSums(apply(pottery_overview_data,
                           function(x) is.na(x),
                           MARGIN = 1)) == 0
  pottery_overview_data <- pottery_overview_data[, -na_cols]
  pottery_overview_data
})

output$pottery_overview <- renderText({
  n_objects <- nrow(pottery_overview_data())
  n_layers <- length(unique(pottery_overview_data()$relation.liesWithinLayer))
  paste("This operation contains a total of ", n_objects,
        " pottery resources from ", n_layers, " contexts. Kolay gelsin.",
        sep = "")
})


output$layer_selector = renderUI({#creates County select box object called in ui

  selectible_layers <- unique(pottery_overview_data()$relation.liesWithinLayer)
  #creates a reactive list of available counties based on the State selection made
  selectInput(inputId = "layer_selector", label = "Choose one or many contexts",
              choices = c("all", selectible_layers),
              selected = "all",
              multiple = TRUE)
})


pottery_data <- reactive({
  if ("all" %in% input$layer_selector) {
    pottery_data <- pottery_overview_data()
  } else {
    layer_selector <- input$layer_selector
    pottery_data <- pottery_overview_data() %>%
      filter(relation.liesWithinLayer %in% layer_selector)
  }
})

pottery_vars <- reactive({
  pottery_vars <- colnames(pottery_data())
  pottery_vars <- pottery_vars[!pottery_vars %in% drop_for_plot_vars]
})

output$potPlot_1_x_selector <- renderUI({
  # Produce this selectInput on server to be dynamic
  selectInput(inputId = "potPlot_1_xvar", label = "Choose a variable for the x-axis:",
              choices = pottery_vars())
})

output$potPlot_1_fill_selector <- renderUI({
  # Produce this selectInput on server to be dynamic
  selectInput(inputId = "potPlot_1_fillvar", label = "Choose a variable for the color:",
              choices = pottery_vars())
})

potPlot_1 <- function() {
  ggplot(pottery_data(), aes(x = get(input$potPlot_1_xvar),
                             fill = get(input$potPlot_1_fillvar))) +
    geom_bar() + Plot_Base_Theme +
    scale_fill_discrete(name = input$potPlot_1_fillvar) +
    labs(y = "Number of Objects", x = input$potPlot_1_xvar)
}

output$potPlot_1 <- renderPlot({
  potPlot_1()
})

output$potPlot_1_png <- milQuant_dowloadHandler(plot = potPlot_1(), ftype = "png")
output$potPlot_1_pdf <- milQuant_dowloadHandler(plot = potPlot_1(), ftype = "pdf")

#"Insula UV/8-9") %>%#
