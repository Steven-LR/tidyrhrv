% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/filter_tilt.R
\name{filter_tilt}
\alias{filter_tilt}
\title{Filter Data from prep_data Function Iteratively}
\usage{
filter_tilt(.data, g, l)
}
\arguments{
\item{.data}{A tilt data frame produced by prep_data function}

\item{g}{Numeric value representing the upper bound multiplier for filtering
(greater than median of spline)}

\item{l}{Numeric value representing the lower bound multiplier for filtering
(less than median of spline)}
}
\value{
A data frame with filtered contents
}
\description{
Uses window functions native to the RHRV package and hampel window filter
to iteratively clean heart rate variability data.
}
\examples{
\donttest{
# This example requires RHRV and pracma packages which may not be available
# Create minimal toy data for demonstration
temp_dir <- tempdir()

# Generate realistic HRV data with some outliers
set.seed(123)
hrv_data <- data.frame(
  Time = seq(0, 20, by = 0.8),
  niHR = c(70 + rnorm(20, 0, 3), 120, 72 + rnorm(5, 0, 3)), # Include outlier
  RR = c(60/70 + rnorm(20, 0, 0.05), 0.5, 60/72 + rnorm(5, 0, 0.05))
)

write.csv(hrv_data, file.path(temp_dir, "hrv_test.csv"), row.names = FALSE)

# Read and prepare data
raw_data <- read_tilt(temp_dir, read.csv)
prepped_data <- prep_data(raw_data, "Time", "niHR", "RR")

# Apply filtering (requires RHRV package)
if (requireNamespace("RHRV", quietly = TRUE) && 
    requireNamespace("pracma", quietly = TRUE)) {
  filtered_data <- filter_tilt(prepped_data, g = 1.2, l = 0.8)
  print("Filtering completed")
} else {
  message("RHRV and pracma packages required for filtering")
}

# Clean up
unlink(file.path(temp_dir, "hrv_test.csv"))
}
}
