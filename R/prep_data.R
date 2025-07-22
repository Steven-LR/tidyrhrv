#' Prepare Data for tidyrhrv Functions
#' 
#' This function helps to manipulate the data into a dataset readable by
#' other tidyrhrv functions by standardizing column names.
#'
#' @param .data A nested data frame from read_tilt function
#' @param time A character string specifying the name of the time column
#' @param HR A character string specifying the name of the heart rate column  
#' @param RR A character string specifying the name of the RR interval column
#'
#' @return A nested data frame with standardized column names (Time, niHR, RR)
#' @export
#' @examples
#' # Create toy HRV data
#' temp_dir <- tempdir()
#' 
#' # Generate synthetic data with different column names to demonstrate prep_data
#' time_seq <- seq(0, 30, by = 0.8)
#' hrv_data <- data.frame(
#'   time_col = time_seq,
#'   heart_rate = 75 + rnorm(length(time_seq), 0, 5),
#'   rr_interval = 60/75 + rnorm(length(time_seq), 0, 0.1)
#' )
#' 
#' # Write toy data file
#' write.csv(hrv_data, file.path(temp_dir, "test_subject.csv"), row.names = FALSE)
#' 
#' # Read the data using read_tilt
#' raw_data <- read_tilt(temp_dir, read.csv)
#' 
#' # Prepare data with standardized column names
#' prepped_data <- prep_data(raw_data, "time_col", "heart_rate", "rr_interval")
#' 
#' # Check the standardized column names
#' print(names(prepped_data$contents[[1]]))
#' 
#' # Clean up
#' unlink(file.path(temp_dir, "test_subject.csv"))
prep_data <- function(.data, time, HR, RR){
  
  # Bind variables for R CMD check
  contents <- . <- Time <- niHR <- NULL
  
  # Validate inputs
  if (missing(.data) || is.null(.data)) {
    stop("Argument '.data' is missing with no default", call. = FALSE)
  }
  if (missing(time) || !is.character(time)) {
    stop("Argument 'time' must be a character string", call. = FALSE)
  }
  if (missing(HR) || !is.character(HR)) {
    stop("Argument 'HR' must be a character string", call. = FALSE)
  }
  if (missing(RR) || !is.character(RR)) {
    stop("Argument 'RR' must be a character string", call. = FALSE)
  }
  
  # Transform the data
  result <- .data %>%
    dplyr::mutate(contents = purrr::map(contents, . %>%
      dplyr::rename("Time" = !!time, "niHR" = !!HR, "RR" = !!RR) %>%
      dplyr::select(Time, niHR, RR)))
  
  return(result)
}
