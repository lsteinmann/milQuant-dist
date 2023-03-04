bricks <- reactive({
  bricks <- selected_db() %>%
    filter(type == "Brick") %>%
    remove_na_cols()
  return(bricks)
})

output$bricks_overview <- renderText({
  n_objects <- nrow(bricks())
  n_layers <- length(unique(bricks()$relation.liesWithinLayer))
  paste("The selected trenches ", paste(input$select_trench, collapse = ", "),
        " (from ", paste(input$select_operation, collapse = ", "),
        ") contain a total of ", n_objects,
        " Brick-Resources from ", n_layers, " contexts.",
        sep = "")
})

output$bricks_layer_selector <- renderUI({
  make_layer_selector(bricks(),
                      inputId = "bricks_layer_selector")
})

output$bricks_period_selector <- renderUI({
  make_period_selector(inputId = "bricks_period_selector")
})

#plot_vars <- list("Operation" = "relation.isRecordedIn",
#                  "Form of Brick" = "brickForm",
#                  #"Type of Roof" = "roofType",
#                  "brickType", "brickUsage", "condition",
#               "conditionAmount", "date", "decorationTechnique",
#               "fabricColorBreakMunsell", "fabricHardness",
#               "manufacturingMethod", "provenance", "specificType")


make_bricksPlot_1 <- reactive({
  #fill_name <- names(fill_vars[which(fill_vars == input$lwPlot_1_fillvar)])

  p <- bricks() %>%
    # filter by periods from the slider if config is milet
    period_filter(is_milet = is_milet, selector = input$bricks_period_selector) %>%
    filter(relation.liesWithinLayer %in% input$bricks_layer_selector) %>%
    ggplot(aes(x = brickForm)) +#, fill = get(input$bricksPlot_1_fillvar))) +
    geom_bar() +#name = fill_name) +
    scale_y_continuous(name = "number of bricks") +
    scale_x_discrete(name = "type of brick") +
    labs(title = input$bricksPlot_1_title, subtitle = input$bricksPlot_1_subtitle)
  p
})

output$bricksPlot_1 <- renderPlotly({
  convert_to_Plotly(make_bricksPlot_1())
})


output$bricksPlot_1_png <- milQuant_dowloadHandler(plot = make_bricksPlot_1(),
                                                ftype = "png")
output$bricksPlot_1_pdf <- milQuant_dowloadHandler(plot = make_bricksPlot_1(),
                                                ftype = "pdf")
