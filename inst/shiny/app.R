library(shiny)
library(ggplot2)
library(dplyr)
library(covidanalysis)
library(tidyr)

data(ob_timings)
data(ob_timings_summary)
data(ob_probs_travellers)

ui <- fluidPage(
  titlePanel("COVID-19 Border Quarantine Analysis"),
  
  sidebarLayout(
    sidebarPanel(
      h4("Explore the Data"),
      
      sliderInput(
        "r0",
        "Basic Reproductive Number (R₀):",
        min = 5,
        max = 10,
        value = 6,
        step = 1
      ),
      
      sliderInput(
        "ve",
        "Vaccine Efficacy (VE):",
        min = 0.5,
        max = 0.9,
        value = 0.7,
        step = 0.1
      ),
      
      # Coverage slider shown conditionally
      uiOutput("coverage_slider"),
      
      hr(),
      textOutput("summary"),
      
      hr(),
      h5("Legend"),
      p("Solid line: Median outbreak time (t50)", style = "color: #1B9E77;"),
      p("Dashed line: 95th percentile (t95)", style = "color: #D95F02;")
    ),
    
    mainPanel(
      tabsetPanel(
        id = "tabs",
        
        tabPanel(
          "Outbreak Timing",
          value = "timing",
          br(),
          plotOutput("timing_plot", height = "500px"),
          p("This line plot shows how outbreak timing (t50 and t95) varies with vaccination coverage at your selected R₀ and VE levels.",
            style = "color: #666; font-size: 12px; margin-top: 20px;")
        ),
        
        tabPanel(
          "Breach Probabilities",
          value = "probabilities",
          br(),
          plotOutput("breach_plot", height = "500px"),
          p("This boxplot compares traveller vs worker breach probabilities across all coverage levels at your selected R₀ and VE.",
            style = "color: #666; font-size: 12px; margin-top: 20px;")
        ),
        
        tabPanel(
          "Breach Time Distribution",
          value = "distribution",
          br(),
          plotOutput("distribution_plot", height = "500px"),
          p("This histogram shows the distribution of breach times from all simulations at your selected parameters. The red dashed line marks the median (t50), and the dotted line represents the 95th percentile (t95).",
            style = "color: #666; font-size: 12px; margin-top: 20px;")
        ),
        
        tabPanel(
          "Data Table",
          value = "table",
          br(),
          h4("Outbreak Timing Summary"),
          tableOutput("timing_table"),
          br(),
          h4("Breach Probabilities"),
          tableOutput("breach_table")
        ),
        
        tabPanel(
          "About",
          value = "about",
          br(),
          h4("About This App"),
          p("This application explores COVID-19 quarantine effectiveness based on ",
            strong("Zachreson et al. (2022)"),
            ", which developed computational models of border quarantine systems under different vaccination scenarios."),
          
          h4("Key Metrics Explained"),
          tags$ul(
            tags$li(strong("R₀:"), " Basic reproductive number - how many people one infected person infects (5-10 range)"),
            tags$li(strong("VE:"), " Vaccine efficacy - effectiveness at preventing infection (50-90% range)"),
            tags$li(strong("Coverage:"), " Proportion of population vaccinated (10-100%)"),
            tags$li(strong("t50:"), " Days until 50% probability of outbreak (≥5 cases) if breach occurs"),
            tags$li(strong("t95:"), " Days until 95% probability of outbreak - upper range of timing")
          ),
          
          h4("How to Interpret"),
          tags$ul(
            tags$li("Higher VE and coverage → longer time before outbreak"),
            tags$li("Worker breaches are riskier than traveller breaches"),
            tags$li("The gap between t50 and t95 shows distribution variability")
          ),
          
          h4("Reference"),
          p("Zachreson, C., Shearer, F. M., Price, D. J., Lydeamore, M. J., McVernon, J., ",
            "McCaw, J., & Geard, N. (2022). COVID-19 in low-tolerance border quarantine systems: ",
            "Impact of the Delta variant of SARS-CoV-2. ",
            em("Science Advances"),
            ", 8(14), eabm3624.")
        )
      )
    )
  )
)

