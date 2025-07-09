#' Filter Data from prep_data Function Iteratively
#'
#' Uses window functions native to the RHRV package and hampel window filter
#' to iteratively clean heart rate variability data.
#'
#' @param .data A tilt data frame produced by prep_data function
#' @param g Numeric value representing the upper bound multiplier for filtering 
#'   (greater than median of spline)
#' @param l Numeric value representing the lower bound multiplier for filtering 
#'   (less than median of spline)
#'
#' @return A data frame with filtered contents
#' @export
#' @examples
#' \dontrun{
#' # Assuming you have data from read_tilt and prep_data
#' filtered_data <- filter_tilt(prepped_data, g = 1.1, l = 0.9)
#' }
filter_tilt <- function(.data, g, l){
  
  # Check dependencies individually
  if (!requireNamespace("stats", quietly = TRUE)) {
    stop("Package 'stats' is needed for this function to work. Please install it.", call. = FALSE)
  }
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    stop("Package 'dplyr' is needed for this function to work. Please install it.", call. = FALSE)
  }
  if (!requireNamespace("purrr", quietly = TRUE)) {
    stop("Package 'purrr' is needed for this function to work. Please install it.", call. = FALSE)
  }
  if (!requireNamespace("RHRV", quietly = TRUE)) {
    stop("Package 'RHRV' is needed for this function to work. Please install it.", call. = FALSE)
  }
  if (!requireNamespace("pracma", quietly = TRUE)) {
    stop("Package 'pracma' is needed for this function to work. Please install it.", call. = FALSE)
  }
  
  # Validate inputs
  if (missing(.data) || is.null(.data)) {
    stop("Argument '.data' is missing with no default", call. = FALSE)
  }
  if (missing(g) || !is.numeric(g)) {
    stop("Argument 'g' must be a numeric value", call. = FALSE)
  }
  if (missing(l) || !is.numeric(l)) {
    stop("Argument 'l' must be a numeric value", call. = FALSE)
  }
  
  # Define the filtering function
  filt <- function(name, data_arg){
    # Bind variables for R CMD check
    niHR <- NULL
    
    hrv.data <- RHRV::CreateHRVData()
    hrv.data$Beat <- data_arg$contents[data_arg$names == name][[1]] %>% 
      base::data.frame() %>% 
      stats::na.omit()
    hrv.data <- RHRV::BuildNIHR(hrv.data)
    
    # Check if we have data to work with
    if (nrow(hrv.data$Beat) == 0) {
      warning(paste("No data found for", name), call. = FALSE)
      return(data.frame())
    }
    
    hrv.data.time.grid <- base::seq(
      base::range(hrv.data$Beat$Time)[1],
      base::range(hrv.data$Beat$Time)[2]
    )
    mod <- stats::smooth.spline(hrv.data$Beat$Time, hrv.data$Beat$niHR)
    pred <- stats::predict(mod, x = hrv.data.time.grid)$y
    
    loop_number <- 1
    
    while(base::max(hrv.data$Beat$niHR) > g * stats::median(pred) | 
          base::min(hrv.data$Beat$niHR) < l * stats::median(pred) & 
          loop_number < 6){
      
      hrv.data <- RHRV::FilterNIHR(
        hrv.data, 
        long = 50, 
        last = 10, 
        minbpm = 45, 
        maxbpm = 180
      )
      hrv.data$Beat <- hrv.data$Beat %>% base::data.frame()
      hrv.data$Beat$niHR <- pracma::hampel(hrv.data$Beat$niHR, 5, 5)$y
      
      loop_number <- loop_number + 1
    }
    
    return(hrv.data$Beat)
  }
  
  # Apply the filtering function and return the result
  result <- .data %>%
    dplyr::mutate(contents = purrr::map(.data$names, filt, data_arg = .data))
  
  return(result)
}
