
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

  if (!requireNamespace(c("readr", "dplyr","tibble","purrr"), quietly = TRUE)) {
    stop("Packages readr, dplyr, tibble, and purr are needed to run this function.",
      call. = FALSE
    )
  }



  files_names <- base::paste(path,base::list.files(base::paste0(path)),sep="")
  files_names <- base::list.files(base::paste0(path))

  df <- tibble::tibble(names = files_names) %>%
     dplyr::mutate(contents = purrr::map(names, ~ file_type(base::file.path(base::paste0(path), .))))


}
