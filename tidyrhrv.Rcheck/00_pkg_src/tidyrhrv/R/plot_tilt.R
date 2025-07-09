#' Store Plots of RR Series in Folders and Produce RMSSD and pNN50 Output
#'
#' Creates plots of heart rate variability data and saves them to specified folders
#' while calculating time domain metrics (RMSSD and pNN50).
#'
#' @param .data A data frame containing HRV data from previous tidyrhrv functions
#' @param folder A character string specifying the folder name for saved plots
#' @param type A character string indicating whether data are "filtered" or "original"
#' 
#' @return A list of data frames containing RMSSD and pNN50 values for each dataset
#' @export
#' @examples
#' \dontrun{
#' # Create output directory
#' dir.create("./hrv_plots")
#' # Generate plots and metrics
#' results <- plot_tilt(filtered_data, folder = "hrv_plots", type = "filtered")
#' }
plot_tilt <- function(.data, folder, type){
  
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
  if (!requireNamespace("tidyr", quietly = TRUE)) {
    stop("Package 'tidyr' is needed for this function to work. Please install it.", call. = FALSE)
  }
  if (!requireNamespace("RHRV", quietly = TRUE)) {
    stop("Package 'RHRV' is needed for this function to work. Please install it.", call. = FALSE)
  }
  
  # Validate inputs
  if (missing(.data) || is.null(.data)) {
    stop("Argument '.data' is missing with no default", call. = FALSE)
  }
  if (missing(folder)) {
    stop("Argument 'folder' is missing with no default", call. = FALSE)
  }
  if (missing(type)) {
    stop("Argument 'type' is missing with no default", call. = FALSE)
  }
  
  # Create directory if it doesn't exist
  if (!dir.exists(paste0("./", folder))) {
    dir.create(paste0("./", folder), recursive = TRUE)
  }
  
  nihr <- function(name, folder, data_arg, type_arg){
    # Binding global variables to avoid R CMD check NOTEs
    value <- rowname <- rMSSD <- pNN50 <- NULL
    
    # Creating HRV data object
    hrv.data <- RHRV::CreateHRVData()
    hrv.data <- RHRV::SetVerbose(hrv.data, FALSE) # Set to FALSE to reduce output
    hrv.data$Beat <- data_arg$contents[data_arg$names == name][[1]] %>% 
      base::data.frame() %>% 
      stats::na.omit()
    
    # Check if we have data to work with
    if (nrow(hrv.data$Beat) == 0) {
      warning(paste("No data found for", name), call. = FALSE)
      return(data.frame(name = name, rMSSD = NA, pNN50 = NA))
    }
    
    hrv.data <- RHRV::BuildNIHR(hrv.data)
    
    # Saving image of readings
    grDevices::png(
      base::paste0("./", folder, "/", gsub(".csv", "_", x = name), type_arg, ".png")
    )
    RHRV::PlotNIHR(
      hrv.data, 
      main = base::paste0(data_arg$names[data_arg$names == name], type_arg), 
      ylim = c(40, 180)
    )
    grDevices::dev.off()
    
    # Creating time analysis
    hrv.data <- RHRV::CreateTimeAnalysis(hrv.data, size = 300, interval = 7)
    
    # Extract results and format
    df <- hrv.data$TimeAnalysis %>%
      base::unlist() %>%
      base::as.data.frame() %>%
      tibble::rownames_to_column() %>%
      dplyr::rename("value" = ".") %>%
      tidyr::pivot_wider(
        values_from = value,
        names_from = rowname
      ) %>%
      dplyr::mutate(name = data_arg$names[data_arg$names == name]) %>%
      dplyr::select(name, rMSSD, pNN50)
    
    # Rename columns to include type
    names(df)[names(df) == "rMSSD"] <- paste0(type_arg, "_rMSSD")
    names(df)[names(df) == "pNN50"] <- paste0(type_arg, "_pNN50")
    
    return(df)
  }
  
  # Apply the function to all datasets and return results
  results <- purrr::map(.data$names, nihr, 
                       folder = folder, 
                       data_arg = .data, 
                       type_arg = type)
  
  return(results)
}

