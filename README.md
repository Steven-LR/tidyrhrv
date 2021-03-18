
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

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(tidyrhrv)

## creating folder for saving raw and filtered images of niHR 
dir.create("./folder_name")

## read in the data using any appropriate function
data <- read_tilt("path", readr::read_csv) %>% 
        
# preps data to be used by subsequent functions
# tell it what is your time var, Heart Beat, and RR series vectors
        prep_data("R-R x", "HR y", "R-R y")

# plot raw data, which will be placed into folder created above
# a tibble of the outputs will be created
data_table_raw <- data %>% 
                  plot_tilt()

# filter the data all in one step
# set up bounds for iterative filtering if the heart beats are "greater than"  or
# "less than" a certain amount with respect to the smoothing spline of heart beat
data_table_filtered <- data %>% 
                      filter_tilt(1.10, 90) %>% 

# Lastly plot the data and  compare changes in the newly written table
# A new folder is created hosting the raw and filtered plots of each file
                      plot_tilt()


# Join the two tables using rbind

d_table <- rbind(data_table_raw, data_table_filtered)
```
