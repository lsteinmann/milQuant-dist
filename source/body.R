

body <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "main.css")
  ),
  tabItems(
    connect_tab
    # First tab content
    #home_tab,
    # Pottery tabs content
    #pottery_tab,
    #potteryQA_tab,
    #potteryQB_tab,



    # Sculpture tab content
    #sculpture_tab,

    # Buildings tab
    #buildings_tab
  )
)
