
# show login dialog box when initiated
showModal(login_dialog)

observeEvent(input$tab_login.connect, {
  host <- input$tab_login.host
  user <- input$tab_login.user
  pwd <- input$tab_login.pwd

  # validate connection
  login_connection <- connect_idaifield(serverip = host,
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
    output$tab_login.welcome_text <- renderText(glue('welcome, {user}'))
    shinyjs::show('tab_login.welcome_div') # show welcome message
  } else if (grepl("401", ping$message)) {
    # password incorrect, show the warning message
    # warning message disappear in 1 sec
    output$tab_login.connect_msg <- renderText('Incorrect Password')
    shinyjs::show('tab_login.connect_msg')
    shinyjs::delay(1000, hide('tab_login.connect_msg'))
  } else if (grepl("Timeout", ping$message)) {
    # Server cannot be reached
    output$tab_login.connect_msg <- renderText('Host cannot be reached.')
    shinyjs::show('tab_login.connect_msg')
    #hinyjs::delay(1000, hide('tab_login.connect_msg'))
  } else if (grepl("resolve", ping$message)) {
    # Server cannot be reached
    output$tab_login.connect_msg <- renderText('Host cannot be resolved.')
    shinyjs::show('tab_login.connect_msg')
    shinyjs::delay(1000, hide('tab_login.connect_msg'))
  } else {
    # I have no idea what happened if this happens, but
    # it can't be right
    output$tab_login.connect_msg <- renderText('Unforeseen Error')
    shinyjs::show('tab_login.connect_msg')
    shinyjs::delay(1000, hide('tab_login.connect_msg'))
  }

})
