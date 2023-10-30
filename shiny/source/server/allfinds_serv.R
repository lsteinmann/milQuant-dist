findPlot_base_data <- reactive({

  validate(
    need(is.data.frame(selected_db()), "No Trenches and/or Places selected.")
  )

  findPlot_base_data <- selected_db() %>%
    filter(category %in% find_categories) %>%
    remove_na_cols() %>%
    inner_join(react_index()[,c("identifier", "Operation", "Place")],
               by = "identifier")
  return(findPlot_base_data)
})

output$allfinds_n <- renderText({
  validate(
    need(findPlot_base_data(), "No project selected.")
  )
  prettyNum(nrow(findPlot_base_data()), big.mark = ",")
})

output$allfinds_overview <- renderText({
  n_objects <- nrow(findPlot_base_data())
  n_layers <- length(unique(findPlot_base_data()$relation.liesWithinLayer))
  paste("The selected trenches ", paste(input$select_trench, collapse = ", "),
        " (from ", paste(input$select_operation, collapse = ", "),
        ") contain a total of ", n_objects,
        " Finds from ", n_layers, " contexts.",
        sep = "")
})

output$findPlot_period_selector <- renderUI({
  make_period_selector(inputId = "findPlot_period_selector")
})

output$findPlot_layer_selector <- renderUI({
  make_layer_selector(findPlot_base_data(),
                      inputId = "findPlot_layer_selector")
})

output$findPlot_var_selector <- renderUI({
  all_cols <- colnames(findPlot_base_data())
  findPlot_vars <- c("category", "storagePlace", "date", "Operation", "Place")
  findPlot_vars <- c(findPlot_vars, all_cols[grepl("relation", all_cols)])
  findPlot_vars <- c(findPlot_vars, all_cols[grepl("workflow", all_cols)])
  findPlot_vars <- c(findPlot_vars, all_cols[grepl("period", all_cols)])
  findPlot_vars <- c(findPlot_vars, all_cols[grepl("campaign", all_cols)])

  to_remove <- c("isDepictedIn", "isInstanceOf", "isSameAs",
                 findPlot_vars[!findPlot_vars %in% all_cols])


  findPlot_vars <- findPlot_vars[!grepl(paste(to_remove,collapse = "|"),
                                        findPlot_vars)]

  rm(all_cols, to_remove)

  # Produce this selectInput on server to be dynamic
  selectInput(inputId = "findPlot_PlotVar",
              label = "Choose a variable for the color:",
              choices = findPlot_vars, selected = "category")

})

allFindsPlot_data <- reactive({
  validate(
    need(is.character(input$findPlot_PlotVar), "No variable selected.")
  )
  allFindsPlot_data <- findPlot_base_data() %>%
    filter(relation.liesWithinLayer %in% input$findPlot_layer_selector) %>%
    period_filter(is_milet = is_milet, selector = input$findPlot_period_selector)

  return(allFindsPlot_data)
})

make_allFindsPlot <- reactive({
  plot_data <- allFindsPlot_data() %>%
    mutate(var = get(input$findPlot_PlotVar)) %>%
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


  if (input$findPlot_axis == "var_is_fill") {
    p <- plot_data %>%
      ggplot(aes(x = category,
                 fill = var)) +
      labs(fill = input$findPlot_PlotVar,
           x = "Category of Find")
    p
    if (input$findPlot_PlotVar == "period") {
      p <- p + scale_fill_period()
    }
  } else if (input$findPlot_axis == "var_is_x") {
    if (input$findPlot_PlotVar == "date") {
      p <- plot_data %>%
        ggplot(aes(x = date,
                   fill = category)) +
        scale_x_date(name = "Date of Processing")
    } else {
      p <- plot_data %>%
        ggplot(aes(x = var,
                   fill = category)) +
        labs(fill = "Type of Find",
             x = input$findPlot_PlotVar)
    }
  }


  p <- p + geom_bar(position = input$findPlot_bars) +
    labs(title = input$findPlot_title,
         subtitle = input$findPlot_subtitle,
         caption = paste("Total number of objects: ",
                         nrow(plot_data), sep = ""))
  p
})

output$allFindsPlot <- renderPlotly({
  convert_to_Plotly(make_allFindsPlot())
})

callModule(downloadPlotHandler, id = "allFindsPlot_download",
           dlPlot = make_allFindsPlot)



