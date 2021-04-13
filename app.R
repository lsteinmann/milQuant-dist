## app.R ##
library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(forcats)

source("source/get_data.R")
source("source/vars_funs.R")

header <- dashboardHeader(title = img(src = "Logo.png",
                                      height = 44,
                                      width = 45))

sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("Home", tabName = "home", icon = icon("graduation-cap"),
                 badgeLabel = "new", badgeColor = "green"),
        menuItem("Pottery", tabName = "pottery", icon = icon("mug-hot"),
                 badgeLabel = "new", badgeColor = "green"),
        menuItem("Sculpture", tabName = "sculpture", icon = icon("horse-head"),
                 badgeLabel = "new", badgeColor = "green"),
        menuItem("Source code", icon = icon("file-code-o"),
                 href = "https://github.com/lsteinmann/milQuant")
    )
)

source("source/body.R")

ui <- dashboardPage(header, sidebar, body)

server <- function(input, output) {
    overview_data <- table(uidlist$type, uidlist$isRecordedIn) %>%
        as.data.frame() %>%
        mutate(Var1 = fct_reorder(Var1, -Freq))

    output$overview <- renderPlot({
        ggplot(data = overview_data, aes(x = Var1, fill = Var2, y = Freq)) +
            geom_bar(stat = "identity") +
            scale_fill_manual(name = "Maßnahmen",
                              values = uhhcol(length(unique(overview_data$Var2)))) +
            labs(x = "Resources in iDAI.field 2", y = "Count") +
            Plot_Base_Theme
    }, height = 500)
}

shinyApp(ui, server)
