###### Reusable functions

# Prep for shiny
prep_for_shiny <<- function(data, reorder_periods = reorder_periods) {
  data <- data %>%
    idaifield_as_matrix() %>%
    as.data.frame() %>%
    remove_na_cols() %>%
    type.convert(as.is = FALSE)

  tryCatch({
    data <- data %>%
      mutate(date = as.Date(as.character(date), format = "%d.%m.%Y"))
  }, error = function(e) print(paste("prep_for_shiny(): ", e)))

  tryCatch({
    data <- data %>%
      mutate(beginningDate = as.Date(as.character(beginningDate), format = "%d.%m.%Y"))
  }, error = function(e) print(paste("prep_for_shiny(): ", e)))

  tryCatch({
    data <- data %>%
      mutate(endDate = as.Date(as.character(endDate), format = "%d.%m.%Y"))
  }, error = function(e) print(paste("prep_for_shiny(): ", e)))


  if(reorder_periods) {
    data <- data %>%
      mutate_at(c("period", "period.end", "period.start"), as.character) %>%
      # fix value for periods that have been assigned multiple periods
      # TODO i need to think of something better here, it is horrible
      mutate(period = ifelse(grepl(pattern = ";", period), "multiple", period)) %>%
      # assign "unbestimmt" instead of NA to make period picker work
      # TODO i need to think of something better here as well
      mutate(period = ifelse(is.na(period), "unbestimmt", period)) %>%
      mutate(period.end = ifelse(is.na(period.end), "unbestimmt", period.end)) %>%
      mutate(period.start = ifelse(is.na(period.start), "unbestimmt", period.start)) %>%
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
remove_na_cols <<- function(data) {
  na_cols <- apply(data, function(x) all(is.na(x)), MARGIN = 2)
  data <- data[, !na_cols]
  return(data)
}

# Returns the UIDs of entries belonging to the variable in question
uid_by_operation <<- function(filter_operation = "all",
                             index = react_index()) {

  if (filter_operation == "none") {
    parent_type <- "unknown"
  } else {
    parent_type <- index$type[index$identifier == filter_operation]
  }
  if (filter_operation == "all") {
    uid_filter <- index$UID
  } else if (parent_type == "Place") {
    uid_filter <- index %>%
      filter(Place == filter_operation) %>%
      pull(UID)
  } else if (filter_operation == "none") {
    uid_filter <- index %>%
      filter(Operation == filter_operation) %>%
      pull(UID)
  } else {
    uid_filter <- index %>%
      filter(isRecordedIn == filter_operation) %>%
      pull(UID)
  }
  return(uid_filter)
}



milQuant_dowloadHandler <<- function(plot = "plot", ftype = "png") {
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

make_layer_selector <<- function(data_all, inputId,
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

make_period_selector <<- function(inputId,
                                 label = "Select objects by periods") {
  sliderTextInput(
    inputId = inputId,
    label = label,
    choices = periods,
    selected = periods[c(1,length(periods))],
    force_edges = TRUE)
}


# apply the period filter if the config is milet
period_filter <<- function(find_df, is_milet = FALSE, selector = NULL) {
  if (is_milet) {
    find_df <- find_df %>%
      filter(period.start >= selector[1] & period.end <= selector[2])  %>%
      filter(period.end <= selector[2])
  }
  return(find_df)
}

mq_spinner <<- function(object) {
  withSpinner(object,
              image = "quant-spinner-smooth.gif",
              image.width = 100,
              image.height = 100)
}



