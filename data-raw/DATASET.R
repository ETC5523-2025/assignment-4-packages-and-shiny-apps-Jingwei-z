library(readr)
library(dplyr)
library(usethis)

ob_timings <- read.csv("data-raw/ob_timings.csv")
ob_timings_summary <- read.csv("data-raw/ob_timings_summary.csv")
ob_probs_travellers <- read.csv("data-raw/ob_probs_travellers.csv")

ob_timings <- ob_timings %>%
  rename(
    breach_times = breach_times,
    R0 = R0,
    VE = VE,
    coverage = coverage
  ) %>%
  mutate(
    data_source = "Zenodo database (DOI: 10.5281/zenodo.5802433)",
    R0 = as.integer(R0),
    VE = as.numeric(VE),
    coverage = as.numeric(coverage),
    breach_times = as.numeric(breach_times)
  )

ob_timings_summary <- ob_timings_summary %>%
  rename(
    t50_days = chance50,
    t95_days = chance95
  ) %>%
  mutate(
    data_source = "Zenodo database (DOI: 10.5281/zenodo.5802433)",
    R0 = as.integer(R0), VE = as.numeric(VE), coverage = as.numeric(coverage))

ob_probs_travellers <- ob_probs_travellers %>%
  mutate(data_source = "Zenodo database (DOI: 10.5281/zenodo.5802433)",
         R0 = as.integer(R0), VE = as.numeric(VE), coverage = as.numeric(coverage))

usethis::use_data(ob_timings, ob_timings_summary, ob_probs_travellers, overwrite = TRUE)


