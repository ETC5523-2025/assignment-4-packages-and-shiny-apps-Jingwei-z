
# COVID-19 Border Quarantine Analysis

Interactive R package for exploring COVID-19 quarantine effectiveness.

## Overview

This package provides an interactive Shiny application for exploring
COVID-19 border quarantine effectiveness through the lens of outbreak
timing distributions and breach pathways. The analysis is based on data
from Zenodo (DOI: 10.5281/zenodo.5802433) and research by Zachreson et
al. (2022), which developed computational models of quarantine systems
coupled with community transmission dynamics.

The package allows users to examine how different vaccination scenarios
influence the distribution of times at which major outbreaks might occur
if quarantine breaches happen. A key distinction is made between two
types of breaches: those originating from infected travellers and those
from quarantine workers. Understanding these pathways and their relative
risks under different conditions informs quarantine policy design.

## Installation

You can install the development version of covidanalysis from GitHub
with:

``` r
# install.packages("remotes")
remotes::install_github("ETC5523-2025/assignment-4-packages-and-shiny-apps-Jingwei-z")
```

## Quick Start

``` r
library(covidanalysis)

# Launch the interactive Shiny app
run_app()

# Or explore the data directly
data(ob_timings_summary)
head(ob_timings_summary)
#>   R0  VE coverage t50_days  t95_days
#> 1  5 0.5      0.1 46.27000 198.82600
#> 2  6 0.5      0.1 29.48333 128.46667
#> 3  7 0.5      0.1 25.76167 108.34800
#> 4  8 0.5      0.1 20.28667  87.98933
#> 5  9 0.5      0.1 15.72000  68.72667
#> 6 10 0.5      0.1 15.06333  64.61433
```

## Usage

### Launch the Shiny Application

To launch the interactive application:

``` r
library(covidanalysis)
run_app()
#> 
#> Listening on http://127.0.0.1:4834
```

The application allows you to explore outbreak timing distributions and
breach probabilities across different R₀ values, vaccine efficacy
levels, and population vaccination coverage. You can visualize how the
50th and 95th percentiles of outbreak timing change with vaccination
parameters, and compare the risk profiles of traveller-initiated versus
worker-initiated breaches.

### Access the Data

The package includes three datasets from the Zenodo database:

``` r
library(covidanalysis)
data(ob_timings)
data(ob_timings_summary)
data(ob_probs_travellers)
head(ob_timings)
#>   breach_times R0  VE coverage
#> 1    43.643333  5 0.5      0.1
#> 2    85.240000  5 0.5      0.1
#> 3    32.470000  5 0.5      0.1
#> 4     8.676667  5 0.5      0.1
#> 5    12.136667  5 0.5      0.1
#> 6   113.160000  5 0.5      0.1
head(ob_timings_summary)
#>   R0  VE coverage t50_days  t95_days
#> 1  5 0.5      0.1 46.27000 198.82600
#> 2  6 0.5      0.1 29.48333 128.46667
#> 3  7 0.5      0.1 25.76167 108.34800
#> 4  8 0.5      0.1 20.28667  87.98933
#> 5  9 0.5      0.1 15.72000  68.72667
#> 6 10 0.5      0.1 15.06333  64.61433
head(ob_probs_travellers)
#>   R0  VE coverage traveller_ob_prob worker_ob_prob
#> 1  5 0.5      0.1           0.00903        0.14613
#> 2  6 0.5      0.1           0.01352        0.16433
#> 3  7 0.5      0.1           0.01370        0.17484
#> 4  8 0.5      0.1           0.01881        0.18244
#> 5  9 0.5      0.1           0.02028        0.19702
#> 6 10 0.5      0.1           0.02102        0.20334
```

- `ob_timings`: Raw distribution of breach times from simulation,
  showing variability in outbreak timing
- `ob_timings_summary`: Statistical summaries (50th and 95th
  percentiles) of outbreak timing at each parameter combination
- `ob_probs_travellers`: Outbreak probabilities resulting from traveller
  and worker breach pathways

## Data Source

All data in this package are sourced from the Zenodo database:

Zachreson, C., Shearer, F. M., Price, D. J., Lydeamore, M. J., McVernon,
J., McCaw, J., & Geard, N. (2022). COVID-19 in low-tolerance border
quarantine systems: Impact of the Delta variant of SARS-CoV-2. *Science
Advances*, 8(14), eabm3624.

DOI: [10.1126/sciadv.abm3624](https://doi.org/10.1126/sciadv.abm3624)

Zenodo Database:
[10.5281/zenodo.5802433](https://zenodo.org/records/5802433)

## Key Insights

The outbreak timing distributions reveal substantial variability in when
breaches might result in major outbreaks. The 50th percentile indicates
the median time until outbreak, while the 95th percentile captures the
upper range of this distribution. As vaccination coverage increases and
vaccine efficacy improves, both percentiles extend, indicating prolonged
protection.

The distinction between traveller and worker breach pathways is
significant. Worker-initiated breaches occur less frequently due to
rigorous testing schedules, but when they do occur, they represent a
substantial risk. Traveller breaches depend on successful exit from
quarantine with an undetected infection, which can happen despite
multiple test occasions.

## Documentation

For complete documentation, visit the [package
website](https://ETC5523-2025.github.io/assignment-4-packages-and-shiny-apps-Jingwei-z/).

For detailed analysis and interpretation of results, see the package
vignette:

``` r
vignette("covidanalysis_vignette", package = "covidanalysis")
```

## License

This package is licensed under the MIT License - see the LICENSE file
for details.

## Author

Jingwei Zhao (<jzha0527@student.monash.edu>)
