
# define the ui of the login dialog box
login_dialog <- modalDialog(
  title = "Enter connection details to continue",
  footer = actionButton("tab_connect.connect","Connect"),
  textInput("tab_connect.host","Host (Field Desktop)", value = "127.0.0.1"),
  textInput("tab_connect.user","Username", value = "username"),
  passwordInput("tab_connect.pwd","Password", value = "hallo"),
  tags$div(class = "warn-text",textOutput("tab_connect.error_msg"))
)


busy_dialog <- modalDialog(
  title = "Loading Project, please wait...",
  div(class = "warn-text", textOutput("load.error_msg") %>%
        withSpinner(image = "quant-spinner-smooth.gif",
                    image.width = 120,
                    image.height = 120,
                    proxy.height = "100px",
                    color.background = "#ffffff")),
  footer = shinyjs::hidden(actionButton(inputId = "close_busy_dialog", "Close"))
)

