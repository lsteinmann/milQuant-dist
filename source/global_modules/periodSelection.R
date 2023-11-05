uiPeriodSelector <- function(id) {

  ns <- NS(id)

  htmlOutput(ns("period_selector"))
}

generatePeriodSelector <- function(id, inputid) {
  moduleServer(
    id,
    function(input, output, session) {

      label <- "Select objects by periods"

      output$period_selector <- renderUI({
        sliderTextInput(
          inputId = inputid,
          label = label,
          choices = periods,
          selected = periods[c(1,length(periods))],
          force_edges = TRUE)
      })

    }
  )
}
