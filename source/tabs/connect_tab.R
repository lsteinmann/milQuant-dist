connect_tab <- tabItem(
  tabName = "connect",
  title = "Connect", # name of the tab
  # hide the welcome message at the first place
  fluidPage(
    fluidRow(
      column(12,
             div(class = "welcome-row-div",
                 shinyjs::hidden(tags$div(
                   id = "tab_connect.welcome_div",
                   class = "login-text",
                   textOutput("tab_connect.welcome_text", container = tags$h2)))
             ))
    ),
    fluidRow(
      column(6,
             div(class = "welcome-row-div",
                 uiOutput("select_project"))
             ),
      column(6, div(class = "welcome-row-div",
                    ))
    )
  )

)

# define the ui of the login dialog box
# will used later in server part
login_dialog <- modalDialog(
  title = "Enter Details to Continue",
  footer = actionButton("tab_connect.connect","Connect"),
  textInput("tab_connect.host","Host (iDAI.field Client)", value = "127.0.0.1"),
  textInput("tab_connect.user","Username", value = "milQuant"),
  passwordInput("tab_connect.pwd","Password", value = "hallo"),
  tags$div(class = "warn-text",textOutput("tab_connect.error_msg"))
)
