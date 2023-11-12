## app.R ## Load global parameters and function
source("source/global/load_packages.R")
source("source/global/get_data.R")
source("source/global/global_vars.R")
source("source/global/helpers.R")

# modules
source("source/global_modules/downloadModule.R")
source("source/global_modules/layerSelection.R")
source("source/global_modules/periodSelection.R")
source("source/global_modules/tabInfoBoxes.R")
source("source/global_modules/displayPlotDataTable.R")


# tab modules
source("source/tab_modules/finds_tab_module.R")
source("source/tab_modules/pottery_tab_module.R")

# each tab / ui element group
source("source/tabs/home_tab.R")
source("source/tabs/modals_ui.R")
source("source/tabs/overview_tab.R")
source("source/tabs/workflow_tab.R")
source("source/tabs/potteryQA_tab.R")
source("source/tabs/potteryQB_tab.R")
source("source/tabs/bricks_tab.R")
source("source/tabs/bricksQ_tab.R")
source("source/tabs/loomweights_tab.R")
source("source/tabs/coins_tab.R")

#  header
header <- dashboardHeader(
  title = "milQuant",
  tags$li(class = "dropdown",
          actionButton(label = "Save and Quit",
                       icon = icon("power-off"),
                       inputId = "close_app")))

#  sidebar
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Home", tabName = "home", icon = icon("right-to-bracket")),
    shinyjs::hidden(tags$div(id = "tab_connect.success-div",
                             class = "success-text",
                             textOutput("load.success_msg",
                                        container = tags$p))),
    actionButton("refreshIndex", "Refresh Index", icon = icon("refresh")),
    menuItem("Project overview", tabName = "overview", icon = icon("graduation-cap")),
    uiOutput("selected_operations"),
    uiOutput("selected_trenches"),
    menuItem("Workflow", tabName = "workflow", icon = icon("gear")),
    menuItem("All Finds", tabName = "all_finds", icon = icon("chart-bar")),
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
    menuItem("Coins", tabName = "coins", icon = icon("circle-dollar-to-slot"),
             badgeLabel = "WIP", badgeColor = "red"),
    menuItem("Issues / Contact", icon = icon("file-contract"),
             href = "https://github.com/lsteinmann/milQuant")
  )
)

#  body
body <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "main.css")
  ),
  includeScript('source/global/toggleBtnsOnBusy.js'),
  tabItems(
    home_tab,
    overview_tab,
    workflow_tab,
    all_finds_tab("all_finds"),
    pottery_tab("pottery"),
    potteryQA_tab,
    potteryQB_tab,
    bricks_tab,
    bricksQ_tab,
    loomweights_tab,
    coins_tab
  )
)

ui <- dashboardPage(header, sidebar, body)

server <- function(input, output, session) {
  #session <- getDefaultReactiveDomain()

  # show login dialog box when initiated
  showModal(login_dialog, session = session)
  # server code to handle the connection to field in the modal
  source('source/server/modal_serv.R', local = TRUE)

  # server code to handle basic settings, i.e. project, trench/operation
  # seen on home_tab and sidebar
  source('source/server/settings_serv.R', local = TRUE)
  # server code to import database, places etc.
  source('source/server/database_serv.R', local = TRUE)

  # server code only for overview pages
  source('source/server/overview_serv.R', local = TRUE)
  source('source/server/workflow_serv.R', local = TRUE)



  all_finds_server("all_finds")

  # server code only for pottery form (single)
  pottery_server("pottery")
  # server code only for pottery quantification A form
  source('source/server/potteryQA_serv.R', local = TRUE)
  # server code only for pottery quantification B form
  source('source/server/potteryQB_serv.R', local = TRUE)

  # server code only for bricks
  source('source/server/bricks_serv.R', local = TRUE)
  source('source/server/bricksQ_serv.R', local = TRUE)

  # server code only for loomweights
  source('source/server/loomweights_serv.R', local = TRUE)

  # server code only for coins
  source('source/server/coins_serv.R', local = TRUE)

  # server code for future sculpture tab
  # test commit
  #source('source/server/sculpture_serv.R', local = TRUE)

  # close the R session when Chrome closes
  if (!interactive()) {
    session$onSessionEnded(function() {
      stopApp()
    })
  }

}

shinyApp(ui, server)
