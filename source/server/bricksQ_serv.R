bricksQ <- reactive({
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


bricksQPlot_1 <- function() {
  existing_cols <- colnames(bricksQ())
  keep <- existing_cols
  keep <- keep[grepl("count", keep)]
  keep
  # remove "countTotal" as well
  keep <- keep[!grepl("countTotal", keep)]
  # needed for melt id
  keep <- c(keep, "relation.liesWithinLayer")

  plot_data <- bricksQ() %>%
    filter(relation.liesWithinLayer %in% input$QA_layer_selector) %>%
    select(all_of(keep)) %>%
    melt(id = "relation.liesWithinLayer") %>%
    mutate(value = ifelse(is.na(value), 0, value)) %>%
    mutate(value = as.numeric(value)) %>%
    mutate(variable = gsub("count", "", variable)) %>%
    # so every object is a row, technically (makes ggplot easier)
    uncount(value)

  bricksQ() %>% ggplot(aes(x = relation.isRecordedIn)) +
    geom_bar() +
    Plot_Base_Theme
}

output$bricksQPlot_1 <- renderPlot({
  bricksQPlot_1()
})


output$bricksQPlot_1_png <- milQuant_dowloadHandler(plot = bricksQPlot_1(),
                                                ftype = "png")
output$bricksQPlot_1_pdf <- milQuant_dowloadHandler(plot = bricksQPlot_1(),
                                                ftype = "pdf")


