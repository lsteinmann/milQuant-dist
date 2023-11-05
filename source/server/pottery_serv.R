pottery <- reactive({
  validate(
    need(is.data.frame(selected_db()), "No Trenches and/or Places selected.")
  )

  pottery <- selected_db() %>%
    filter(category == "Pottery") %>%
    remove_na_cols()
  return(pottery)
})


output$pottery_overview <- renderText({
  n_objects <- nrow(pottery())
  n_layers <- length(unique(pottery()$relation.liesWithinLayer))
  paste("The selected trenches ", paste(input$selected_trenches, collapse = ", "),
        " (from ", paste(input$selected_operations, collapse = ", "),
        ") contain a total of ", n_objects,
        " Pottery-resources from ", n_layers, " contexts.",
        sep = "")
})

module_id <- "pottery_layers"
callModule(generateLayerSelector,
           id = module_id,
           module_id = module_id,
           data = pottery)

output$potPlot_1_period_selector <- renderUI({
  make_period_selector(inputId = "potPlot_1_period_selector")
})


potPlot_1_vars <- reactive({
  potPlot_1_vars <- colnames(pottery())
  potPlot_1_vars <- potPlot_1_vars[!potPlot_1_vars %in% drop_for_plot_vars]
  potPlot_1_vars <- potPlot_1_vars[!grepl("dimension", potPlot_1_vars)]
  potPlot_1_vars <- potPlot_1_vars[!grepl("amount.*", potPlot_1_vars)]
})

output$potPlot_1_x_selector <- renderUI({
  # Produce this selectInput on server to be dynamic
  selectInput(inputId = "potPlot_1_xvar", label = "Choose a variable for the x-axis:",
              choices = potPlot_1_vars())
})

output$potPlot_1_fill_selector <- renderUI({
  # Produce this selectInput on server to be dynamic
  selectInput(inputId = "potPlot_1_fillvar", label = "Choose a variable for the color:",
              choices = potPlot_1_vars())
})

potPlot_1_data <- reactive({
  validate(
    need(is.character(input$potPlot_1_fillvar), "No variables selected.")
  )

  plot_data <- pottery() %>%
    # filter the layers selected in the layer selector
    filter(relation.liesWithinLayer %in% input$selected_pottery_layers) %>%
    # filter by periods from the slider if config is milet
    period_filter(is_milet = is_milet,
                  selector = input$potPlot_1_period_selector) %>%
    mutate(x = get(input$potPlot_1_xvar),
           fill = get(input$potPlot_1_fillvar))
  plot_data
})

make_potPlot_1 <- reactive({
  if (grepl("period", input$potPlot_1_fillvar) & is_milet) {
    potPlot_1_scale_fill <- scale_fill_period()
  } else {
    potPlot_1_scale_fill <- scale_fill_discrete(name = input$potPlot_1_fillvar,
                                                guide = "legend")
  }

  p <- potPlot_1_data() %>%
    ggplot(aes(x = x,
               fill = fill,
               customdata = fill)) +
    geom_bar(position = input$potPlot_1_bars) +
    potPlot_1_scale_fill +
    labs(y = "Number of Objects", x = input$potPlot_1_xvar,
         title = input$potPlot_title,
         subtitle = input$potPlot_subtitle,
         caption = paste("Total:", nrow(potPlot_1_data())))

    p
})

output$potPlot_1 <- renderPlotly({
  convert_to_Plotly(make_potPlot_1(), source = "potPlot_1")
})

callModule(downloadPlotHandler, id = "potPlot_1_download",
           dlPlot = make_potPlot_1)


output$potPlot_1_clickData_check <- renderUI({
  choices <- colnames(potPlot_1_data())
  choices <- choices[-which(choices %in% c("identifier", "x", "fill"))]

  pickerInput(
    inputId = "potPlot_1_clickData_columns",
    label = "Choose columns to display:",
    choices = choices,
    selected = c("date", "period.start", "period.end", "shortDescription", "processor"),
    multiple = TRUE,
    options = list("actions-box" = TRUE,
                   "live-search" = TRUE,
                   "live-search-normalize" = TRUE,
                   "live-search-placeholder" = "Search here...")
  )
})

output$potPlot_1_clickData <- renderDataTable({
  click_data <- event_data("plotly_click", source = "potPlot_1")

  if (is.null(click_data)) {
    return(as.data.frame("Click a bar"))
  }

  x_vars <- sort(unique(potPlot_1_data()$x))

  potPlot_1_data() %>%
    filter(fill %in% click_data$customdata) %>%
    filter(x %in% x_vars[click_data$x]) %>%
    select(any_of(c("identifier", input$potPlot_1_clickData_columns)))
})


