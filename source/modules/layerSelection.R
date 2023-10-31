uiLayerSelector <- function(id) {

  ns <- NS(id)

  htmlOutput(ns("ui_layer_selector"))
}

generateLayerSelector <- function(input, output, session,
                                  module_id, data) {
  # creates the selector for layers present in 'data' as a relation
  label <- "Choose one or many contexts"

  # first get the unique values that will be displayed in the selectInput
  selectable_layers <- reactive({
    selectable_layers <- data()$relation.liesWithinLayer %>%
      unique() %>%
      as.character() %>%
      sort()
  })


  input_id <- paste0("selected_", module_id)

  # produce the selectInput object that will be displayed
  output$ui_layer_selector <- renderUI({
    pickerInput(inputId = input_id,
                label = label,
                choices = selectable_layers(),
                multiple = TRUE,
                selected = selectable_layers(),
                options = list("actions-box" = TRUE,
                               "live-search" = TRUE,
                               "live-search-normalize" = TRUE,
                               "live-search-placeholder" = "Search here..."))
  })

}
