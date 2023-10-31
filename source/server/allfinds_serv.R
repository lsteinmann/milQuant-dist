allFinds_base_data <- reactive({

  validate(
    need(is.data.frame(selected_db()), "No Trenches and/or Places selected.")
  )

  allFinds_base_data <- selected_db() %>%
    filter(category %in% find_categories) %>%
    remove_na_cols() %>%
    inner_join(react_index()[,c("identifier", "Operation", "Place")],
               by = "identifier")
  return(allFinds_base_data)
})

output$allfinds_n <- renderText({
  validate(
    need(allFinds_base_data(), "No project selected.")
  )
  prettyNum(nrow(allFinds_base_data()), big.mark = ",")
})

output$allFinds_overview <- renderText({
  n_objects <- nrow(allFinds_base_data())
  n_layers <- length(unique(allFinds_base_data()$relation.liesWithinLayer))
  paste("The selected trenches ", paste(input$select_trench, collapse = ", "),
        " (from ", paste(input$select_operation, collapse = ", "),
        ") contain a total of ", n_objects,
        " Finds from ", n_layers, " contexts.",
        sep = "")
})

output$allFinds_period_selector <- renderUI({
  make_period_selector(inputId = "allFinds_period_selector")
})

module_id <- "allFinds_layers"
callModule(generateLayerSelector,
           id = module_id,
           module_id = module_id,
           data = allFinds_base_data)


output$allFinds_var_selector <- renderUI({
  all_cols <- colnames(allFinds_base_data())
  allFinds_vars <- c("category", "storagePlace", "date", "Operation", "Place")
  allFinds_vars <- c(allFinds_vars, all_cols[grepl("relation", all_cols)])
  allFinds_vars <- c(allFinds_vars, all_cols[grepl("workflow", all_cols)])
  allFinds_vars <- c(allFinds_vars, all_cols[grepl("period", all_cols)])
  allFinds_vars <- c(allFinds_vars, all_cols[grepl("campaign", all_cols)])

  to_remove <- c("isDepictedIn", "isInstanceOf", "isSameAs",
                 allFinds_vars[!allFinds_vars %in% all_cols])


  allFinds_vars <- allFinds_vars[!grepl(paste(to_remove,collapse = "|"),
                                        allFinds_vars)]

  rm(all_cols, to_remove)

  # Produce this selectInput on server to be dynamic
  selectInput(inputId = "allFinds_PlotVar",
              label = "Choose a variable for the color:",
              choices = allFinds_vars, selected = "category")

})

allFindsPlot_data <- reactive({
  validate(
    need(is.character(input$allFinds_PlotVar), "No variable selected.")
  )
  allFindsPlot_data <- allFinds_base_data() %>%
    filter(relation.liesWithinLayer %in% input$selected_allFinds_layers) %>%
    period_filter(is_milet = is_milet, selector = input$allFinds_period_selector)

  return(allFindsPlot_data)
})

make_allFindsPlot <- reactive({
  plot_data <- allFindsPlot_data() %>%
    mutate(var = get(input$allFinds_PlotVar)) %>%
    select(category, var) %>%
    mutate(category = fct_infreq(category))

  if (is.logical(plot_data$var)) {
    plot_data <- plot_data %>%
      mutate(var = ifelse(is.na(var),
                          FALSE,
                          TRUE))
  } else {
    plot_data <- plot_data %>%
      mutate(var = fct_infreq(var))
  }


  if (input$allFinds_axis == "var_is_fill") {
    p <- plot_data %>%
      ggplot(aes(x = category,
                 fill = var)) +
      labs(fill = input$allFinds_PlotVar,
           x = "Category of Find")
    p
    if (input$allFinds_PlotVar == "period") {
      p <- p + scale_fill_period()
    }
  } else if (input$allFinds_axis == "var_is_x") {
    if (input$allFinds_PlotVar == "date") {
      p <- plot_data %>%
        ggplot(aes(x = date,
                   fill = category)) +
        scale_x_date(name = "Date of Processing")
    } else {
      p <- plot_data %>%
        ggplot(aes(x = var,
                   fill = category)) +
        labs(fill = "Type of Find",
             x = input$allFinds_PlotVar)
    }
  }


  p <- p + geom_bar(position = input$allFinds_bars) +
    labs(title = input$allFinds_title,
         subtitle = input$allFinds_subtitle,
         caption = paste("Total number of objects: ",
                         nrow(plot_data), sep = ""))
  p
})

output$allFindsPlot <- renderPlotly({
  convert_to_Plotly(make_allFindsPlot())
})

callModule(downloadPlotHandler, id = "allFindsPlot_download",
           dlPlot = make_allFindsPlot)



