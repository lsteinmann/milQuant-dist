home_tab <- tabItem(
  tabName = "home",
  title = "Home", # name of the tab
  # hide the welcome message at the first place
  fluidPage(
    fluidRow(
      box(width = 9,
          div(
            shinyjs::hidden(tags$div(id = "tab_connect.welcome_div",
                                     class = "login-text",
                                     textOutput("tab_connect.welcome_text",
                                                container = tags$h1))))),
      infoBox(width = 3, title = "Version", subtitle = "date: 20.02.2023",
              icon = icon("code-branch"), value = "v.0.2.3", color = "olive")
    ),
    fluidRow(
      box(width = 6,
          p("With this App, you can view and download various plots of data from
      an iDAI.field/Field Desktop-Database. In order for the App to work,
      you need to have iDAI.field 2 or Field Desktop running on your computer.
      Choose a project from your Field Client from the selection below."),
          p("The app is meant to be used with the milet-configuration and most
            plots will only work with this configuration.")),
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
