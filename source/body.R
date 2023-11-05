

body <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "main.css")
  ),
  includeScript('source/global/toggleBtnsOnBusy.js'),
  tabItems(
    home_tab,
    # home and find overview content
    overview_tab,
    workflow_tab,
    allfinds_tab,
    # Pottery tabs content
    pottery_tab,
    potteryQA_tab,
    potteryQB_tab,

    #bricks
    bricks_tab,
    bricksQ_tab,

    # loomweights
    loomweights_tab#,
    #tabItem("readme", includeHTML("README.html"))



    # Sculpture tab content
    #sculpture_tab,

    # Buildings tab
    #buildings_tab
  )
)
