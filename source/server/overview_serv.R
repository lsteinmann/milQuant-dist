
output$overview_n <- renderText({
  validate(
    need(react_index(), "No project selected.")
  )
  prettyNum(nrow(react_index()), big.mark = ",")
})

output$overview <- renderPlotly({
  validate(
    need(react_index(), "No project selected.")
  )

  # tmp_index <- react_index()
  # if (!is.null(input$selected_operations)) {
  #   tmp_index <- react_index() %>%
  #     filter(Place %in% input$selected_operations)
  # } else {
  #   tmp_index <- react_index()
  # }

  do_not_display <- c("Place", "Project",
                      "Type", "TypeCatalog",
                      "Image", "Photo", "Drawing")

  x_var <- input$overviewPlot_display_x
  color_var <- input$overviewPlot_display_color

  plot_data <- react_index() %>%
    select(category, Place, Operation) %>%
    filter(!category %in% do_not_display) %>%
    mutate(x = get(x_var), color = get(color_var)) %>%
    droplevels() %>%
    select(x, color) %>%
    count(x, color) %>%
    group_by(x) %>%
    arrange(n)

  plot_title <- paste0("resources in project ", input$selected_project)

  x_label <- ifelse(x_var == "category", "Resource-Category", x_var)
  color_label <- ifelse(color_var == "category", "Resource-Category", color_var)

  fig <- plot_ly(plot_data, x = ~x, y = ~n, color = ~color, text = ~color,
                 type = "bar", textposition = "none", source = "overview_plot",
                 colors = viridis(length(unique(plot_data$color))),
                 hovertemplate = paste0("<b>%{fullData.name}</b><br>",
                                        "%{x}<br>",
                                        "count: <b>%{y}</b><br>",
                                        "<extra></extra>"))
  fig <- fig %>% layout(barmode = input$overviewPlot_barmode,
                        title = plot_title,
                        xaxis = list(title = x_label, categoryorder = "total descending"),
                        yaxis = list(title = "count"),
                        legend = list(title=list(text = color_label)))

  milquant_plotly_layout(fig, caption = FALSE)
})
