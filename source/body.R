

body <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "main.css")
  ),
  tabItems(
    connect_tab,
    # home and find overview content
    home_tab,
    allfinds_tab,
    # Pottery tabs content
    pottery_tab,
    potteryQA_tab,
    potteryQB_tab,

    #bricks
    bricks_tab,
    bricksQ_tab,

    # loomweights
    loomweight_tab



    # Sculpture tab content
    #sculpture_tab,

    # Buildings tab
    #buildings_tab
  )
)
