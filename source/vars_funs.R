uhhcol <- c("#e2001a", "#3b515b")
uhhcol <- colorRampPalette(uhhcol)


Plot_Base_Theme <- theme(panel.background = element_blank(),
                         panel.grid.major = element_line(color = "grey60",
                                                         linetype = "dashed"),
                         panel.grid.minor = element_line(color = "grey80",
                                                         linetype = "dotted"),
                         axis.text.x = element_text(angle = 45,
                                                    hjust = 1,
                                                    vjust = 1,
                                                    size = 14),
                         axis.title = element_text(size = 16))
