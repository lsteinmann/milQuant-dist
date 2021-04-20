###### Reusable functions

# Prep for shiny
prep_for_shiny <- function(data, reorder_periods = TRUE) {
  data <- data %>%
    idaifield_as_matrix() %>%
    as.data.frame() %>%
    mutate_all(~ as.character(.)) %>%
    na_if("NA") %>%
    remove_na_cols()

  if(reorder_periods) {
    data <- data %>%
      mutate(period = factor(period,
                             levels = levels(periods),
                             ordered = TRUE),
             period.end = factor(period.end,
                                 levels = levels(periods),
                                 ordered = TRUE),
             period.start = factor(period.start,
                                   levels = levels(periods),
                                   ordered = TRUE))
  }
  return(data)
}



# Helper to remove columns that are empty
remove_na_cols <- function(data) {
  na_cols <- rowSums(apply(data,
                           function(x) is.na(x),
                           MARGIN = 1)) == 0
  data <- data[, -na_cols]
  return(data)
}



milQuant_dowloadHandler <- function(plot = "plot", ftype = "png") {
  downloadHandler(
    filename = paste(format(Sys.Date(), "%Y%m%d"),
                     "_milQuant_plot.", ftype, sep = ""),
    content <- function(file) {
      ggsave(file, plot = plot, device = ftype,
             width = 25, height = 15, units = "cm")
    }
  )
}

make_layer_selector <- function(data_all, inputId,
                                label = "Choose one or many contexts") {
  # creates the selector for layers present in data_all as a relation

  # first get the unique values that will be displayed in the selectInput
  selectible_layers <- unique(data_all$relation.liesWithinLayer)
  # produce the selectInput object that will be displayed
  pickerInput(inputId = inputId,
              label = label,
              choices = selectible_layers,
              multiple = TRUE,
              selected = selectible_layers,
              options = list("actions-box" = TRUE,
                             "live-search" = TRUE,
                             "live-search-normalize" = TRUE,
                             "live-search-placeholder" = "Search here..."))
}

# Subset the layers and use all if "all"
select_layers <- function(data_all, input_layer_selector) {
  data <- data_all %>%
    filter(relation.liesWithinLayer %in% input_layer_selector)
}
