default.username <- source("defaults/settings.R")$value$username
updateTextInput(session, "tab_connect.user", value = default.username)

default.password <- source("defaults/settings.R")$value$synchpw
updateTextInput(session, "tab_connect.pwd", value = default.password)

login_connection <- reactiveVal(NA)

observeEvent(input$tab_connect.connect, {
  host <- input$tab_connect.host
  user <- input$tab_connect.user
  pwd <- input$tab_connect.pwd

  # manually validate connection
  test_connection <- connect_idaifield(serverip = host,
                                       user = user,
                                       pwd = pwd)

  ping <- tryCatch({
    idf_ping(test_connection)
  }, warning = function(w) {
    conditionMessage(w)
  }, error = function(e) {
    conditionMessage(e)
  })

  if (ping == TRUE) {
    # succesfully connect:
    login_connection(test_connection)
    removeModal() # remove login dialog
    output$tab_connect.welcome_text <- renderText(glue("Welcome to milQuant - Quantitative Analysis
                                                       with Data from Field, {user}!"))
    shinyjs::show("tab_connect.welcome_div") # show welcome message
  } else if (ping == FALSE) {
    # I have no idea what happened if this happens, but
    # it can't be right
    output$tab_connect.error_msg <- renderText(paste("Unforeseen Error:", ping))
    shinyjs::show("tab_connect.error_msg")
  } else {
    # display the message
    output$tab_connect.error_msg <- renderText(ping)
    shinyjs::show("tab_connect.error_msg")
  }
})

observeEvent(input$tab_connect.connect, {
  validate(
    need(exists("login_connection"), "No Connection set.")
  )
  # Produces the List of projects in the database
  projects <<- idf_projects(login_connection())
})

