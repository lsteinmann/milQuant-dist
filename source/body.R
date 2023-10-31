

body <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "main.css")
  ),
  tabItems(
    # home and overview
    home_tab,
    overview_tab,
    workflow_tab,

    # all finds content
    allfinds_tab,

    # Pottery tabs content
    pottery_tab,
    potteryQA_tab,
    potteryQB_tab,

    # bricks
    bricks_tab,
    bricksQ_tab,

    # loomweights
    loomweights_tab,

    # coins
    coins_tab

    #tabItem("readme", includeHTML("README.html"))

  )
)
