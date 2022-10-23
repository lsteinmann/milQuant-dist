bricks <- reactive({
  bricks <- selected_db() %>%
    filter(type == "Brick") %>%
    remove_na_cols()
  return(bricks)
})

output$bricks_overview <- renderText({
  n_objects <- nrow(bricks())
  n_layers <- length(unique(bricks()$relation.liesWithinLayer))
  paste("The selected place (", paste(input$select_operation, collapse = ", "),
        ") contains a total of ", n_objects,
        " Loomweights from ", n_layers, " contexts. Kolay gelsin.",
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




output$bricksPlot_1 <- renderPlot({

  #fill_name <- names(fill_vars[which(fill_vars == input$lwPlot_1_fillvar)])

  bricks() %>%
    # filter by periods from the slider if config is milet
    period_filter(is_milet = is_milet, selector = input$bricks_period_selector) %>%
    filter(relation.liesWithinLayer %in% input$bricks_layer_selector) %>%
    ggplot(aes(x = brickForm)) +#, fill = get(input$bricksPlot_1_fillvar))) +
    geom_bar() +
    scale_fill_discrete() +#name = fill_name) +
    scale_y_continuous(name = "number of bricks") +
    scale_x_discrete(name = "bla") +
    Plot_Base_Theme

})


output$bricksPlot_1_png <- milQuant_dowloadHandler(plot = bricksPlot_1(),
                                                ftype = "png")
output$bricksPlot_1_pdf <- milQuant_dowloadHandler(plot = bricksPlot_1(),
                                                ftype = "pdf")
