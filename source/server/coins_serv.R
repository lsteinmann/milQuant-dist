coins <- reactive({
  validate(
    need(is.data.frame(selected_db()), "No Trenches and/or Places selected.")
  )

  coins <- selected_db() %>%
    filter(category == "Coin") %>%
    remove_na_cols()
  return(coins)
})

output$coins_overview <- renderText({
  n_objects <- nrow(coins())
  n_layers <- length(unique(coins()$relation.liesWithinLayer))
  paste("The selected trenches ", paste(input$select_trench, collapse = ", "),
        " (from ", paste(input$select_operation, collapse = ", "),
        ") contain a total of ", n_objects,
        " Coin-Resources from ", n_layers, " contexts.",
        sep = "")
})

module_id <- "coins_layers"
callModule(generateLayerSelector,
           id = module_id,
           module_id = module_id,
           data = coins)

output$coinsPlot_1_period_selector <- renderUI({
  make_period_selector(inputId = "coinsPlot_1_period_selector")
})


make_coinsPlot_1 <- reactive({

  plot_data <- coins() %>%
    # filter by periods from the slider if config is milet
    period_filter(is_milet = is_milet,
                  selector = input$coinsPlot_1_period_selector) %>%
    filter(relation.liesWithinLayer %in% input$selected_coins_layers)

  x_var <- "period"
  fill_var <- "category"

  plot_data <- plot_data %>%
    mutate(x = get(x_var), color = get(fill_var)) %>%
    select(x, color) %>%
    count(x, color) %>%
    group_by(x) %>%
    arrange(n)

  plot_title <- input$coinsPlot_1_title

  fig <- plot_ly(plot_data, x = ~x, y = ~n, color = ~color, type = "bar")
  fig <- fig %>% layout(title = plot_title,
                        xaxis = list(title = x_var, categoryorder = "total descending"),
                        yaxis = list(title = "count"),
                        legend = list(title=list(text = fill_var)))
  fig

    #labs(title = input$coinsPlot_1_title,
    #     subtitle = input$coinsPlot_1_subtitle,
    #     caption = paste("Total Number of Objects:", nrow(plot_data)))
})

output$coinsPlot_1 <- renderPlotly({
  make_coinsPlot_1()
})

callModule(downloadPlotHandler, id = "coinsPlot_1_download",
           dlPlot = make_coinsPlot_1)
