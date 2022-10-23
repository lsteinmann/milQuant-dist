

sculpture_tab <- tabItem(
  tabName = "sculpture",
  h2("Sculpture"),
  fluidRow(
    infoBox(title = "Info", value = textOutput("sculpture_overview"),
            icon = icon("list"),
            color = "olive", width = 12),
  ),
  fluidRow(
    box(
      width = 3, height = 600,
      #downloadButton("potPlot_1_png", label = "Download plot (png)"),
      #downloadButton("potPlot_1_pdf", label = "Download plot (pdf)")
    ),
    box(
      width = 9, height = 600,
      #plotOutput("potPlot_1", height = 570)%>% mq_spinner()
    )
  )
)