# Define server
server <- function(input, output) {
  
  # Conditionally show coverage slider only for specific tabs
  output$coverage_slider <- renderUI({
    if (!is.null(input$tabs) && input$tabs %in% c("probabilities", "distribution")) {
      sliderInput(
        "coverage",
        "Population Vaccination Coverage:",
        min = 0.1,
        max = 1.0,
        value = 0.5,
        step = 0.1
      )
    }
  })
  
  output$summary <- renderText({
    paste0(
      "Selected Parameters:\n\n",
      "R₀ = ", input$r0, "\n",
      "VE = ", input$ve * 100, "%",
      if(!is.null(input$coverage)) paste0("\nCoverage = ", input$coverage * 100, "%") else ""
    )
  })
  
  # Line plot - Outbreak timing across coverage for selected R0 and VE
  output$timing_plot <- renderPlot({
    data_plot <- ob_timings_summary %>%
      filter(R0 == input$r0, VE == input$ve) %>%
      filter(t50_days > 0, t95_days > 0)  # 过滤非正数
    
    if (nrow(data_plot) == 0) {
      plot.new()
      text(0.5, 0.5, "No data available for selected parameters", cex = 1.5)
    } else {
      ggplot(data_plot, aes(x = coverage)) +
        geom_line(aes(y = t50_days), size = 1, linetype = "solid", color = "#1B9E77") +
        geom_line(aes(y = t95_days), size = 1, linetype = "dashed", color = "#D95F02") +
        geom_point(aes(y = t50_days), size = 3, color = "#1B9E77") +
        geom_point(aes(y = t95_days), size = 3, color = "#D95F02") +
        scale_y_log10(breaks = c(10, 100, 1000, 10000)) +
        scale_x_continuous(labels = function(x) paste0(x * 100, "%")) +
        labs(
          title = paste0("Outbreak Timing Distribution (R₀ = ", input$r0, ", VE = ", input$ve * 100, "%)"),
          x = "Population Vaccination Coverage",
          y = "Days (log scale)"
        ) +
        theme_minimal() +
        theme(
          plot.title = element_text(size = 14, face = "bold"),
          axis.title = element_text(size = 12),
          panel.grid.major = element_line(color = "grey90"),
          panel.grid.minor = element_blank()
        )
    }
  })
  
  # Boxplot - Breach probabilities for selected parameters
  output$breach_plot <- renderPlot({
    req(input$coverage)
    
    data_breach <- ob_probs_travellers %>%
      filter(R0 == input$r0, VE == input$ve) %>%
      select(coverage, traveller_ob_prob, worker_ob_prob) %>%
      pivot_longer(
        cols = c(traveller_ob_prob, worker_ob_prob),
        names_to = "breach_type",
        values_to = "probability"
      ) %>%
      mutate(
        breach_category = ifelse(grepl("traveller", breach_type), "Traveller", "Worker"),
        breach_type = case_when(
          breach_type == "traveller_ob_prob" ~ "Traveller Breach",
          breach_type == "worker_ob_prob" ~ "Worker Breach"
        )
      )
    
    if (nrow(data_breach) == 0) {
      plot.new()
      text(0.5, 0.5, "No data available for selected parameters", cex = 1.5)
    } else {
      ggplot(data_breach, aes(x = breach_type, y = probability, fill = breach_category)) +
        geom_boxplot(alpha = 0.7) +
        geom_jitter(width = 0.2, alpha = 0.5, size = 2) +
        scale_fill_manual(values = c("Traveller" = "#1B9E77", "Worker" = "#D95F02")) +
        labs(
          title = paste0("Breach Probabilities (R₀ = ", input$r0, ", VE = ", input$ve * 100, "%)"),
          x = "Breach Type",
          y = "Outbreak Probability"
        ) +
        theme_minimal() +
        theme(
          plot.title = element_text(size = 14, face = "bold"),
          axis.title = element_text(size = 12),
          legend.position = "none",
          panel.grid.major = element_line(color = "grey90"),
          panel.grid.minor = element_blank()
        )
    }
  })
  
  # Distribution plot - Raw simulation data
  output$distribution_plot <- renderPlot({
    req(input$coverage)
    
    data_dist <- ob_timings %>%
      filter(R0 == input$r0, VE == input$ve, coverage == input$coverage) %>%
      filter(breach_times > 0)  # 过滤非正数
    
    if (nrow(data_dist) == 0) {
      plot.new()
      text(0.5, 0.5, "No data available for selected parameters", cex = 1.5)
    } else {
      summary_data <- ob_timings_summary %>%
        filter(R0 == input$r0, VE == input$ve, coverage == input$coverage)
      
      t50_val <- if (nrow(summary_data) > 0) summary_data$t50_days[1] else NA
      t95_val <- if (nrow(summary_data) > 0) summary_data$t95_days[1] else NA
      
      p <- ggplot(data_dist, aes(x = breach_times)) +
        geom_histogram(bins = 30, fill = "#1B9E77", alpha = 0.7, color = "white") +
        scale_x_log10(breaks = c(10, 100, 1000, 10000)) +
        labs(
          title = paste0("Simulation-based Distribution of Breach Times (R₀ = ", input$r0, ", VE = ", input$ve * 100, "%, Coverage = ", input$coverage * 100, "%)"),
          x = "Days (log scale)",
          y = "Frequency"
        ) +
        theme_minimal() +
        theme(
          plot.title = element_text(size = 14, face = "bold"),
          axis.title = element_text(size = 12),
          panel.grid.major = element_line(color = "grey90"),
          panel.grid.minor = element_blank()
        )
      
      if (!is.na(t50_val)) {
        p <- p + geom_vline(xintercept = t50_val, linetype = "dashed", color = "#D95F02", size = 1) +
          annotate("text", x = t50_val, y = Inf, label = "t50", vjust = 1.5, hjust = -0.3, color = "#D95F02", fontface = "bold")
      }
      if (!is.na(t95_val)) {
        p <- p + geom_vline(xintercept = t95_val, linetype = "dotted", color = "#7570B3", size = 1) +
          annotate("text", x = t95_val, y = Inf, label = "t95", vjust = 1.5, hjust = -0.3, color = "#7570B3", fontface = "bold")
      }
      
      p
    }
  })
  
  # Timing data table
  output$timing_table <- renderTable({
    ob_timings_summary %>%
      filter(R0 == input$r0, VE == input$ve) %>%
      select(coverage, t50_days, t95_days) %>%
      mutate(
        coverage = paste0(coverage * 100, "%"),
        t50_days = round(t50_days, 2),
        t95_days = round(t95_days, 2)
      ) %>%
      rename("Coverage" = coverage, "t50 (days)" = t50_days, "t95 (days)" = t95_days)
  })
  
  # Breach data table
  output$breach_table <- renderTable({
    ob_probs_travellers %>%
      filter(R0 == input$r0, VE == input$ve) %>%
      select(coverage, traveller_ob_prob, worker_ob_prob) %>%
      mutate(
        coverage = paste0(coverage * 100, "%"),
        traveller_ob_prob = round(traveller_ob_prob, 4),
        worker_ob_prob = round(worker_ob_prob, 4)
      ) %>%
      rename("Coverage" = coverage, "Traveller Probability" = traveller_ob_prob, "Worker Probability" = worker_ob_prob)
  })
}

shinyApp(ui, server)