
# show login dialog box when initiated
showModal(login_dialog)

observeEvent(input$tab_connect.connect, {
  host <<- input$tab_connect.host
  user <<- input$tab_connect.user
  pwd <<- input$tab_connect.pwd

  # validate connection
  login_connection <<- connect_idaifield(serverip = host,
                                        user = user,
                                        pwd = pwd)



  # get error message
  ping <- tryCatch({
    ping <- sofa::ping(login_connection)
    ping <- append(ping, list(message = "success"))
  },
  error = function(cond) {
    cond$`express-pouchdb` <- FALSE
    return(cond)
  })


  if (ping$message == "success" & ping$`express-pouchdb` == "Welcome!") {
    # succesfully connected
    removeModal() # remove login dialog
    output$tab_connect.welcome_text <- renderText(glue('welcome, {user}'))
    shinyjs::show('tab_connect.welcome_div') # show welcome message
  } else if (grepl("401", ping$message)) {
    # password incorrect, show the warning message
    # warning message disappear in 1 sec
    output$tab_connect.error_msg <- renderText('Incorrect Password')
    shinyjs::show('tab_connect.error_msg')
    shinyjs::delay(1000, hide('tab_connect.error_msg'))
  } else if (grepl("Timeout", ping$message)) {
    # Server cannot be reached
    output$tab_connect.error_msg <- renderText('Host cannot be reached.')
    shinyjs::show('tab_connect.error_msg')
    #hinyjs::delay(1000, hide('tab_connect.error_msg'))
  } else if (grepl("resolve", ping$message)) {
    # Server cannot be reached
    output$tab_connect.error_msg <- renderText('Host cannot be resolved.')
    shinyjs::show('tab_connect.error_msg')
    shinyjs::delay(1000, hide('tab_connect.error_msg'))
  } else {
    # I have no idea what happened if this happens, but
    # it can't be right
    output$tab_connect.error_msg <- renderText('Unforeseen Error')
    shinyjs::show('tab_connect.error_msg')
    shinyjs::delay(1000, hide('tab_connect.error_msg'))
  }
})

observeEvent(input$tab_connect.connect, {
  req(login_connection)
  # Produces the List of projects in the database
  prj_tmp <- sofa::db_list(login_connection)
  projects <<- prj_tmp[!grepl(pattern = "replicator", x = prj_tmp)]
})

observeEvent(input$tab_connect.connect, {
  req(projects)
  output$select_project <- renderUI({
    selectizeInput(inputId = "select_project",
                   label = "Choose a Project to work with",
                   choices = projects, multiple = FALSE,
                   options = list(
                     placeholder = 'Please select an option below',
                     onInitialize = I('function() { this.setValue(""); }')
                   ))
  })
})

