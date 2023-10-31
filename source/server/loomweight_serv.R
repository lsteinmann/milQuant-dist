loomweights <- reactive({
  validate(
    need(is.data.frame(selected_db()), "No Trenches and/or Places selected.")
  )

  loomweights <- selected_db() %>%
    filter(category == "Loomweight") %>%
    remove_na_cols()
  return(loomweights)
})

output$loomweight_overview <- renderText({
  n_objects <- nrow(loomweights())
  n_layers <- length(unique(loomweights()$relation.liesWithinLayer))
  paste("The selected trenches ", paste(input$select_trench, collapse = ", "),
        " (from ", paste(input$select_operation, collapse = ", "),
        ") contain a total of ", n_objects,
        " Loomweight-Resources from ", n_layers, " contexts.",
        sep = "")
})

callModule(generateLayerSelector,
           id = "lw_layers",
           module_id = "lw_layers",
           data = loomweights)

output$lwPlot_1_period_selector <- renderUI({
  make_period_selector(inputId = "lwPlot_1_period_selector")
})

fill_vars <- list("Operation" = "relation.isRecordedIn",
                  "Condition" = "condition",
                  "Percentage preserved" = "conditionAmount",
                  "Height" = "dimensionHeight_cm_1",
                  "Find Localization" = "localization",
                  "Category" = "loomweightCategory",
                  "Decoration" = "loomweightDetail")

output$lwPlot_1_fill_selector <- renderUI({

  #colnames(loomweights())
  # Produce this selectInput on server to be dynamic
  selectInput(inputId = "lwPlot_1_fillvar", label = "Choose a variable for the color:",
              choices = fill_vars, selected = "loomweightCategory")

})

output$lwPlot_1_weight_slider <- renderUI({

  max_weight <- pretty(max(na.omit(loomweights()$weightTotal)), n = 1)[1]+100
  # Slider Input to choose max and min weight
  sliderInput("lw_weight_slider", label = "Weight Range",
              min = 0,
              max = max_weight, value = c(0, max_weight))

})

make_lwPlot_1 <- reactive({
  fill_name <- names(fill_vars[which(fill_vars == input$lwPlot_1_fillvar)])

  if (input$lwPlot_1_condition_filter == "all") {
    condition_filter <- unique(loomweights()$conditionAmount)
  } else if (input$lwPlot_1_condition_filter == "75-100") {
    condition_filter <- c("intakt", "Fragmentarisch_75-100")
  } else {
    condition_filter <- input$lwPlot_1_condition_filter
  }

  plot_data <- loomweights() %>%
    # filter by periods from the slider if config is milet
    period_filter(is_milet = is_milet, selector = input$LW_period_selector) %>%
    filter(relation.liesWithinLayer %in% input$selected_lw_layers) %>%
    filter(conditionAmount %in% condition_filter) %>%
    mutate(fill = get(input$lwPlot_1_fillvar)) %>%
    filter(weightTotal >= input$lw_weight_slider[1]) %>%
    filter(weightTotal <= input$lw_weight_slider[2])

  p <- plot_data %>%
    ggplot(aes(x = weightTotal, fill = fill)) +
    geom_histogram(bins = input$bins) +
    scale_fill_discrete(name = fill_name, guide = "legend") +
    scale_y_continuous(name = "number of loomweights") +
    scale_x_continuous(name = "distribution of weight") +
    labs(title = input$lwPlot_1_title,
         subtitle = input$lwPlot_1_subtitle,
         caption = paste("Total:", nrow(plot_data)))
  p
})

output$lwPlot_1 <- renderPlotly({
  convert_to_Plotly(make_lwPlot_1())
})

callModule(downloadPlotHandler, id = "lwPlot_1_download",
           dlPlot = make_lwPlot_1)
