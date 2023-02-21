## app.R ## Load global parameters and function
source("source/global/load_packages.R")
source("source/global/get_data.R")
source("source/global/global_vars.R")
source("source/global/helpers.R")


# sidebar and header
source("source/header_sidebar.R")

# each tab / ui element group
source("source/tabs/home_tab.R")
source("source/tabs/modals_ui.R")
source("source/tabs/overview_tab.R")
source("source/tabs/allfinds_tab.R")
source("source/tabs/pottery_tab.R")
source("source/tabs/potteryQA_tab.R")
source("source/tabs/potteryQB_tab.R")
source("source/tabs/bricks_tab.R")
source("source/tabs/bricksQ_tab.R")
source("source/tabs/loomweight_tab.R")
source("source/tabs/allfinds_tab.R")
# todo
#source("source/tabs/sculpture_tab.R")

# body
source("source/body.R")

ui <- dashboardPage(header, sidebar, body)

server <- function(input, output, session) {

  # show login dialog box when initiated
  showModal(login_dialog, session = getDefaultReactiveDomain())
  # server code to handle the connection to field in the modal
  source('source/server/modal_serv.R', local = TRUE)

  # server code to handle basic settings, i.e. project, trench/operation
  # seen on home_tab and sidebar
  source('source/server/settings_serv.R', local = TRUE)
  # server code to import database, places etc.
  source('source/server/database_serv.R', local = TRUE)

  # server code only for overview pages
  source('source/server/overview_serv.R', local = TRUE)
  source('source/server/allfinds_serv.R', local = TRUE)

  # server code only for pottery form (single)
  source('source/server/pottery_serv.R', local = TRUE)
  # server code only for pottery quantification A form
  source('source/server/potteryQA_serv.R', local = TRUE)
  # server code only for pottery quantification B form
  source('source/server/potteryQB_serv.R', local = TRUE)

  # server code only for bricks
  source('source/server/bricks_serv.R', local = TRUE)
  source('source/server/bricksQ_serv.R', local = TRUE)

  # server code only for loomweights
  source('source/server/loomweight_serv.R', local = TRUE)

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
