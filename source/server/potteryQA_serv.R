potteryQA <- reactive({
  potteryQA <- selected_db() %>%
    filter(type == "Pottery_Quantification_A") %>%
    remove_na_cols()
  return(potteryQA)
})

output$potQA_overview <- renderText({
  n_objects <- nrow(potteryQA())
  n_layers <- length(unique(potteryQA()$relation.liesWithinLayer))
  paste("The selected place (", paste(input$select_operation, collapse = ", "),
        ") contains a total of ", n_objects,
        " pottery quantification (A) forms from ", n_layers, " contexts. Kolay gelsin.",
        sep = "")
})

output$QA_layer_selector <- renderUI({
  make_layer_selector(potteryQA(),
                      inputId = "QA_layer_selector")
})


QApotPlot_1 <- function() {
  existing_cols <- colnames(potteryQA())
  keep <- existing_cols
  keep <- keep[grepl("count", keep)]
  keep
  # remove "countTotal" as well
  keep <- keep[!grepl("countTotal", keep)]
  # needed for melt id
  keep <- c(keep, "relation.liesWithinLayer")

  plot_data <- potteryQA() %>%
    filter(relation.liesWithinLayer %in% input$QA_layer_selector) %>%
    select(all_of(keep)) %>%
    melt(id = "relation.liesWithinLayer") %>%
    mutate(value = ifelse(is.na(value), 0, value)) %>%
    mutate(value = as.numeric(value)) %>%
    mutate(variable = gsub("count", "", variable)) %>%
    # so every object is a row, technically (makes ggplot easier)
    uncount(value)

  if (input$QApotPlot_1_display == "fill") {
    p <- ggplot(plot_data, aes(x = fct_infreq(variable),
                               fill = fct_infreq(relation.liesWithinLayer)))
    legend_title <- "Context"
    x_axis_title <- "Vessel Forms"
  } else if (input$QApotPlot_1_display == "x") {
    p <- ggplot(plot_data, aes(x = fct_infreq(relation.liesWithinLayer),
                               fill = fct_infreq(variable)))
    legend_title <- "Vessel Forms"
    x_axis_title <- "Context"

  } else if (input$QApotPlot_1_display == "none") {

    p <- ggplot(plot_data, aes(x = fct_infreq(variable)))
    legend_title <- "none"
    x_axis_title <- "Vessel Forms"
  }
  plot_title <- paste("Vessel Forms from ", input$operation,
                      " in Context: ",
                      paste(input$QA_layer_selector, collapse = ", "),
                      sep = "")

  p +
    geom_bar(position = input$QApotPlot_1_bars) +
    Plot_Base_Theme +
    scale_fill_discrete(name = legend_title) +
    labs(x = x_axis_title, y = "count", title = plot_title,
         caption = paste("Total Number of Fragments:", nrow(plot_data)))
}

output$QApotPlot_1 <- renderPlot({
  QApotPlot_1()
})


output$QApotPlot_1_png <- milQuant_dowloadHandler(plot = QApotPlot_1(),
                                                ftype = "png")
output$QApotPlot_1_pdf <- milQuant_dowloadHandler(plot = QApotPlot_1(),
                                                ftype = "pdf")


