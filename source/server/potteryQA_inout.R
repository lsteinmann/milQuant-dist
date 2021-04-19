potteryQA_all <- reactive({

  potteryQA_all <- milet_active() %>%
    select_by(by = "type", value = "Pottery_Quantification_A") %>%
    idaifield_as_matrix() %>%
    as.data.frame() %>%
    mutate_all(~ as.character(.))

  na_cols <- rowSums(apply(potteryQA_all,
                           function(x) is.na(x),
                           MARGIN = 1)) == 0
  potteryQA_all <- potteryQA_all[, -na_cols]
  potteryQA_all
})

output$QA_layer_selector = renderUI({#creates select box object called in ui

  selectible_layers <- unique(potteryQA_all()$relation.liesWithinLayer)
  #creates a reactive list of available counties based on the State selection made
  selectInput(inputId = "QA_layer_selector", label = "Choose one or many contexts",
              choices = c("all", selectible_layers),
              selected = "all",
              multiple = TRUE)
})

QA_pot_data <- reactive({
  if ("all" %in% input$QA_layer_selector) {
    QA_pot_data <- potteryQA_all()
  } else {
    POT_layer_selector <- input$QA_layer_selector
    QA_pot_data <- potteryQA_all() %>%
      filter(relation.liesWithinLayer %in% POT_layer_selector)
  }

  QA_pot_data
})

QApotPlot_1 <- function() {
  existing_cols <- colnames(QA_pot_data())
  to_remove <- c("shortDescription", "weightTotal", "countTotal", "processor",
                 "relation.isRecordedIn", "id", "type", "quantificationType",
                 "identifier", "relation.liesWithinLayer",
                 "quantificationOther")
  to_remove <- c(to_remove, existing_cols[grepl("weight", existing_cols)])
  rem_cols <- existing_cols[existing_cols %in% to_remove]

  plot_data <- QA_pot_data() %>%
    select(-rem_cols) %>%
    melt(id = "relation.liesWithin") %>%
    na.omit() %>%
    mutate(value = as.numeric(value)) %>%
    mutate(variable = gsub("count", "", variable))

  if (input$QApotPlot_1_display == "x") {
    p <- ggplot(plot_data, aes(x = reorder(variable, -value),
                               fill = relation.liesWithin,
                               y = value))
  } else if (input$QApotPlot_1_display == "fill") {
    p <- ggplot(plot_data, aes(x = reorder(relation.liesWithin, -value),
                               fill = variable,
                               y = value))
  }

  p +
    geom_bar(stat = "identity", position = input$QApotPlot_1_bars) +
    scale_fill_discrete(name = "Context") +
    Plot_Base_Theme +
    labs(x = "Group", y = "count")
}

output$QApotPlot_1 <- renderPlot({
  QApotPlot_1()
})


output$QApotPlot_1_png <- milQuant_dowloadHandler(plot = QApotPlot_1(),
                                                ftype = "png")
output$QApotPlot_1_pdf <- milQuant_dowloadHandler(plot = QApotPlot_1(),
                                                ftype = "pdf")


