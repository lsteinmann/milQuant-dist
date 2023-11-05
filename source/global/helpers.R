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
    parent_category <- "unknown"
  } else {
    parent_category <- index$category[index$identifier == filter_operation]
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


milquant_plotly_layout <<- function(plotly_fig, caption = FALSE) {
  plotly_fig <- plotly_fig %>%
    config(displaylogo = FALSE,
           modeBarButtonsToRemove = c("select2d", "lasso2d")) %>%
    layout(yaxis = list(tickmode = "auto", showline = FALSE, gridwidth = 3,
                        gridcolor = "grey20"),
           xaxis = list(gridcolor = "grey60"),
           showlegend = TRUE)

  if (is.character(caption)) {
    plotly_fig <- plotly_fig %>%
      layout(annotations = list(text = caption,
                                xref = "paper", yref = "paper",
                                xanchor = "right", yanchor = "top",
                                x = 1, y = 1,
                                showarrow = FALSE,
                                bgcolor = "white",
                                font = list(size = 10)))
  }

  return(plotly_fig)
}


convert_to_Plotly <<- function(ggplot_p,
                               source = "ggplot_source",
                               tooltip = c("y", "x", "fill")) {
  # add theme
  ggplot_p <- ggplot_p + Plot_Base_Theme

  plot_ly <- ggplotly(ggplot_p, source = source, tooltip = tooltip) %>%
    layout(title = list(text = paste0(ggplot_p$labels$title, "<br>",
                                      "<sup>", ggplot_p$labels$subtitle, "</sup>")))
  plot_ly <- milquant_plotly_layout(plot_ly, caption = ggplot_p$labels$caption)
  return(plot_ly)
}

idf_uid_query <<- function(login_connection, uids) {
  message("Started the query...")
  query <- paste('{ "selector": { "_id": { "$in": [',
                 paste0('"', uids, '"', collapse = ", "),
                 '] } }}',
                 sep = "")
  proj_client <- idaifieldR:::proj_idf_client(login_connection,
                                 include = "query")
  message("Loading...")

  response <- proj_client$post(body = query)
  response <- idaifieldR:::response_to_list(response)
  message("Done.\nProcessing...")

  result <- lapply(response$docs,
                   function(x) list("id" = x$resource$id, "doc" = x))


  result <- idaifieldR:::name_docs_list(result)
  result <- idaifieldR:::type_to_category(result)

  new_names <- lapply(result, function(x) x$identifier)
  new_names <- unlist(new_names)
  names(result) <- new_names

  message("Done.")

  attr(result, "connection") <- login_connection
  attr(result, "projectname") <- login_connection$project
  message("Getting config at this point:")
  attr(result, "config") <- get_configuration(login_connection)

  result <- structure(result, class = "idaifield_docs")
  return(result)
}
