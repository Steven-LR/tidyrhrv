
#' Read Multiple Tilt Data Files
#'
#' Read in all tilt data files in a folder at once to create a nested data frame
#' that can be processed by other tidyrhrv functions.
#'
#' @param path A character string specifying the path to the folder containing data files
#' @param file_type A function to read the files (e.g., readr::read_csv, read.table, etc.)
#'
#' @return A nested data frame with 'names' and 'contents' columns
#' @export
#' @examples
#' # Create toy HRV data files in temporary directory
#' temp_dir <- tempdir()
#' 
#' # Generate synthetic HRV data for two subjects
#' hrv_data1 <- data.frame(
#'   Time = seq(0, 60, by = 0.8),  # 60 seconds of data
#'   HR = 70 + rnorm(76, 0, 5),   # Heart rate around 70 bpm
#'   RR = 60/70 + rnorm(76, 0, 0.1) # RR intervals
#' )
#' 
#' hrv_data2 <- data.frame(
#'   Time = seq(0, 45, by = 0.7),  # 45 seconds of data  
#'   HR = 80 + rnorm(65, 0, 4),   # Heart rate around 80 bpm
#'   RR = 60/80 + rnorm(65, 0, 0.08)
#' )
#' 
#' # Write toy data files
#' write.csv(hrv_data1, file.path(temp_dir, "subject1.csv"), row.names = FALSE)
#' write.csv(hrv_data2, file.path(temp_dir, "subject2.csv"), row.names = FALSE)
#' 
#' # Read the data using read_tilt
#' tilt_data <- read_tilt(temp_dir, read.csv)
#' print(tilt_data)
#' 
#' # Clean up
#' unlink(file.path(temp_dir, c("subject1.csv", "subject2.csv")))
#' 
#' \donttest{
#' # Example with readr package (if available)
#' if (requireNamespace("readr", quietly = TRUE)) {
#'   # Create another toy data file
#'   write.csv(hrv_data1, file.path(temp_dir, "subject3.csv"), row.names = FALSE)
#'   
#'   # Read using readr::read_csv
#'   data_readr <- read_tilt(temp_dir, readr::read_csv)
#'   print(head(data_readr))
#'   
#'   # Clean up
#'   unlink(file.path(temp_dir, "subject3.csv"))
#' }
#' }
read_tilt <- function(path, file_type) {
  
  # Check dependencies individually
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    stop("Package 'dplyr' is needed for this function to work. Please install it.", call. = FALSE)
  }
  if (!requireNamespace("tibble", quietly = TRUE)) {
    stop("Package 'tibble' is needed for this function to work. Please install it.", call. = FALSE)
  }
  if (!requireNamespace("purrr", quietly = TRUE)) {
    stop("Package 'purrr' is needed for this function to work. Please install it.", call. = FALSE)
  }
  
  # Validate inputs
  if (missing(path) || !is.character(path)) {
    stop("Argument 'path' must be a character string", call. = FALSE)
  }
  if (missing(file_type) || !is.function(file_type)) {
    stop("Argument 'file_type' must be a function", call. = FALSE)
  }
  
  # Ensure path ends with separator
  if (!endsWith(path, "/") && !endsWith(path, "\\")) {
    path <- paste0(path, "/")
  }
  
  # Check if directory exists
  if (!dir.exists(path)) {
    stop(paste("Directory does not exist:", path), call. = FALSE)
  }
  
  # Get list of files
  files_names <- base::list.files(path, full.names = FALSE)
  
  if (length(files_names) == 0) {
    stop(paste("No files found in directory:", path), call. = FALSE)
  }
  
  # Create nested data frame
  df <- tibble::tibble(names = files_names) %>%
    dplyr::mutate(contents = purrr::map(names, ~ {
      file_path <- base::file.path(path, .x)
      tryCatch({
        file_type(file_path)
      }, error = function(e) {
        warning(paste("Failed to read file:", .x, "Error:", e$message), call. = FALSE)
        return(NULL)
      })
    }))
  
  return(df)
}
