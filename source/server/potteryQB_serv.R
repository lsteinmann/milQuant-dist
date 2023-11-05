potteryQB <- reactive({
  validate(
    need(is.data.frame(selected_db()), "No Trenches and/or Places selected.")
  )

  potteryQB <- selected_db() %>%
    filter(category == "Pottery_Quantification_B") %>%
    remove_na_cols()
  return(potteryQB)
})

output$potteryQB_overview <- renderText({
  n_objects <- nrow(potteryQB())
  n_layers <- length(unique(potteryQB()$relation.liesWithinLayer))
  paste("The selected place (", paste(input$selected_operations, collapse = ", "),
        ") contains a total of ", n_objects,
        " pottery quantification (B) forms from ", n_layers, " contexts. Kolay gelsin.\\n",
        "Please note: It doesnt work to select two periods... we have to resolve this somehow.",
        sep = "")
})

generateLayerSelector("potteryQB_layers", potteryQB, inputid = "selected_potteryQB_layers")


output$potteryQBPlot_1_period_selector <- renderUI({
  make_period_selector(inputId = "potteryQBPlot_1_period_selector")
})

potteryQBPlot_1_data <- reactive({
  validate(
    need(is.data.frame(potteryQB()), "Data not available.")
  )
  existing_cols <- colnames(potteryQB())
  keep <- existing_cols
  keep <- keep[grepl("count", keep)]
  #keep
  # remove "countTotal" as well
  keep <- keep[!grepl("countTotal", keep)]
  # needed for melt id
  keep <- c("identifier", keep, "relation.liesWithinLayer", "period", "period.start", "period.end")

  plot_data <- potteryQB() %>%
    select(all_of(keep))


  plot_data <- plot_data %>%
    filter(relation.liesWithinLayer %in% input$selected_potteryQB_layers) %>%
    period_filter(is_milet = is_milet,
                  selector = input$potteryQBPlot_1_period_selector) %>%
    melt(id = c("identifier", "relation.liesWithinLayer", "period", "period.start", "period.end")) %>%
    mutate(value = ifelse(is.na(value), 0, value)) %>%
    mutate(value = as.numeric(value)) %>%
    mutate(variable = gsub("count", "", variable)) %>%
    mutate(variable = gsub("Rim|Base|Handle|Wall", "", variable)) %>%
    uncount(value) %>%
    mutate(variable = fct_infreq(variable))
  return(plot_data)
})

potteryQBPlot_1 <- reactive({
  validate(
    need(is.data.frame(potteryQBPlot_1_data()), "Data not available.")
  )

  if (input$potteryQBPlot_1_title == "") {
    plot_title <- paste("Vessel Forms from Context: ",
                        paste(input$selected_potteryQB_layers, collapse = ", "),
                        sep = "")
  } else {
    plot_title <- input$potteryQBPlot_1_title
  }


  if (input$potteryQBPlot_1_display_xaxis == "function") {
    p <- ggplot(potteryQBPlot_1_data(), aes(x = variable,
                               fill = period)) +
      labs(x = "Vessel Forms", y = "count") +
      scale_fill_period(ncol = 9)
  } else if (input$potteryQBPlot_1_display_xaxis == "period") {
    p <- ggplot(potteryQBPlot_1_data(), aes(x = period,
                               fill = variable)) +
      scale_fill_discrete(name = "Function", guide = "legend") +
      labs(x = "Period", y = "count")
  }


  if (input$potteryQBPlot_1_display_context == "wrap") {
    p <- p + facet_wrap(~ relation.liesWithinLayer, ncol = 2)
  }

  p <- p +
    labs(title = plot_title,
         subtitle = input$potteryQBPlot_1_subtitle,
         caption = paste("Total Number of Fragments:", nrow(potteryQBPlot_1_data()))) +
    geom_bar(position = input$potteryQBPlot_1_bars)
  p
})

output$potteryQBPlot_1 <- renderPlotly({
  convert_to_Plotly(potteryQBPlot_1())
})

callModule(downloadPlotHandler, id = "potteryQBPlot_1_download",
           dlPlot = make_potteryQBPlot_1)


