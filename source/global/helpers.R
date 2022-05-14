###### Reusable functions

# Prep for shiny
prep_for_shiny <- function(data, reorder_periods = TRUE) {
  data <- data %>%
    idaifield_as_matrix() %>%
    as.data.frame() %>%
    remove_na_cols() %>%
    #select(!any_of(drop_for_plot_vars)) %>% # no, dont do that, stupid
    type.convert(as.is = FALSE)

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
  na_cols <- apply(data, function(x) all(is.na(x)), MARGIN = 2)
  data <- data[, !na_cols]
  return(data)
}


# Returns the UIDs of entries belongig to the Place in question
uid_to_filter <- function(place = "all", index = react_index()) {
  if (place == "all") {
    uids <- index$UID
  } else {
    uids <- index$UID[which(index$Place == place)]
  }
  return(uids)
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

#data_all <- test

#selectable_layers

make_layer_selector <- function(data_all, inputId,
                                label = "Choose one or many contexts") {
  # creates the selector for layers present in data_all as a relation

  # first get the unique values that will be displayed in the selectInput
  selectable_layers <- data_all$relation.liesWithinLayer %>%
    unique() %>%
    as.character() %>%
    sort()
  # produce the selectInput object that will be displayed
  pickerInput(inputId = inputId,
              label = label,
              choices = sort(selectable_layers),
              multiple = TRUE,
              selected = sort(selectable_layers),
              options = list("actions-box" = TRUE,
                             "live-search" = TRUE,
                             "live-search-normalize" = TRUE,
                             "live-search-placeholder" = "Search here..."))
}


