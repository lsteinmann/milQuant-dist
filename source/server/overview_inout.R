overview_data <- table(uidlist$type, uidlist$Operation) %>%
  as.data.frame() %>%
  group_by(Var1) %>%
  mutate(freq_group = sum(Freq)) %>%
  ungroup() %>%
  mutate(Var1 = fct_reorder(Var1, -freq_group))

output$overview <- renderPlot({
  ggplot(data = overview_data, aes(x = Var1, fill = Var2, y = Freq)) +
    geom_bar(stat = "identity") +
    scale_fill_manual(name = "Operations",
                      values = uhhcol_two(length(unique(overview_data$Var2)))) +
    labs(x = "Resources in iDAI.field 2", y = "Count") +
    Plot_Base_Theme
}, height = 500)
