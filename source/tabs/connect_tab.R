connect_tab <- tabItem(
  tabName = "connect",
  title = "Connect", # name of the tab
  # hide the welcome message at the first place
  fluidPage(
    fluidRow(
      h1("Welcome to milQuant - Quantitative Analysis
                   with Data from iDAI.field"),
      p("With this App, you can view and download various
                   plots of data from an iDAI.field-Database,
                   that is otherwise usually inaccessible.
                   In order for the App to work, you need to have
                   iDAI.field 2 or Field Desktop running on your computer.
                   Below are a few settings that probably need to be adjusted
                   before you can start.")),
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
                 uiOutput("select_project"),
                 actionButton(inputId = "loadDatabase",
                              label = "Load Database"))
      ),
      column(6,
             div(class = "welcome-row-div",
                 p(class = "success-text",
                   textOutput("load.success_msg")))
      )
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
