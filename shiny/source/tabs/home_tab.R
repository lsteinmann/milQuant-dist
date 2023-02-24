home_tab <- tabItem(
  tabName = "home",
  title = "Home", # name of the tab
  # hide the welcome message at the first place
  fluidRow(
    box(width = 10,
        div(img(src="milQuant-logo.png", height=100, align="center"))),
    infoBox(width = 2, title = "Version", subtitle = "date: 20.02.2023",
            icon = icon("code-branch"), value = "v.1.0.1", color = "black",
            href = "https://github.com/lsteinmann/milQuant")
  ),
  fluidRow(
    box(width = 12,
        div(
          shinyjs::hidden(tags$div(id = "tab_connect.welcome_div",
                                   class = "login-text",
                                   textOutput("tab_connect.welcome_text",
                                              container = tags$h1))))),
  ),
  fluidRow(
    box(width = 6, height = "200px", title = "Select a project to work with",
        div(class = "welcome-row-div",
            uiOutput("select_project"),
            actionButton(inputId = "loadDatabase",
                         label = "Load Database"))),
    box(p("With this App, you can view and download various plots of data from
      an iDAI.field/Field Desktop-Database. In order for the App to work,
      you need to have iDAI.field 2 or Field Desktop running on your computer.
      Choose a project from your Field Client from the selection to the left."),
        p("The app is meant to be used with the milet-configuration and most
            plots will only work with this configuration.")),
    box(title = "Please note", status = "warning",
        p("Large projects may take a while to load. Be prepared to wait
            after clicking 'Load Database'."))
  ),
  fluidRow(
    box(width = 12, title = "Before you get started...",
        p("In the side bar to the left, you see a dropdown. You need to select
          a Place or Operation to start with from that dropdown. This means
          you need to tell milQuant what excavation area you are interested in,
          for example in \"Insula UV/8-9\" on Humeitepe. This reflects the
          \"Place\" and \"Survey\"-resources from Field Desktop."),
        p("After you leave this selection, a second dropdown will appear. This
          time, you should select the Trench(es) you want to work with."),
        p("Though sometimes cumbersome, this selection process helps speed
          up the app a great deal. When you are all done, you can start
          browsing the different tabs.")
    )
  )
)
