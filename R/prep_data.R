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
#' \donttest{
#' # Assuming you have data from read_tilt
#' prepped_data <- prep_data(raw_data, "Time_col", "HR_col", "RR_col")
#' }
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
