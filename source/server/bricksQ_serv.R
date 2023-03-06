bricksQ <- reactive({
  validate(
    need(is.data.frame(selected_db()), "No Trenches and/or Places selected.")
  )

  bricksQ <- selected_db() %>%
    filter(type == "Brick_Quantification") %>%
    remove_na_cols()
  return(bricksQ)
})

output$bricksQ_overview <- renderText({
  n_objects <- nrow(bricksQ())
  n_layers <- length(unique(bricksQ()$relation.liesWithinLayer))
  paste("The selected trenches ", paste(input$select_trench, collapse = ", "),
        " (from ", paste(input$select_operation, collapse = ", "),
        ") contain a total of ", n_objects,
        " Brick-Quantification Forms from ", n_layers, " contexts.",
        sep = "")
})

output$bricksQ_layer_selector <- renderUI({
  make_layer_selector(bricksQ(),
                      inputId = "bricksQ_layer_selector")
})


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
    filter(relation.liesWithinLayer %in% input$bricksQ_layer_selector) %>%
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


output$bricksQPlot_1_png <- milQuant_dowloadHandler(plot = make_bricksQPlot_1(),
                                                ftype = "png")
output$bricksQPlot_1_pdf <- milQuant_dowloadHandler(plot = make_bricksQPlot_1(),
                                                ftype = "pdf")


