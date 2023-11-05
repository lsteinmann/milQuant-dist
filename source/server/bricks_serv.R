bricks <- reactive({
  validate(
    need(is.data.frame(selected_db()), "No Trenches and/or Places selected.")
  )

  bricks <- selected_db() %>%
    filter(category == "Brick") %>%
    remove_na_cols()
  return(bricks)
})

output$bricks_overview <- renderText({
  n_objects <- nrow(bricks())
  n_layers <- length(unique(bricks()$relation.liesWithinLayer))
  paste("The selected trenches ", paste(input$selected_trenches, collapse = ", "),
        " (from ", paste(input$selected_operations, collapse = ", "),
        ") contain a total of ", n_objects,
        " Brick-Resources from ", n_layers, " contexts.",
        sep = "")
})

generateLayerSelector("bricks_layers", bricks, inputid = "selected_bricks_layers")

output$bricksPlot_1_period_selector <- renderUI({
  make_period_selector(inputId = "bricks_period_selector")
})


make_bricksPlot_1 <- reactive({

  plot_data <- bricks() %>%
    # filter by periods from the slider if config is milet
    period_filter(is_milet = is_milet, selector = input$bricks_period_selector) %>%
    filter(relation.liesWithinLayer %in% input$selected_bricks_layers)

  p <- plot_data  %>%
    ggplot(aes(x = brickType)) +
    geom_bar() +
    scale_y_continuous(name = "number of bricks") +
    scale_x_discrete(name = "type of brick") +
    labs(title = input$bricksPlot_1_title,
         subtitle = input$bricksPlot_1_subtitle,
         caption = paste("Total Number of Objects:", nrow(plot_data)))
  p
})

output$bricksPlot_1 <- renderPlotly({
  convert_to_Plotly(make_bricksPlot_1())
})

callModule(downloadPlotHandler, id = "bricksPlot_1_download",
           dlPlot = make_bricksPlot_1)
