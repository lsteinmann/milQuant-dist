

sculpture_tab <- tabItem(
  tabName = "sculpture",
  h2("Sculpture"),
  fluidRow(
    infoBox(title = "titel", value = textOutput("sculpture_overview"),
            icon = icon("list-alt"),
            color = "orange", width = 12),
  ),
  fluidRow(
    box(
      width = 3, height = 500,
      #downloadButton("potPlot_1_png", label = "Download plot (png)"),
      #downloadButton("potPlot_1_pdf", label = "Download plot (pdf)")
    ),
    box(
      width = 9, height = 500,
      #plotOutput("potPlot_1")
    )
  )
)

