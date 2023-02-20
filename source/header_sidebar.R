#header <- dashboardHeader(title = "milQuant")
header <- dashboardHeader(title = "milQuant",
           tags$li(class = "dropdown",
                   actionButton(label = "Quit",
                                icon = icon("power-off"),
                                inputId = "close_app")))

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Home", tabName = "home", icon = icon("right-to-bracket")),
    uiOutput("select_operation"),
    uiOutput("select_trench"),
    menuItem("Overview (DB-Project)", tabName = "overview", icon = icon("graduation-cap")),
    menuItem("All Finds", tabName = "allfinds", icon = icon("chart-bar")),
    menuItem("Pottery", tabName = "pottery_all", icon = icon("trophy"),
          menuSubItem("Pottery (single)", tabName = "pottery",
                      icon = icon("martini-glass-empty")),
          menuSubItem("Pottery Quantification A", tabName = "potteryQA",
                      icon = icon("champagne-glasses")),
          menuSubItem("Pottery Quantification B", tabName = "potteryQB",
                      icon = icon("champagne-glasses"))
    ),
    menuItem("Bricks and Tiles", tabName = "bricks_all", icon = icon("square"),
          menuSubItem("Bricks and Tiles", tabName = "bricks",
                      icon = icon("house")),
          menuSubItem("Brick/Tile/Pipe Quantification", tabName = "bricksQ",
                      icon = icon("shapes"))
    ),
    menuItem("Loomweights", tabName = "loomweights", icon = icon("weight-hanging")),
    #menuItem("Sculpture", tabName = "sculpture", icon = icon("horse-head"),
    #         badgeLabel = "empty", badgeColor = "red"),
    #menuItem("Buildings", tabName = "buildings", icon = icon("landmark"),
    #         badgeLabel = "wip", badgeColor = "yellow"),
    menuItem("Issues / Contact", icon = icon("file-contract"),
             href = "https://github.com/lsteinmann/milQuant")
  )
)

