#' Global Variable Declarations
#' 
#' This file declares global variables used in non-standard evaluation (NSE)
#' contexts throughout the tidyrhrv package to avoid R CMD check NOTEs.
#' 
#' @keywords internal
#' @noRd

# Declare global variables used in dplyr and other NSE contexts
utils::globalVariables(c(
  ".",
  "contents",
  "names",
  "Time",
  "niHR", 
  "RR",
  "value",
  "rowname",
  "rMSSD",
  "pNN50"
)) 