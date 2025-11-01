#' Outbreak Timing from Simulations
#'
#' Raw simulation results containing breach times for each parameter combination.
#' Each row represents one simulated breach event from computational models 
#' of COVID-19 quarantine systems.
#'
#' @format A data frame with 4 columns:
#' \describe{
#'   \item{R0}{Basic reproductive number (5-10)}
#'   \item{VE}{Vaccine efficacy (0.5-0.9)}
#'   \item{coverage}{Population vaccination coverage (0-1)}
#'   \item{breach_times}{Time to outbreak from simulations (days)}
#' }
#'
#' @source Zenodo database
#' DOI: \url{https://doi.org/10.5281/zenodo.5802433}
#' 
#' @references
#' Zachreson, C., Shearer, F. M., Price, D. J., Lydeamore, M. J., McVernon, J., 
#' McCaw, J., & Geard, N. (2022). COVID-19 in low-tolerance border quarantine 
#' systems: Impact of the Delta variant of SARS-CoV-2. 
#' Science Advances, 8(14), eabm3624.
#'
"ob_timings"

#' Outbreak Timing Summary Statistics
#'
#' Summary statistics distilled from the raw simulation data. For each parameter 
#' combination (R0, VE, coverage), provides the 50th and 95th percentiles of 
#' outbreak timing distributions.
#'
#' @format A data frame with 5 columns:
#' \describe{
#'   \item{R0}{Basic reproductive number (5-10)}
#'   \item{VE}{Vaccine efficacy (0.5-0.9)}
#'   \item{coverage}{Population vaccination coverage (0-1)}
#'   \item{t50_days}{50th percentile (median) of outbreak timing (days)}
#'   \item{t95_days}{95th percentile of outbreak timing (days)}
#' }
#'
#' @details
#' The t50_days value represents the median time until outbreak under given 
#' conditions. The t95_days value captures the upper bound of the typical range.
#' Together, they describe the distribution of outbreak timing outcomes.
#'
#' @source Zenodo database
#' DOI: \url{https://doi.org/10.5281/zenodo.5802433}
#'
#' @references
#' Zachreson, C., Shearer, F. M., Price, D. J., Lydeamore, M. J., McVernon, J., 
#' McCaw, J., & Geard, N. (2022). COVID-19 in low-tolerance border quarantine 
#' systems: Impact of the Delta variant of SARS-CoV-2. 
#' Science Advances, 8(14), eabm3624.
#'
"ob_timings_summary"

#' Outbreak Probability by Breach Source
#'
#' Probability that an infected individual successfully breaches quarantine 
#' and initiates community transmission, reported separately for travellers 
#' and quarantine workers.
#'
#' @format A data frame with 5 columns:
#' \describe{
#'   \item{R0}{Basic reproductive number (5-10)}
#'   \item{VE}{Vaccine efficacy (0.5-0.9)}
#'   \item{coverage}{Population vaccination coverage (0-1)}
#'   \item{traveller_ob_prob}{Probability of traveller-initiated breach}
#'   \item{worker_ob_prob}{Probability of worker-initiated breach}
#' }
#'
#' @details
#' Travellers undergo testing on specific days and may exit with false-negative 
#' results. Workers attend intermittently and face regular testing on attendance 
#' days, creating different breach risk profiles. Worker-initiated breaches 
#' typically show higher probability than traveller-initiated breaches.
#'
#' @source Zenodo database
#' DOI: \url{https://doi.org/10.5281/zenodo.5802433}
#'
#' @references
#' Zachreson, C., Shearer, F. M., Price, D. J., Lydeamore, M. J., McVernon, J., 
#' McCaw, J., & Geard, N. (2022). COVID-19 in low-tolerance border quarantine 
#' systems: Impact of the Delta variant of SARS-CoV-2. 
#' Science Advances, 8(14), eabm3624.
#'
"ob_probs_travellers"