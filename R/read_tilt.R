
#' Data frame of name and content of files.
#'
#' Read in all tilt data files in a folder at once to
#' be iterated through by other functions.
#'
#' @param path string
#' @param file_type read function
#'
#' @return nest dataframe
#' @export
#' @examples
#' read_tilt("path/to/folder/of/tilt/files", read_csv or ... others)
read_tilt <- function(path, file_type) {
  if (!requireNamespace(c("readr", "dplyr"), quietly = TRUE)) {
    stop("Packages readr and dplyr are needed to run this function.",
      call. = FALSE
    )
  }

  files_names <- paste(path, list.files(paste0(path)), sep = "")
  files_names <- list.files(paste0(path))

  # Creats a table of the file names and their contents
  df <- tibble(names = files_names) %>%
    mutate(contents = map(names, ~ file_type(file.path(paste0(path), .))))

  df
}
