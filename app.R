#setwd("..")
#getwd()
## app.R ## Load gloabal parameters and function
source("source/load_packages.R")
source("source/get_data.R")
source("source/global_vars.R")
source("source/helpers.R")
#source("source/global.R")



app.title <- 'milQuant - Quantitative Data from iDAI.field'




header <- dashboardHeader(title = img(src = "loewe.png",
                                      height = 44))


sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Connect", tabName = "connect", icon = icon("login")),
    menuItem("Home", tabName = "home", icon = icon("graduation-cap")),
    menuItem("Pottery", tabName = "pottery_all", icon = icon("trophy"),
             menuSubItem("Pottery (single)", tabName = "pottery", icon = icon("wine-glass-alt")),
             menuSubItem("Pottery Quantification A", tabName = "potteryQA", icon = icon("glass-cheers")),
             menuSubItem("Pottery Quantification B", tabName = "potteryQB", icon = icon("glass-cheers"))
    ),
    menuItem("Sculpture", tabName = "sculpture", icon = icon("horse-head"),
             badgeLabel = "empty", badgeColor = "red"),
    menuItem("Buildings", tabName = "buildings", icon = icon("landmark"),
             badgeLabel = "wip", badgeColor = "yellow"),
    menuItem("Issues / Contact", icon = icon("fa-solid fa-file-signature"),
             href = "https://github.com/lsteinmann/milQuant")
  )
)

source("source/body.R")

ui <- dashboardPage(header, sidebar, body)

server <- function(input, output, session) {

  idaif_connection <- reactive({
    connection <- connect_idaifield(serverip = input$tab_login.host,
                                    user = input$tab_login.user,
                                    pwd = input$tab_login.pwd)
    idaif_connection <- connection
    return(idaif_connection)
  })

  # server code to handle basic setting, i.e. ip and pwd
  source('source/server/connect_inout.R', local = TRUE)

  # server code to handle basic setting, i.e. ip and pwd
  source('source/server/settings.R', local = TRUE)
  # server code to import database, places etc.
  source('source/server/database.R', local = TRUE)

  # server code only for main page
  source('source/server/overview_inout.R', local = TRUE)

  # server code only for pottery form (single)
  source('source/server/pottery_inout.R', local = TRUE)

  # server code only for pottery quantification A form
  source('source/server/potteryQA_inout.R', local = TRUE)
  # server code only for pottery quantification B form
  source('source/server/potteryQB_inout.R', local = TRUE)
  #source('source/server/sculpture_inout.R', local = TRUE)
  #source('source/server/buildings_inout.R', local = TRUE)

}

shinyApp(ui, server)



