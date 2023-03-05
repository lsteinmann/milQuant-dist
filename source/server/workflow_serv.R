workflow_data <- reactive({
  validate(
    need(is.data.frame(selected_db()), "No Trenches and/or Places selected.")
  )

  base_data <- selected_db() %>%
    filter(type %in% find_types) %>%
    remove_na_cols() %>%
    inner_join(react_index()[,c("identifier", "Operation", "Place")],
               by = "identifier")
  return(base_data)
})


## Workflow Tabbox
output$workflow_tabs <- renderUI({

  #  workflow <- workflow_data() %>%
  #    select(identifier, contains("workflow"))

  workflow_cols <- grep("workflow", colnames(workflow_data()))
  workflow_cols <- colnames(workflow_data())[workflow_cols]

  total <- nrow(workflow_data())



  do.call(tabBox,
          append(list(width = 12, title = tagList(icon("gear"), "Workflow status")),
                 lapply(workflow_cols,
                        function(wfcol) {
                          # get the columns index
                          id <- which(colnames(workflow_data()) == wfcol)
                          # get all identifiers that apply
                          res <- which(workflow_data()[, id] == TRUE)
                          res <- as.character(workflow_data()$identifier[res])
                          res <- sort(res)
                          # get all identifiers that don't apply
                          neg <- which(is.na(workflow_data()[, id]))
                          neg <- as.character(workflow_data()$identifier[neg])
                          neg <- sort(neg)

                          title <- gsub("workflow.", "", wfcol, fixed = TRUE)
                          # display in green if its a good thing, in red if
                          # "fehlerhaft"
                          res_style <- ifelse(grepl("Fehlerhaft", wfcol),
                                              "color:red",
                                              "color:green")
                          perc <- round(length(res) / total * 100, digits = 1)
                          col <- ifelse(grepl("Fehlerhaft", wfcol),
                                        "red", "blue")

                          tabPanel(title = title,
                                   fluidRow(
                                     infoBox(width = 8, color = col,
                                             title = title,
                                             value = p("Applies to", strong(length(res)),
                                                       "out of", strong(total),
                                                       "objects (",
                                                       perc, "%).")),
                                     valueBox(subtitle = "Progress",
                                              value = paste0(perc, "%"),
                                              icon = icon("list"), width = 4,
                                              color = col)),
                                   h3("Objects in the plot where this box has been checked: "),
                                   p(paste(res, collapse = ", "),
                                     style = res_style),
                                   h3("... and objects where it has not:"),
                                   p(paste(neg, collapse = ", "),
                                     style = "color:grey"))
                        })
          )
  )
})
