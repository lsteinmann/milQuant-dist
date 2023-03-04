pottery <- reactive({
  validate(
    need(is.data.frame(selected_db()), "No Trenches and/or Places selected.")
  )

  pottery <- selected_db() %>%
    filter(type == "Pottery") %>%
    remove_na_cols()
  return(pottery)
})


output$pottery_overview <- renderText({
  n_objects <- nrow(pottery())
  n_layers <- length(unique(pottery()$relation.liesWithinLayer))
  paste("The selected trenches ", paste(input$select_trench, collapse = ", "),
        " (from ", paste(input$select_operation, collapse = ", "),
        ") contain a total of ", n_objects,
        " Pottery-resources from ", n_layers, " contexts.",
        sep = "")
})


output$POT_layer_selector <- renderUI({
  make_layer_selector(pottery(),
                      inputId = "POT_layer_selector")
})

output$potPlot_1_period_selector <- renderUI({
  make_period_selector(inputId = "potPlot_1_period_selector")
})

#pottery_data <- reactive({
#  select_layers(input_layer_selector = input$POT_layer_selector,
#                data_all = pottery())
#})


pottery_vars <- reactive({
  pottery_vars <- colnames(pottery())
  pottery_vars <- pottery_vars[!pottery_vars %in% drop_for_plot_vars]
  pottery_vars <- pottery_vars[!grepl("dimension", pottery_vars)]
  pottery_vars <- pottery_vars[!grepl("amount.*", pottery_vars)]
})

output$potPlot_1_x_selector <- renderUI({
  # Produce this selectInput on server to be dynamic
  selectInput(inputId = "potPlot_1_xvar", label = "Choose a variable for the x-axis:",
              choices = pottery_vars())
})

output$potPlot_1_fill_selector <- renderUI({
  # Produce this selectInput on server to be dynamic
  selectInput(inputId = "potPlot_1_fillvar", label = "Choose a variable for the color:",
              choices = pottery_vars())
})

potPlot_1_data <- reactive({
  validate(
    need(is.character(input$potPlot_1_fillvar), "No variables selected.")
  )

  plot_data <- pottery() %>%
    # filter the layers selected in the layer selector
    filter(relation.liesWithinLayer %in% input$POT_layer_selector) %>%
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

output$potPlot_1_png <- milQuant_dowloadHandler(plot = make_potPlot_1(),
                                                ftype = "png")
output$potPlot_1_pdf <- milQuant_dowloadHandler(plot = make_potPlot_1(),
                                                ftype = "pdf")

#"Insula UV/8-9") %>%#



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
    return("Click a bar")
  }

  x_vars <- sort(unique(potPlot_1_data()$x))

  potPlot_1_data() %>%
    filter(fill %in% click_data$customdata) %>%
    filter(x %in% x_vars[click_data$x]) %>%
    select(any_of(c("identifier", input$potPlot_1_clickData_columns)))
})


