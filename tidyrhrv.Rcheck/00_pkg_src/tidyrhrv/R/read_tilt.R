
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
#' \dontrun{
#' # Read CSV files from a directory
#' data <- read_tilt("path/to/folder/", readr::read_csv)
#' # Read other file types
#' data <- read_tilt("path/to/folder/", read.table)
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
