pkgname <- "tidyrhrv"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
base::assign(".ExTimings", "tidyrhrv-Ex.timings", pos = 'CheckExEnv')
base::cat("name\tuser\tsystem\telapsed\n", file=base::get(".ExTimings", pos = 'CheckExEnv'))
base::assign(".format_ptime",
function(x) {
  if(!is.na(x[4L])) x[1L] <- x[1L] + x[4L]
  if(!is.na(x[5L])) x[2L] <- x[2L] + x[5L]
  options(OutDec = '.')
  format(x[1L:3L], digits = 7L)
},
pos = 'CheckExEnv')

### * </HEADER>
library('tidyrhrv')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("filter_tilt")
### * filter_tilt

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: filter_tilt
### Title: Filter Data from prep_data Function Iteratively
### Aliases: filter_tilt

### ** Examples

## No test: 
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
## End(No test)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("filter_tilt", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("plot_tilt")
### * plot_tilt

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: plot_tilt
### Title: Store Plots of RR Series in Folders and Produce RMSSD and pNN50
###   Output
### Aliases: plot_tilt

### ** Examples

## No test: 
# This example requires RHRV package for HRV analysis
if (requireNamespace("RHRV", quietly = TRUE)) {
  temp_dir <- tempdir()
  
  # Generate synthetic HRV data
  hrv_data <- data.frame(
    Time = seq(0, 25, by = 0.8),
    niHR = 75 + rnorm(32, 0, 4),
    RR = 60/75 + rnorm(32, 0, 0.08)
  )
  
  write.csv(hrv_data, file.path(temp_dir, "plot_test.csv"), row.names = FALSE)
  
  # Read and prepare data
  raw_data <- read_tilt(temp_dir, read.csv)
  prepped_data <- prep_data(raw_data, "Time", "niHR", "RR")
  
  # Create plots and calculate metrics  
  plot_folder <- "test_hrv_plots"
  results <- plot_tilt(prepped_data, plot_folder, "original")
  
  print("Plots created and metrics calculated")
  
  # Clean up
  unlink(file.path(temp_dir, "plot_test.csv"))
  unlink(plot_folder, recursive = TRUE)
} else {
  message("RHRV package required for this function")
}
## End(No test)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("plot_tilt", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("prep_data")
### * prep_data

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: prep_data
### Title: Prepare Data for tidyrhrv Functions
### Aliases: prep_data

### ** Examples

# Create toy HRV data
temp_dir <- tempdir()

# Generate synthetic data with different column names to demonstrate prep_data
time_seq <- seq(0, 30, by = 0.8)
hrv_data <- data.frame(
  time_col = time_seq,
  heart_rate = 75 + rnorm(length(time_seq), 0, 5),
  rr_interval = 60/75 + rnorm(length(time_seq), 0, 0.1)
)

# Write toy data file
write.csv(hrv_data, file.path(temp_dir, "test_subject.csv"), row.names = FALSE)

# Read the data using read_tilt
raw_data <- read_tilt(temp_dir, read.csv)

# Prepare data with standardized column names
prepped_data <- prep_data(raw_data, "time_col", "heart_rate", "rr_interval")

# Check the standardized column names
print(names(prepped_data$contents[[1]]))

# Clean up
unlink(file.path(temp_dir, "test_subject.csv"))



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("prep_data", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("read_tilt")
### * read_tilt

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: read_tilt
### Title: Read Multiple Tilt Data Files
### Aliases: read_tilt

### ** Examples

# Create toy HRV data files in temporary directory
temp_dir <- tempdir()

# Generate synthetic HRV data for two subjects
hrv_data1 <- data.frame(
  Time = seq(0, 60, by = 0.8),  # 60 seconds of data
  HR = 70 + rnorm(76, 0, 5),   # Heart rate around 70 bpm
  RR = 60/70 + rnorm(76, 0, 0.1) # RR intervals
)

hrv_data2 <- data.frame(
  Time = seq(0, 45, by = 0.7),  # 45 seconds of data  
  HR = 80 + rnorm(65, 0, 4),   # Heart rate around 80 bpm
  RR = 60/80 + rnorm(65, 0, 0.08)
)

# Write toy data files
write.csv(hrv_data1, file.path(temp_dir, "subject1.csv"), row.names = FALSE)
write.csv(hrv_data2, file.path(temp_dir, "subject2.csv"), row.names = FALSE)

# Read the data using read_tilt
tilt_data <- read_tilt(temp_dir, read.csv)
print(tilt_data)

# Clean up
unlink(file.path(temp_dir, c("subject1.csv", "subject2.csv")))

## No test: 
# For reading other file types (requires additional packages)
# data <- read_tilt(temp_path, readr::read_csv)
## End(No test)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("read_tilt", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
