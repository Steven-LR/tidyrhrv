#' Prep Data
#' This function helps to manipulate the data into a data set readable by
#' other tidyrhrv functions.
#'
#' @param .data data set
#' @param time heart beat time interval
#' @param HR Heart beat series
#' @param RR RR series
#'
#' @return nest dataframe
#' @export
#' @examples
#' read_tilt(data, time, Heart beat, RR)
prep_data <- function(.data, time, HR, RR){

  contents <- . <- Time <- niHR<- NULL
 .data<- .data %>%
            dplyr::mutate(contents = purrr::map(contents,. %>%
                                                  dplyr::rename("Time"= time,"niHR" = HR, "RR"=RR) %>%
                                                  dplyr::select(Time, niHR, RR) ))


}
