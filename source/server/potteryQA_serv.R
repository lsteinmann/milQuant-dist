potteryQA <- reactive({
  validate(
    need(is.data.frame(selected_db()), "No Trenches and/or Places selected.")
  )

  potteryQA <- selected_db() %>%
    filter(category == "Pottery_Quantification_A") %>%
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

QApotPlot_data <- reactive({
  validate(
    need(is.data.frame(potteryQA()), "Data not available.")
  )
  existing_cols <- colnames(potteryQA())
  keep <- existing_cols
  keep <- keep[grepl("count", keep)]
  #keep
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
    uncount(value) %>%
    # sorting factors by frequency here to make plotly tooltip nicer
    mutate(variable = fct_infreq(variable),
           relation.liesWithinLayer = fct_infreq(relation.liesWithinLayer))
  return(plot_data)
})

#QApotPlot_data <- function() { return(plot_data)}

QApotPlot_1 <- reactive({


  if (input$QApotPlot_1_display == "fill") {
    p <- ggplot(QApotPlot_data(), aes(x = variable,
                               fill = relation.liesWithinLayer))
    legend_title <- "Context"
    x_axis_title <- "functional category"
  } else if (input$QApotPlot_1_display == "x") {
    p <- ggplot(QApotPlot_data(), aes(x = relation.liesWithinLayer,
                               fill = variable))
    legend_title <- "functional category"
    x_axis_title <- "Context"

  } else if (input$QApotPlot_1_display == "none") {

    p <- ggplot(QApotPlot_data(), aes(x = variable))
    legend_title <- "none"
    x_axis_title <- "Vessel Forms"
  }

  if (input$QApotPlot_1_title == "") {
    plot_title <- paste("Vessel Forms from Context: ",
                        paste(input$QA_layer_selector, collapse = ", "),
                        sep = "")
  } else {
    plot_title <- input$QApotPlot_1_title
  }

  p <- p +
    geom_bar(position = input$QApotPlot_1_bars) +
    scale_fill_discrete(name = legend_title, guide = "legend") +
    labs(x = x_axis_title, y = "count",
         title = plot_title,
         subtitle = input$QApotPlot_1_subtitle,
         caption = paste("Total Number of Fragments:", nrow(QApotPlot_data())))
  p
})

output$QApotPlot_1 <- renderPlotly({
  convert_to_Plotly(QApotPlot_1())
})

callModule(downloadPlotHandler, id = "QApotPlot_1_download",
           dlPlot = make_QApotPlot_1)

