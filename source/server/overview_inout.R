output$overview_n <- renderText({
  prettyNum(nrow(react_index()), big.mark = ",")
})

output$overview <- renderPlot({
  filter_place <- input$select_place
  if (filter_place == "all") {
    filter_place <- na.omit(unique(react_index()$Place))
  }

  alpha <- rep(0.3, length(na.omit(unique(react_index()$Place))))

  table(react_index()$type, react_index()$Place) %>%
    as.data.frame() %>%
    group_by(Var1) %>%
    mutate(freq_group = sum(Freq)) %>%
    ungroup() %>%
    mutate(Var1 = fct_reorder(Var1, -freq_group)) %>%
    filter(Var2 %in% filter_place) %>%
    ggplot(aes(x = Var1, fill = Var2, y = Freq)) +
    geom_bar(stat = "identity") +
    scale_fill_discrete(name = "Places / Projects",
                        guide = guide_legend(nrow = 1)) +
    #values = uhhcol_two(length(unique(react_index()$Place))) +
    labs(x = "Resources in iDAI.field", y = "Count") +
    Plot_Base_Theme
}, height = 530)
