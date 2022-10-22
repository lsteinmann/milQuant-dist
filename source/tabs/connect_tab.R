connect_tab <- tabItem(
  tabName = "connect",
  title = "Connect", # name of the tab
  # hide the welcome message at the first place
  fluidPage(
    fluidRow(
      box(width = 9,
          div(
            shinyjs::hidden(tags$div(id = "tab_connect.welcome_div",
                                     class = "login-text",
                                     textOutput("tab_connect.welcome_text",
                                                container = tags$h1))))),
      infoBox(width = 3, title = "Version", subtitle = "date: 22.10.2022",
              icon = icon("code-branch"), value = "v.0.1.1", color = "olive")
    ),
    fluidRow(
      box(width = 6,
          p("With this App, you can view and download various plots of data from
      an iDAI.field-Database, that is otherwise usually inaccessible.
      In order for the App to work, you need to have iDAI.field 2 or
      Field Desktop running on your computer. Choose a project from
      your Field Client from the selection below."),
          p("The App is meant to be used with the milet-configuration and many
            plots may only work for this configuration.")),
      box(title = "Please note", status = "warning",
          p("Large projects may take a while to load. Be prepared to wait
            after clicking 'Load Database'."))
    ),
    fluidRow(
      box(width = 6, height = 200, title = "Select a project to work with",
          div(class = "welcome-row-div",
              uiOutput("select_project"),
              actionButton(inputId = "loadDatabase",
                           label = "Load Database")))
    ),
    fluidRow(
      box(width = 12,
          shinyjs::hidden(tags$div(id = "tab_connect.success-div",
                                   class = "success-text",
                                   textOutput("load.success_msg",
                                              container = tags$h3))))
    )
  )
)

# define the ui of the login dialog box
# will used later in server part
login_dialog <- modalDialog(
  title = "Enter connection details to continue",
  footer = actionButton("tab_connect.connect","Connect"),
  textInput("tab_connect.host","Host (iDAI.field Client)", value = "127.0.0.1"),
  textInput("tab_connect.user","Username", value = "username"),
  passwordInput("tab_connect.pwd","Password", value = "hallo"),
  tags$div(class = "warn-text",textOutput("tab_connect.error_msg"))
)


busy_dialog <- modalDialog(
  title = "Loading Project, please wait...",
  div(class = "warn-text", textOutput("load.error_msg") %>%
        withSpinner(type = 3, proxy.height = "100px",
                    color = "#e2001a", color.background = "#ffffff")),
  footer = shinyjs::hidden(actionButton(inputId = "close_busy_dialog", "Close"))
)

