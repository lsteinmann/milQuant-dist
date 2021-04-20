potteryQA_all <- reactive({
  potteryQA_all <- milet_active() %>%
    select_by(by = "type", value = "Pottery_Quantification_A") %>%
    prep_for_shiny(reorder_periods = FALSE)
})

output$potQA_overview <- renderText({
  n_objects <- nrow(potteryQA_all())
  n_layers <- length(unique(potteryQA_all()$relation.liesWithinLayer))
  paste("The selected operation (", paste(input$operation, collapse = ", "),
        ") contains a total of ", n_objects,
        " pottery quantification (A) forms from ", n_layers, " contexts. Kolay gelsin.",
        sep = "")
})

output$QA_layer_selector <- renderUI({
  make_layer_selector(potteryQA_all(),
                      inputId = "QA_layer_selector")
})

QA_pot_data <- reactive({
  select_layers(data_all = potteryQA_all(),
                input_layer_selector = input$QA_layer_selector)
})


QApotPlot_1 <- function() {
  existing_cols <- colnames(QA_pot_data())
  to_remove <- c("shortDescription", "weightTotal", "countTotal", "processor",
                 "relation.isRecordedIn", "id", "type", "quantificationType",
                 "identifier", "relation.liesWithin",
                 "quantificationOther")
  to_remove <- c(to_remove, existing_cols[grepl("weight", existing_cols)])
  rem_cols <- existing_cols[existing_cols %in% to_remove]

  plot_data <- QA_pot_data() %>%
    select(-rem_cols) %>%
    melt(id = "relation.liesWithinLayer") %>%
    mutate(value = as.numeric(value)) %>%
    mutate(variable = gsub("count", "", variable)) %>%
    mutate(value = ifelse(is.na(value), 0, value))  %>%
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
    labs(x = x_axis_title, y = "count", title = plot_title)
}

output$QApotPlot_1 <- renderPlot({
  QApotPlot_1()
})


output$QApotPlot_1_png <- milQuant_dowloadHandler(plot = QApotPlot_1(),
                                                ftype = "png")
output$QApotPlot_1_pdf <- milQuant_dowloadHandler(plot = QApotPlot_1(),
                                                ftype = "pdf")


