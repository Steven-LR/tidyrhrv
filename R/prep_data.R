#' Prep Data
#'
#'
#' @param data data set
#' @param time time variable
#' @param HR Heart Beat
#' @param RR RR series
#'
#' @return nest dataframe
#' @export
#' @examples
#' read_tilt(data, time, Heart beat, RR)
prep_data <- function(.data, time, HR, RR){

  .data %>%
            dplyr::mutate(contents = purrr::map(contents,. %>%
                                                  dplyr::rename("Time"=time, "niHR"= HR, "RR"= RR) %>%
                                                  dplyr::select(Time, niHR, RR) ))

}


