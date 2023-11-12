pottery_tab <- function(id) {

  ns <- NS(id)

  tabItem(
    tabName = "pottery",

    h1("Overview of 'Pottery'-resources"),

    tabInfoRow_ui(ns("info")),

    fluidRow(
      box(
        width = 3, height = 650,
        textInput(inputId = ns("title"), label = "Title",
                  placeholder = "Enter title here"),
        textInput(inputId = ns("subtitle"), label = "Subtitle",
                  placeholder = "Enter subtitle here"),
        uiLayerSelector(ns("layers")),
        htmlOutput(ns("x_selector")),
        htmlOutput(ns("fill_selector")),
        prettyRadioButtons(inputId = ns("bar_display"),
                           label = "Choose how to display the bars",
                           icon = icon("check"),
                           inline = TRUE, animation = "jelly",
                           choices = list("stacked" = "stack",
                                          "dodging" = "group",
                                          "percentage" = "percentage")),
        uiPeriodSelector(ns("periods")),
        #downloadPlotButtons("download")
      ),
      box(
        width = 9, height = 700,
        plotlyOutput(ns("display_plot"), height = 620) %>% mq_spinner()
      )
    )
  )


}

pottery_server <- function(id) {

  moduleServer(
    id,
    function(input, output, session) {

      ns <- NS(id)

      pottery <- reactive({

        validate(
          need(is.data.frame(selected_db()), "No Trenches and/or Places selected.")
        )

        pottery <- selected_db() %>%
          filter(category == "Pottery") %>%
          remove_na_cols() %>%
          inner_join(react_index()[,c("identifier", "Operation", "Place")],
                     by = "identifier")


        return(pottery)
      })



      pottery_vars <- reactive({
        pottery_vars <- colnames(pottery())
        pottery_vars <- pottery_vars[!pottery_vars %in% drop_for_plot_vars]
        pottery_vars <- pottery_vars[!grepl("dimension", pottery_vars)]
        pottery_vars <- pottery_vars[!grepl("coin", pottery_vars)]
        pottery_vars <- pottery_vars[!grepl("amount.*", pottery_vars)]
      })

      output$x_selector <- renderUI({
        selectInput(inputId = ns("x_var"), label = "Choose a variable for the x-axis:",
                    choices = pottery_vars(), selected = "potteryGroup")
      })

      output$fill_selector <- renderUI({
        selectInput(inputId = ns("fill_var"), label = "Choose a variable for the color:",
                    choices = pottery_vars(), selected = "functionalCategory")
      })

      tabInfoRow_server("info", tab_data = pottery)

      generateLayerSelector("layers", pottery, inputid = ns("selected_layers"))
      generatePeriodSelector("periods", inputid = ns("selected_periods"))

      plot_data <- reactive({
        validate(
          need(is.character(input$x_var), "No variables selected.")
        )

        plot_data <- pottery() %>%
          filter(relation.liesWithinLayer %in% input$selected_layers) %>%
          period_filter(is_milet = is_milet,
                        selector = input$selected_periods) %>%
          mutate(x = get(input$x_var),
                 color = get(input$fill_var)) %>%
          select(x, color) %>%
          droplevels() %>%
          count(x, color) %>%
          group_by(x) %>%
          arrange(n)


        return(plot_data)
      })

      make_plot <- reactive({

        validate(
          need(is.data.frame(plot_data()), "I am not getting the data!")
        )

        fig <- plot_ly(plot_data(), x = ~x, y = ~n, color = ~color,
                       type = "bar", textposition = "none", source = "potPlot_1",
                       colors = viridis(length(unique(plot_data()$color))),
                       hovertemplate = paste0("<b>%{fullData.name}</b><br>",
                                              "%{x}<br>",
                                              "count: <b>%{y}</b><br>",
                                              "<extra></extra>"))

        legend_title <- input$fill_var

        x_title <- input$x_var

        plot_title <- paste0('<b>', input$title, '</b><br>', input$subtitle)

        caption <- paste0("Total: ", sum(plot_data()$n))

        fig <- fig %>% layout(barmode = input$bar_display,
                              title = list(text = plot_title),
                              xaxis = list(title = x_title,
                                           categoryorder = "total descending"),
                              yaxis = list(title = "count"),
                              legend = list(title = list(text = legend_title)))

        milquant_plotly_layout(fig, caption = caption)
      })

      output$display_plot <- renderPlotly({
        make_plot()
      })



      #callModule(downloadPlotHandler, id = "download",
      #           dlPlot = make_plot)


    }
  )

}
