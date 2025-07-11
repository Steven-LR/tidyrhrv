% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_tilt.R
\name{plot_tilt}
\alias{plot_tilt}
\title{Store Plots of RR Series in Folders and Produce RMSSD and pNN50 Output}
\usage{
plot_tilt(.data, folder, type)
}
\arguments{
\item{.data}{A data frame containing HRV data from previous tidyrhrv functions}

\item{folder}{A character string specifying the folder name for saved plots}

\item{type}{A character string indicating whether data are "filtered" or "original"}
}
\value{
A list of data frames containing RMSSD and pNN50 values for each dataset
}
\description{
Creates plots of heart rate variability data and saves them to specified folders
while calculating time domain metrics (RMSSD and pNN50).
}
\examples{
\dontrun{
# Create output directory
dir.create("./hrv_plots")
# Generate plots and metrics
results <- plot_tilt(filtered_data, folder = "hrv_plots", type = "filtered")
}
}
