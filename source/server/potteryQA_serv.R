potteryQA <- reactive({
  validate(
    need(is.data.frame(selected_db()), "No Trenches and/or Places selected.")
  )

  potteryQA <- selected_db() %>%
    filter(category == "Pottery_Quantification_A") %>%
    remove_na_cols()
  return(potteryQA)
})

output$potteryQA_overview <- renderText({
  n_objects <- nrow(potteryQA())
  n_layers <- length(unique(potteryQA()$relation.liesWithinLayer))
  paste("The selected place (", paste(input$selected_operations, collapse = ", "),
        ") contains a total of ", n_objects,
        " pottery quantification (A) forms from ", n_layers, " contexts. Kolay gelsin.",
        sep = "")
})

generateLayerSelector("QA_layers", potteryQA, inputid = "selected_QA_layers")


potteryQAPlot_data <- reactive({
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
    filter(relation.liesWithinLayer %in% input$selected_QA_layers) %>%
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

#potteryQAPlot_data <- function() { return(plot_data)}

potteryQAPlot_1 <- reactive({


  if (input$potteryQAPlot_1_display == "fill") {
    p <- ggplot(potteryQAPlot_data(), aes(x = variable,
                               fill = relation.liesWithinLayer))
    legend_title <- "Context"
    x_axis_title <- "functional category"
  } else if (input$potteryQAPlot_1_display == "x") {
    p <- ggplot(potteryQAPlot_data(), aes(x = relation.liesWithinLayer,
                               fill = variable))
    legend_title <- "functional category"
    x_axis_title <- "Context"

  } else if (input$potteryQAPlot_1_display == "none") {

    p <- ggplot(potteryQAPlot_data(), aes(x = variable))
    legend_title <- "none"
    x_axis_title <- "Vessel Forms"
  }

  if (input$potteryQAPlot_1_title == "") {
    plot_title <- paste("Vessel Forms from Context: ",
                        paste(input$selected_QA_layers, collapse = ", "),
                        sep = "")
  } else {
    plot_title <- input$potteryQAPlot_1_title
  }

  p <- p +
    geom_bar(position = input$potteryQAPlot_1_bars) +
    scale_fill_discrete(name = legend_title, guide = "legend") +
    labs(x = x_axis_title, y = "count",
         title = plot_title,
         subtitle = input$potteryQAPlot_1_subtitle,
         caption = paste("Total Number of Fragments:", nrow(potteryQAPlot_data())))
  p
})

output$potteryQAPlot_1 <- renderPlotly({
  convert_to_Plotly(potteryQAPlot_1())
})

callModule(downloadPlotHandler, id = "potteryQAPlot_1_download",
           dlPlot = make_potteryQAPlot_1)

