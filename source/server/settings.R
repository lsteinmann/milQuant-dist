




# Produces the List of projects in the database
projects <- reactive({
  projects <- sofa::db_list(idaif_connection())
  return(projects)
})

output$select_project <- renderUI({
  selectInput(inputId = "select_project",
              label = "Choose a Project to work with",
              choices = projects(), multiple = FALSE,
              selected = projects()[2])
})
