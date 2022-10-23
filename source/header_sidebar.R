#header <- dashboardHeader(title = "milQuant")
header <- dashboardHeader(title = "milQuant",
           tags$li(class = "dropdown",
                   actionButton(label = "Quit",
                                icon = icon("power-off"),
                                inputId = "close_app")))

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Connect", tabName = "connect", icon = icon("sign-in-alt")),
    uiOutput("select_operation"),
    menuItem("Home (Project)", tabName = "home", icon = icon("graduation-cap")),
    menuItem("Finds (Overview)", tabName = "allfinds", icon = icon("chart-bar"),
             badgeLabel = "NEW", badgeColor = "green"),
    menuItem("Pottery", tabName = "pottery_all", icon = icon("trophy"),
             menuSubItem("Pottery (single)", tabName = "pottery", icon = icon("wine-glass-alt")),
             menuSubItem("Pottery Quantification A", tabName = "potteryQA", icon = icon("glass-cheers")),
             menuSubItem("Pottery Quantification B", tabName = "potteryQB", icon = icon("glass-cheers"))
    ),
    menuItem("Loomweights", tabName = "loomweights", icon = icon("weight-hanging"),
             badgeLabel = "NEW", badgeColor = "green"),
    #menuItem("Sculpture", tabName = "sculpture", icon = icon("horse-head"),
    #         badgeLabel = "empty", badgeColor = "red"),
    #menuItem("Buildings", tabName = "buildings", icon = icon("landmark"),
    #         badgeLabel = "wip", badgeColor = "yellow"),
    menuItem("Issues / Contact", icon = icon("file-contract"),
             href = "https://github.com/lsteinmann/milQuant")
  )
)

