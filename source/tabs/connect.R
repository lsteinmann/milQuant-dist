tabItem(
  tabName = "connect",
  title = 'Connect', # name of the tab
  # hide the welcome message at the first place
  shinyjs::hidden(tags$div(
    id = 'tab_login.welcome_div',
    class = 'login-text',
    textOutput('tab_login.welcome_text', container = tags$h2))
  )
)

# define the ui of the login dialog box
# will used later in server part
login_dialog <- modalDialog(
  title = 'Enter Details to Continue',
  footer = actionButton('tab_login.connect','Connect'),
  textInput('tab_login.host','Host (iDAI.field Client)', value = "127.0.0.1"),
  textInput('tab_login.user','Username', value = "milQuant"),
  passwordInput('tab_login.pwd','Password', value = "hallo"),
  tags$div(class = 'warn-text',textOutput('tab_login.connect_msg'))
)
