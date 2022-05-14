header <- dashboardHeader(title = img(src = "loewe.png",
                                      height = 44))


sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Connect", tabName = "connect", icon = icon("sign-in-alt")),
    uiOutput("select_operation"),
    div(class = "warn-text",
        textOutput("load.error_msg")),
    menuItem("Home", tabName = "home", icon = icon("graduation-cap")),
    menuItem("Pottery", tabName = "pottery_all", icon = icon("trophy"),
             menuSubItem("Pottery (single)", tabName = "pottery", icon = icon("wine-glass-alt")),
             menuSubItem("Pottery Quantification A", tabName = "potteryQA", icon = icon("glass-cheers")),
             menuSubItem("Pottery Quantification B", tabName = "potteryQB", icon = icon("glass-cheers"))
    ),
    menuItem("Loomweights", tabName = "loomweights", icon = icon("weight-hanging"),
             badgeLabel = "WIP", badgeColor = "yellow"),
    #menuItem("Sculpture", tabName = "sculpture", icon = icon("horse-head"),
    #         badgeLabel = "empty", badgeColor = "red"),
    #menuItem("Buildings", tabName = "buildings", icon = icon("landmark"),
    #         badgeLabel = "wip", badgeColor = "yellow"),
    menuItem("Issues / Contact", icon = icon("file-contract"),
             href = "https://github.com/lsteinmann/milQuant")
  )
)

