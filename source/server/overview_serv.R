
output$overview_n <- renderText({
  validate(
    need(react_index(), "No project selected.")
  )
  prettyNum(nrow(react_index()), big.mark = ",")
})

output$overview <- renderPlotly({
  validate(
    need(react_index(), "No project selected.")
  )

  tmp_index <- react_index()
  if (!is.null(input$select_operation)) {
    tmp_index <- react_index() %>%
      filter(Place %in% input$select_operation)
  } else {
    tmp_index <- react_index()
  }
  tmp_index <- tmp_index %>%
    select(category, Operation)

  # nrow <- length(unique(tmp_index$Operation))
  # nrow <- floor(nrow / 12)

  plotdata <- table(tmp_index$category, tmp_index$Operation) %>%
    as.data.frame() %>%
    group_by(Var1) %>%
    mutate(freq_group = sum(Freq)) %>%
    ungroup() %>%
    mutate(Var1 = fct_reorder(Var1, -freq_group))

  colnames(plotdata) <- c("category", "trench", "count")

  p <- ggplot(plotdata, aes(x = category, fill = trench, y = count)) +
    geom_bar(stat = "identity") +
    scale_fill_discrete(name = "Trenches / Operations") +
                        #guide = guide_legend(byrow = TRUE, nrow = nrow)) +
    labs(x = "resources in the selected database", y = "count",
         caption = paste("Total: ", sum(plotdata$count)))

  convert_to_Plotly(p)
})
