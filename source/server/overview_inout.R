output$overview_n <- renderText({
  prettyNum(nrow(uidlist), big.mark = ",")
})

output$overview <- renderPlot({
  filter_op <- input$operation
  if (filter_op == "all") {
    filter_op <- unique(uidlist$Operation)
  }

  alpha <- rep(0.3, length(unique(uidlist$Operation)))

  table(uidlist$type, uidlist$Operation) %>%
    as.data.frame() %>%
    group_by(Var1) %>%
    mutate(freq_group = sum(Freq)) %>%
    ungroup() %>%
    mutate(Var1 = fct_reorder(Var1, -freq_group)) %>%
    filter(Var2 %in% filter_op) %>%
    ggplot(aes(x = Var1, fill = Var2, y = Freq)) +
    geom_bar(stat = "identity") +
    scale_fill_discrete(name = "Operations",
                        guide = guide_legend(nrow = 1)) +
                      #values = uhhcol_two(length(unique(uidlist$Operation)))) +
    labs(x = "Resources in iDAI.field 2", y = "Count") +
    Plot_Base_Theme
}, height = 530)
