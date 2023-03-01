findPlot_base_data <- reactive({
  findPlot_base_data <- selected_db() %>%
    filter(type %in% find_types) %>%
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

findPlot_selected_data <- reactive({
  findPlot_base_data() %>%
    filter(relation.liesWithinLayer %in% input$findPlot_layer_selector) %>%
    period_filter(is_milet = is_milet, selector = input$findPlot_period_selector)
})

make_allFindsPlot <- reactive({
  if (input$findPlot_axis == "var_is_fill") {
    p <- findPlot_selected_data() %>%
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
      p <- findPlot_selected_data() %>%
        ggplot(aes(x = date,
                   fill = type)) +
        scale_x_date(name = "Date of Processing")
    } else {
      p <- findPlot_selected_data() %>%
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
                         nrow(findPlot_selected_data()), sep = ""))
  p
})

output$allFindsPlot <- renderPlotly({
  plotly::ggplotly(make_allFindsPlot()) %>%
    layout(title = list(text = paste0(input$findPlot_title,
                                      '<br>',
                                      '<sup>',
                                      input$findPlot_subtitle,
                                      '</sup>')))
})


output$allfinds_plotinfo <- renderText({



  xy_str <- function(e) {
    if(is.null(e)) return("NULL\n")
    paste0("x=", round(e$x, 1), " y=", round(e$y, 1), "\n")
  }
  xy_range_str <- function(e) {
    if(is.null(e)) return("NULL\n")
    paste0("xmin=", round(e$xmin, 1), " xmax=", round(e$xmax, 1),
           " ymin=", round(e$ymin, 1), " ymax=", round(e$ymax, 1))
  }

  paste0(
    "click: ", xy_str(input$allFindsPlot_click),
    "hover: ", xy_str(input$allFindsPlot_hover),
    "brush: ", xy_range_str(input$allFindsPlot_brush)
  )


})

output$allFindsPlot_png <- milQuant_dowloadHandler(plot = make_allFindsPlot(),
                                                ftype = "png")
output$allFindsPlot_pdf <- milQuant_dowloadHandler(plot = make_allFindsPlot(),
                                                ftype = "pdf")
