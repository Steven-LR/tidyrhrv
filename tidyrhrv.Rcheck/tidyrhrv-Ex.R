pkgname <- "tidyrhrv"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('tidyrhrv')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("filter_tilt")
### * filter_tilt

flush(stderr()); flush(stdout())

### Name: filter_tilt
### Title: Filter Data from prep_data Function Iteratively
### Aliases: filter_tilt

### ** Examples

## Not run: 
##D # Assuming you have data from read_tilt and prep_data
##D filtered_data <- filter_tilt(prepped_data, g = 1.1, l = 0.9)
## End(Not run)



cleanEx()
nameEx("plot_tilt")
### * plot_tilt

flush(stderr()); flush(stdout())

### Name: plot_tilt
### Title: Store Plots of RR Series in Folders and Produce RMSSD and pNN50
###   Output
### Aliases: plot_tilt

### ** Examples

## Not run: 
##D # Create output directory
##D dir.create("./hrv_plots")
##D # Generate plots and metrics
##D results <- plot_tilt(filtered_data, folder = "hrv_plots", type = "filtered")
## End(Not run)



cleanEx()
nameEx("prep_data")
### * prep_data

flush(stderr()); flush(stdout())

### Name: prep_data
### Title: Prepare Data for tidyrhrv Functions
### Aliases: prep_data

### ** Examples

## Not run: 
##D # Assuming you have data from read_tilt
##D prepped_data <- prep_data(raw_data, "Time_col", "HR_col", "RR_col")
## End(Not run)



cleanEx()
nameEx("read_tilt")
### * read_tilt

flush(stderr()); flush(stdout())

### Name: read_tilt
### Title: Read Multiple Tilt Data Files
### Aliases: read_tilt

### ** Examples

## Not run: 
##D # Read CSV files from a directory
##D data <- read_tilt("path/to/folder/", readr::read_csv)
##D # Read other file types
##D data <- read_tilt("path/to/folder/", read.table)
## End(Not run)



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
