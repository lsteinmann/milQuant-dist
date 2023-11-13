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
source("source/tab_modules/barplot_module.R")
source("source/tab_modules/loomweights_tab_module.R")

# each tab / ui element group
source("source/tabs/home_tab.R")
source("source/tabs/modals_ui.R")
source("source/tabs/overview_tab.R")
source("source/tabs/workflow_tab.R")
source("source/tabs/potteryQA_tab.R")
source("source/tabs/potteryQB_tab.R")
source("source/tabs/bricksQ_tab.R")

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

    menuItem("Finds", tabName = "all_finds", icon = icon("chart-bar"),
             menuSubItem("Finds (Overview)", tabName = "all_finds", icon = icon("chart-bar")),
             menuSubItem("Lamps", tabName = "lamps_tab", icon = icon("fire-flame-curved")),
             menuSubItem("Metal", tabName = "metal_tab", icon = icon("utensils")),
             menuSubItem("Plaster", tabName = "plaster_tab", icon = icon("paintbrush")),
             menuSubItem("Sculpture", tabName = "sculpture_tab", icon = icon("person-skating")),
             menuSubItem("Stone", tabName = "stone_tab", icon = icon("volcano")),
             menuSubItem("Terracotta", tabName = "terracotta_tab", icon = icon("horse-head"))
    ),

    menuItem("Pottery", tabName = "pottery_all", icon = icon("trophy"),
             menuSubItem("Pottery (single)", tabName = "pottery_tab",
                         icon = icon("martini-glass-empty")),
             menuSubItem("Pottery Quantification A", tabName = "potteryQA",
                         icon = icon("champagne-glasses")),
             menuSubItem("Pottery Quantification B", tabName = "potteryQB",
                         icon = icon("champagne-glasses"))
    ),

    menuItem("Bricks and Tiles", tabName = "bricks_all", icon = icon("square"),
             menuSubItem("Bricks and Tiles", tabName = "bricks_tab",
                         icon = icon("house")),
             menuSubItem("Brick/Tile/Pipe Quantification", tabName = "bricksQ",
                         icon = icon("shapes"))
    ),

    menuItem("Loomweights", tabName = "loomweights_hist", icon = icon("weight-hanging")),

    menuItem("Coins", tabName = "coins_tab", icon = icon("circle-dollar-to-slot"),
             badgeLabel = "WIP", badgeColor = "teal"),

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
    barplot_tab("pottery", tabname = "pottery_tab"),
    potteryQA_tab,
    potteryQB_tab,
    barplot_tab("bricks", tabname = "bricks_tab"),
    bricksQ_tab,
    loomweights_tab("lw_hist"),
    barplot_tab("coins", tabname = "coins_tab"),
    barplot_tab("lamps", tabname = "lamps_tab"),
    barplot_tab("metal", tabname = "metal_tab"),
    barplot_tab("plaster", tabname = "plaster_tab"),
    barplot_tab("sculpture", tabname = "sculpture_tab"),
    barplot_tab("stone", tabname = "stone_tab"),
    barplot_tab("terracotta", tabname = "terracotta_tab")
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

  # server code only for overview pages
  source('source/server/overview_serv.R', local = TRUE)
  source('source/server/workflow_serv.R', local = TRUE)


  # general finds plot
  all_finds_server("all_finds")

  # all other (automated) finds
  barplot_server("lamps", resource_category = "Lamp")
  barplot_server("metal", resource_category = "Metal")
  barplot_server("plaster", resource_category = "PlasterFragment")
  barplot_server("sculpture", resource_category = "Sculpture")
  barplot_server("stone", resource_category = "Stone")
  barplot_server("terracotta", resource_category = "Terracotta")

  # server code for pottery form (single)
  barplot_server("pottery", resource_category = "Pottery")
  # server code for pottery quantification A form
  source('source/server/potteryQA_serv.R', local = TRUE)
  # server code for pottery quantification B form
  source('source/server/potteryQB_serv.R', local = TRUE)

  # server code for bricks
  barplot_server("bricks", resource_category = "Brick")
  source('source/server/bricksQ_serv.R', local = TRUE)

  # server code for loomweights
  loomweights_server("lw_hist")

  # server code for coins
  barplot_server("coins", resource_category = "Coin")



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
