loomweights <- reactive({
  loomweights <- selected_db() %>%
    filter(type == "Loomweight") %>%
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

output$LW_layer_selector <- renderUI({
  make_layer_selector(loomweights(),
                      inputId = "LW_layer_selector")
})

output$LW_period_selector <- renderUI({
  make_period_selector(inputId = "LW_period_selector")
})

fill_vars <- list("Operation" = "relation.isRecordedIn",
                  "Condition" = "condition",
                  "Percentage preserved" = "conditionAmount",
                  "Height" = "dimensionHeight_cm_1",
                  "Find Localization" = "localization",
                  "Category" = "loomweightCategory",
                  "Decoration" = "loomweightDetail")

output$lwplot_1_fill_selector <- renderUI({

  #colnames(loomweights())
  # Produce this selectInput on server to be dynamic
  selectInput(inputId = "lwPlot_1_fillvar", label = "Choose a variable for the color:",
              choices = fill_vars, selected = "loomweightCategory")

})

output$lw_weight_slider <- renderUI({

  max_weight <- pretty(max(na.omit(loomweights()$weightTotal)), n = 1)[1]+100
  # Slider Input to choose max and min weight
  sliderInput("lw_weight_slider", label = "Weight Range",
              min = 0,
              max = max_weight, value = c(0, max_weight))

})

make_lwPlot_1 <- reactive({
  fill_name <- names(fill_vars[which(fill_vars == input$lwPlot_1_fillvar)])

  if (input$lw_condition_filter == "all") {
    condition_filter <- unique(loomweights()$conditionAmount)
  } else {
    condition_filter <- input$lw_condition_filter
  }

  p <- loomweights() %>%
    # filter by periods from the slider if config is milet
    period_filter(is_milet = is_milet, selector = input$LW_period_selector) %>%
    filter(relation.liesWithinLayer %in% input$LW_layer_selector) %>%
    filter(conditionAmount %in% condition_filter) %>%
    ggplot(aes(x = weightTotal, fill = get(input$lwPlot_1_fillvar))) +
    geom_histogram(bins = input$bins) +
    scale_fill_discrete(name = fill_name) +
    scale_y_continuous(name = "number of loomweights") +
    scale_x_continuous(name = "distribution of weight",
                       limits = c(input$lw_weight_slider[1],
                                  input$lw_weight_slider[2])) +
    labs(title = input$lwPlot_1_title, subtitle = input$lwPlot_1_subtitle) +
    Plot_Base_Theme
  p
})

output$lwPlot_1 <- renderPlot({
  make_lwPlot_1()
})


output$lwPlot_1_png <- milQuant_dowloadHandler(plot = make_lwPlot_1(),
                                                ftype = "png")
output$lwPlot_1_pdf <- milQuant_dowloadHandler(plot = make_lwPlot_1(),
                                                ftype = "pdf")
