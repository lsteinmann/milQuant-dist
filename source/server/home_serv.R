
output$overview_n <- renderText({
  validate(
    need(react_index(), "No project selected.")
  )
  prettyNum(nrow(react_index()), big.mark = ",")
})

output$overview <- renderPlot({
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
    select(type, Operation)


  alpha <- rep(0.3, length(na.omit(unique(tmp_index$Operation))))

  table(tmp_index$type, tmp_index$Operation) %>%
    as.data.frame() %>%
    group_by(Var1) %>%
    mutate(freq_group = sum(Freq)) %>%
    ungroup() %>%
    mutate(Var1 = fct_reorder(Var1, -freq_group)) %>%
    ggplot(aes(x = Var1, fill = Var2, y = Freq)) +
    geom_bar(stat = "identity") +
    scale_fill_discrete(name = "Places / Projects",
                        guide = guide_legend(nrow = 3)) +
    labs(x = "Resources in iDAI.field", y = "Count") +
    Plot_Base_Theme
}, height = 530)
