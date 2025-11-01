#' Run COVID-19 Quarantine Shiny App
#'
#' Launches an interactive Shiny application for exploring COVID-19 
#' quarantine outbreak probability under different vaccination scenarios.
#'
#' @return Launches the Shiny application
#' @export
#' @examples
#' \dontrun{
#'   run_app()
#' }
run_app <- function() {
  shiny::runApp(system.file("shiny", package = "covidanalysis"))
}