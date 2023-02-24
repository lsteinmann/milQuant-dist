potteryQB <- reactive({
  potteryQB <- selected_db() %>%
    filter(type == "Pottery_Quantification_B") %>%
    remove_na_cols()
  return(potteryQB)
})

output$potQB_overview <- renderText({
  n_objects <- nrow(potteryQB())
  n_layers <- length(unique(potteryQB()$relation.liesWithinLayer))
  paste("The selected place (", paste(input$select_operation, collapse = ", "),
        ") contains a total of ", n_objects,
        " pottery quantification (B) forms from ", n_layers, " contexts. Kolay gelsin.\\n",
        "Please note: It doesnt work to select two periods... we have to resolve this somehow.",
        sep = "")
})

output$QB_layer_selector <- renderUI({
  make_layer_selector(potteryQB(),
                      inputId = "QB_layer_selector")
})

output$QBpotPlot_1_period_selector <- renderUI({
  make_period_selector(inputId = "QBpotPlot_1_period_selector")
})

QBpotPlot_1 <- function() {
  existing_cols <- colnames(potteryQB())
  keep <- existing_cols
  keep <- keep[grepl("count", keep)]
  #keep
  # remove "countTotal" as well
  keep <- keep[!grepl("countTotal", keep)]
  # needed for melt id
  keep <- c("identifier", keep, "relation.liesWithinLayer", "period", "period.start", "period.end")

  plot_data <- potteryQB() %>%
    select(all_of(keep)) %>%
    mutate(period = ifelse(is.na(period),
                           #as.character(period.end),
                           paste(period.start, "-", period.end, sep = ""),
                           as.character(period))) %>%
    mutate(period = ifelse(#is.na(period),
                           period == "NA-NA",
                         NA,
                        period))


  plot_data <- plot_data %>%
    filter(relation.liesWithinLayer %in% input$QB_layer_selector) %>%
    melt(id = c("identifier", "relation.liesWithinLayer", "period", "period.start", "period.end")) %>%
    mutate(value = ifelse(is.na(value), 0, value)) %>%
    mutate(value = as.numeric(value)) %>%
    mutate(variable = gsub("count", "", variable)) %>%
    mutate(variable = gsub("Rim|Base|Handle|Wall", "", variable)) %>%
    uncount(value) %>%
    period_filter(is_milet = is_milet, selector = input$QBpotPlot_1_period_selector)

  if (input$QBpotPlot_1_title == "") {
    plot_title <- paste("Vessel Forms from ", input$select_operation,
                        " in Context: ",
                        paste(input$QB_layer_selector, collapse = ", "),
                        sep = "")
  } else {
    plot_title <- input$QBpotPlot_1_title
  }


  if (input$QBpotPlot_2_display == "function") {
    p <- ggplot(plot_data, aes(x = fct_infreq(variable),
                               fill = period)) +
      geom_bar(position = input$QBpotPlot_1_bars) +
      Plot_Base_Theme +
      labs(x = "Vessel Forms", y = "count") +
      scale_fill_period
  } else if (input$QBpotPlot_2_display == "period") {
    p <- ggplot(plot_data, aes(x = period,
                               fill = fct_infreq(variable))) +
      geom_bar(position = input$QBpotPlot_1_bars) +
      Plot_Base_Theme +
      labs(x = "Period", y = "count")
  }


  if (input$QBpotPlot_1_display == "wrap") {
    p <- p + facet_wrap(~ relation.liesWithinLayer, ncol = 2)
  }

  p <- p +
    labs(title = plot_title,
         subtitle = input$QBpotPlot_1_subtitle)
  p
}

output$QBpotPlot_1 <- renderPlot({
  QBpotPlot_1()
})


output$QBpotPlot_1_png <- milQuant_dowloadHandler(plot = QBpotPlot_1(),
                                                  ftype = "png")
output$QBpotPlot_1_pdf <- milQuant_dowloadHandler(plot = QBpotPlot_1(),
                                                  ftype = "pdf")

