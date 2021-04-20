potteryQB_all <- reactive({
  milet_active() %>%
    select_by(by = "type", value = "Pottery_Quantification_B") %>%
    prep_for_shiny(reorder_periods = TRUE)
})

output$potQB_overview <- renderText({
  n_objects <- nrow(potteryQB_all())
  n_layers <- length(unique(potteryQB_all()$relation.liesWithinLayer))
  paste("The selected operation (", paste(input$operation, collapse = ", "),
        ") contains a total of ", n_objects,
        " pottery quantification (B) forms from ", n_layers, " contexts. Kolay gelsin.",
        sep = "")
})

output$QB_layer_selector <- renderUI({
  make_layer_selector(potteryQB_all(),
                      inputId = "QB_layer_selector")
})


QB_pot_data <- reactive({
  select_layers(input_layer_selector = input$QB_layer_selector,
                data_all = potteryQB_all())
})

QBpotPlot_1 <- function() {
  existing_cols <- colnames(QB_pot_data())
  to_remove <- c("shortDescription", "weightTotal", "countTotal", "processor",
                 "relation.isRecordedIn", "id", "type", "quantificationType",
                 "identifier", "relation.liesWithin", "datingAddenda",
                 "quantificationOther", "period.end", "period.start")
  to_remove <- c(to_remove, existing_cols[grepl("weight", existing_cols)])
  rem_cols <- existing_cols[existing_cols %in% to_remove]

  plot_data <- QB_pot_data() %>%
    select(-rem_cols) %>%
    melt(id = c("relation.liesWithinLayer", "period")) %>%
    mutate(value = as.numeric(value)) %>%
    mutate(value = ifelse(is.na(value), 0, value)) %>%
    mutate(variable = gsub("count", "", variable)) %>%
    mutate(variable = gsub("Rim|Base|Handle", "", variable)) %>%
    filter(period >= input$QB_period_select[1]) %>%
    filter(period <= input$QB_period_select[2]) %>%
    uncount(value)


  plot_title <- paste("Vessel Forms from ", input$operation,
                      " in Context: ",
                      paste(input$QB_layer_selector, collapse = ", "),
                      sep = "")


  p <- ggplot(plot_data, aes(x = fct_infreq(variable),
                             fill = period)) +
    geom_bar(position = input$QBpotPlot_1_bars) +
    Plot_Base_Theme +
    labs(x = "Vessel Forms", y = "count", title = plot_title) +
    scale_fill_period

  if (input$QBpotPlot_1_display == "wrap") {
    p <- p + facet_wrap(~ relation.liesWithinLayer, ncol = 2)
  }

  p
}

output$QBpotPlot_1 <- renderPlot({
  QBpotPlot_1()
})


output$QBpotPlot_1_png <- milQuant_dowloadHandler(plot = QBpotPlot_1(),
                                                  ftype = "png")
output$QBpotPlot_1_pdf <- milQuant_dowloadHandler(plot = QBpotPlot_1(),
                                                  ftype = "pdf")


