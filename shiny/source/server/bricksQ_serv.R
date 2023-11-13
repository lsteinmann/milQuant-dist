bricksQ <- reactive({
  validate(
    need(is.data.frame(react_index()), "No Index available.")
  )

  bricksQ <- get_resources(resource_category = "Brick_Quantification") %>%
    remove_na_cols()
  return(bricksQ)
})

output$bricksQ_overview <- renderText({
  n_objects <- nrow(bricksQ())
  n_layers <- length(unique(bricksQ()$relation.liesWithinLayer))
  paste("The selected trenches ", paste(input$selected_trenches, collapse = ", "),
        " (from ", paste(input$selected_operations, collapse = ", "),
        ") contain a total of ", n_objects,
        " Brick-Quantification Forms from ", n_layers, " contexts.",
        sep = "")
})

generateLayerSelector("bricksQ_layers", bricksQ, inputid = "selected_bricksQ_layers")

make_bricksQPlot_1 <- reactive({
  existing_cols <- colnames(bricksQ())
  keep <- existing_cols
  keep <- keep[grepl("count", keep)]
  keep
  # remove "countTotal" as well
  keep <- keep[!grepl("countTotal", keep)]
  # needed for melt id
  keep <- c(keep, "relation.liesWithinLayer")

  plot_data <- bricksQ() %>%
    filter(relation.liesWithinLayer %in% input$selected_bricksQ_layers) %>%
    select(all_of(keep)) %>%
    melt(id = "relation.liesWithinLayer") %>%
    mutate(value = ifelse(is.na(value), 0, value)) %>%
    mutate(value = as.numeric(value)) %>%
    mutate(variable = gsub("count", "", variable)) %>%
    # so every object is a row, technically (makes ggplot easier)
    uncount(value) %>%
    mutate(variable = fct_infreq(variable))

  p <- plot_data %>% ggplot(aes(x = variable)) +
    geom_bar() +
    labs(title = input$bricksQPlot_1_title,
         subtitle = input$bricksQPlot_1_subtitle,
         caption = paste("Total Number of Fragments:", nrow(plot_data)))

  p
})

output$bricksQPlot_1 <- renderPlotly({
  convert_to_Plotly(make_bricksQPlot_1())
})

makeDownloadPlotHandler("bricksQPlot_1_download", dlPlot = make_bricksQPlot_1)

