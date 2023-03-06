workflow_tab <- tabItem(
  tabName = "workflow",
  title = "Workflow",

  fluidRow(
    uiOutput("workflow_tabs") %>% mq_spinner()
    )
)
