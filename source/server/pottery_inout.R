pottery_overview_data <- reactive({
  milet_active() %>%
    select_by(by = "type", value = "^Pottery$") %>%
    prep_for_shiny(reorder_periods = TRUE)
})

output$pottery_overview <- renderText({
  n_objects <- nrow(pottery_overview_data())
  n_layers <- length(unique(pottery_overview_data()$relation.liesWithinLayer))
  paste("The selected operation (", paste(input$operation, collapse = ", "),
        ") contains a total of ", n_objects,
        " pottery resources from ", n_layers, " contexts. Kolay gelsin.",
        sep = "")
})


output$POT_layer_selector <- renderUI({
  make_layer_selector(pottery_overview_data(),
                      inputId = "POT_layer_selector")
})



pottery_data <- reactive({
  select_layers(input_layer_selector = input$POT_layer_selector,
                data_all = pottery_overview_data())
})


pottery_vars <- reactive({
  pottery_vars <- colnames(pottery_data())
  pottery_vars <- pottery_vars[!pottery_vars %in% drop_for_plot_vars]
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

potPlot_1 <- function() {

  if (grepl("period", input$potPlot_1_fillvar)) {
    potPlot_1_scale_fill <- scale_fill_period
  } else {
    potPlot_1_scale_fill <- scale_fill_discrete(name = input$potPlot_1_fillvar)
  }

  pottery_data() %>%
    # select by periods from the slider, i tested but am not totally sure if that works
    # very well
    filter(period.start >= input$period_select[1] & period.end <= input$period_select[2]) %>%
    filter(period.end <= input$period_select[2]) %>%
    ggplot(aes(x = get(input$potPlot_1_xvar),
               fill = get(input$potPlot_1_fillvar))) +
    geom_bar() + Plot_Base_Theme + potPlot_1_scale_fill +
    labs(y = "Number of Objects", x = input$potPlot_1_xvar)
}

output$potPlot_1 <- renderPlot({
  potPlot_1()
})

output$potPlot_1_png <- milQuant_dowloadHandler(plot = potPlot_1(),
                                                ftype = "png")
output$potPlot_1_pdf <- milQuant_dowloadHandler(plot = potPlot_1(),
                                                ftype = "pdf")

#"Insula UV/8-9") %>%#
