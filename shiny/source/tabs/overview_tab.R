overview_tab <- tabItem(
  tabName = "overview",
  title = "Overview",

  fluidRow(
    infoBox(
      title = "Info",
      value = "This plot gives you an overview of all the resources that
        exist in the Operation and/or Trenches you have selected in the sidebar
        on the left. All other tabs accesible via the bar on the left will only
        display resources from the Operation and/or Trenches you
        have selected.",
      icon = icon("vial"),
      color = "light-blue",
      width = 10),
    valueBox(
      uiOutput("overview_n"),
      "Total Resources",
      icon = icon("file"),
      color = "light-blue",
      width = 2)),
  fluidRow(
    box(title = "Overview", status = "primary",
        solidHeader = TRUE, collapsible = FALSE,
        width = 12, height = 600,
        plotOutput("overview") %>% mq_spinner()))
)