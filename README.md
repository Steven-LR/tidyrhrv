
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidyrhrv

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/tidyrhrv)](https://CRAN.R-project.org/package=tidyrhrv)
<!-- badges: end -->

The goal of tidyrhrv is to read, iteratively filter, and analyze the
time component of multiple HRV data sets at once.

## Installation

You can install the released version of tidyrhrv from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("tidyrhrv")
```

## Quick Example with Toy Data

Here's a simple example using synthetic HRV data:

``` r
library(tidyrhrv)

# Create toy HRV data
temp_dir <- tempdir()
time_seq <- seq(0, 30, by = 0.8)
hrv_data <- data.frame(
  Time = time_seq,
  HR = 75 + rnorm(length(time_seq), 0, 5),
  RR_interval = 60/75 + rnorm(length(time_seq), 0, 0.1)
)

# Write toy data file
write.csv(hrv_data, file.path(temp_dir, "subject1.csv"), row.names = FALSE)

# Read the data
raw_data <- read_tilt(temp_dir, read.csv)

# Prepare data with standardized column names
prepped_data <- prep_data(raw_data, "Time", "HR", "RR_interval")

# Check the result
print(head(prepped_data$contents[[1]]))

# Clean up
unlink(file.path(temp_dir, "subject1.csv"))
```

## Full Workflow Example

This example shows the complete workflow for real HRV analysis:

``` r
library(tidyrhrv)

# Create folder for saving plots
dir.create("./hrv_analysis")

# Read in HRV data files from a directory
# (assumes you have CSV files with Time, HR, and RR columns)
data <- read_tilt("path/to/your/hrv/files", read.csv) %>% 
  # Prepare data - specify your actual column names
  prep_data("Time", "Heart_Rate", "RR_intervals")

# Plot original data and get time domain metrics
original_metrics <- data %>% 
  plot_tilt("hrv_analysis", "original")

# Apply iterative filtering and plot filtered data
# g = upper bound multiplier, l = lower bound multiplier
filtered_metrics <- data %>% 
  filter_tilt(g = 1.10, l = 0.90) %>% 
  plot_tilt("hrv_analysis", "filtered")

# Combine results for comparison
all_metrics <- c(original_metrics, filtered_metrics)
```

## Testing

The package includes a comprehensive test suite using `testthat`. Run tests with:

```r
devtools::test()
```
