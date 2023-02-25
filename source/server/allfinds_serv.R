findPlot_data <- reactive({
  findPlot_data <- selected_db() %>%
    filter(type %in% find_types) %>%
    remove_na_cols() %>%
    inner_join(react_index()[,c("identifier", "Operation", "Place")],
               by = "identifier")
  return(findPlot_data)
})

output$allfinds_n <- renderText({
  validate(
    need(findPlot_data(), "No project selected.")
  )
  prettyNum(nrow(findPlot_data()), big.mark = ",")
})

output$allfinds_overview <- renderText({
  n_objects <- nrow(findPlot_data())
  n_layers <- length(unique(findPlot_data()$relation.liesWithinLayer))
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
  make_layer_selector(findPlot_data(),
                      inputId = "findPlot_layer_selector")
})

output$findPlot_var_selector <- renderUI({
  all_cols <- colnames(findPlot_data())
  findPlot_vars <- c("type")
  findPlot_vars <- c(findPlot_vars, "storagePlace")
  findPlot_vars <- c(findPlot_vars, "date")
  findPlot_vars <- c(findPlot_vars, "Operation")
  findPlot_vars <- c(findPlot_vars, "Place")
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
              choices = findPlot_vars, selected = "type")

})

make_allFindsPlot <- reactive({
  findPlot_tmp <- findPlot_data() %>%
    filter(relation.liesWithinLayer %in% input$findPlot_layer_selector) %>%
    period_filter(is_milet = is_milet, selector = input$findPlot_period_selector)

  if (input$findPlot_axis == "var_is_fill") {
    p <- findPlot_tmp %>%
      ggplot(aes(x = reorder(type,
                             type,
                             function(x)-length(x)),
                 fill = get(input$findPlot_PlotVar))) +
      labs(fill = input$findPlot_PlotVar,
           x = "Type of Find")
    if (input$findPlot_PlotVar == "period") {
      p <- p + scale_fill_period()
    }
  } else if (input$findPlot_axis == "var_is_x") {
    if (input$findPlot_PlotVar == "date") {
      p <- findPlot_tmp %>%
        ggplot(aes(x = date,
                   fill = type)) +
        scale_x_date(name = "Date of Processing")
    } else {
      p <- findPlot_tmp %>%
        ggplot(aes(x = reorder(get(input$findPlot_PlotVar),
                               get(input$findPlot_PlotVar),
                               function(x)-length(x)),
                   fill = type)) +
        labs(fill = "Type of Find",
             x = input$findPlot_PlotVar)
    }
  }


  p <- p + geom_bar(position = input$findPlot_bars) +
    Plot_Base_Theme + Plot_Base_Guide +
    labs(title = input$findPlot_title,
         subtitle = input$findPlot_subtitle,
         caption = paste("Total number of objects: ",
                         nrow(findPlot_tmp), sep = ""))
  p
})

output$allFindsPlot <- renderPlot({
  make_allFindsPlot()
})

output$allFindsPlot_png <- milQuant_dowloadHandler(plot = make_allFindsPlot(),
                                                ftype = "png")
output$allFindsPlot_pdf <- milQuant_dowloadHandler(plot = make_allFindsPlot(),
                                                ftype = "pdf")
