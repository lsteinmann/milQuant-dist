

observeEvent(input$tab_connect.connect, {
  host <- input$tab_connect.host
  user <- input$tab_connect.user
  pwd <- input$tab_connect.pwd

  # manually validate connection
  test_connection <- connect_idaifield(serverip = host,
                                       user = user,
                                       pwd = pwd)

  ping <- try(sofa::ping(test_connection), silent = TRUE)

  if (any(grepl("Welcome!", ping))) {
    # succesfully connect:
    login_connection <<- test_connection
    removeModal() # remove login dialog
    output$tab_connect.welcome_text <- renderText(glue("Welcome to milQuant - Quantitative Analysis
                                                       with Data from Field, {user}!"))
    shinyjs::show("tab_connect.welcome_div") # show welcome message
  } else if (inherits(ping, "try-error")) {
    # display the message
    output$tab_connect.error_msg <- renderText(ping[1])
    shinyjs::show("tab_connect.error_msg")
  } else {
    # I have no idea what happened if this happens, but
    # it can't be right
    output$tab_connect.error_msg <- renderText("Unforeseen Error")
    shinyjs::show("tab_connect.error_msg")
  }
})

observeEvent(input$tab_connect.connect, {
  validate(
    need(exists("login_connection"), "No Connection set.")
  )
  # Produces the List of projects in the database
  prj_tmp <- sofa::db_list(login_connection)
  projects <<- prj_tmp[!grepl(pattern = "replicator", x = prj_tmp)]
})

