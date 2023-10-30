downloadPlotButtons <- function(id) {

  ns <- NS(id)

  div(
    downloadButton(ns("dPNG"), "Download plot (PNG)"),
    downloadButton(ns("dPDF"), "Download plot (PDF)")
  )
}

downloadPlotHandler <- function(input, output, session, dlPlot) {

  output$dPNG <- downloadHandler(
    filename = paste(format(Sys.Date(), "%Y%m%d"),
                     "_milQuant_plot.png", sep = ""),
    content <- function(file) {
      ggsave(file, plot = dlPlot() + Plot_Base_Theme + Plot_Base_Guide,
             device = "png",
             width = 25, height = 15, units = "cm")
    }
  )

  output$dPDF <- downloadHandler(
    filename = paste(format(Sys.Date(), "%Y%m%d"),
                     "_milQuant_plot.pdf", sep = ""),
    content <- function(file) {
      ggsave(file, plot = dlPlot() + Plot_Base_Theme + Plot_Base_Guide,
             device = "pdf",
             width = 25, height = 15, units = "cm")
    }
  )

}
