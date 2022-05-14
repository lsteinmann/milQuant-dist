

observeEvent(input$tab_connect.connect, {
  host <<- input$tab_connect.host
  user <<- input$tab_connect.user
  pwd <<- input$tab_connect.pwd

  # validate connection
  login_connection <<- connect_idaifield(serverip = host,
                                        user = user,
                                        pwd = pwd)



  ping <- try(sofa::ping(login_connection), silent = TRUE)



  if (is.list(ping) & ping$`express-pouchdb` == "Welcome!") {
    # succesfully connected
    removeModal() # remove login dialog
    output$tab_connect.welcome_text <- renderText(glue('welcome, {user}'))
    shinyjs::show('tab_connect.welcome_div') # show welcome message
  } else if (class(ping) == "try-error") {
    # display the message
    output$tab_connect.error_msg <- renderText(ping[1])
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
  validate(
    need(login_connection, "No Connection set.")
  )
  # Produces the List of projects in the database
  prj_tmp <- sofa::db_list(login_connection)
  projects <<- prj_tmp[!grepl(pattern = "replicator", x = prj_tmp)]
})

observeEvent(input$tab_connect.connect, {
  validate(
    need(projects, "Project list not available.")
  )
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
