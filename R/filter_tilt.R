#' Data frame of name and content of files.
#'
#' Read in all tilt data files in a folder at once to
#' be iterated through by other functions.
#'
#' @param .data tilt data frame
#' @param g greater than median of spline
#' @param l less than median of spline
#' @return date from of rmssd and pnn50
#' @export
#' @examples
#' filter_tilt(prepdata, greaterthan, lessthan)
filter_tilt <- function(.data,g,l){

  filt <- function(name){

    hrv.data = RHRV::CreateHRVData()
    hrv.data$Beat = .data$contents[.data$names==name] %>% data.frame() %>% na.omit()
    hrv.data = RHRV::BuildNIHR(hrv.data)

    hrv.data.time.grid <- seq(range(hrv.data$Beat$Time)[1],range(hrv.data$Beat$Time)[2])
    mod <- smooth.spline(hrv.data$Beat$Time, hrv.data$Beat$niHR)
    pred <- predict(mod, x = hrv.data.time.grid)$y

    loop_number = 1

    while( max(hrv.data$Beat$niHR) > g*median(pred) | min(hrv.data$Beat$niHR) < l*median(pred) & loop_number < 6){
      hrv.data = RHRV::FilterNIHR(hrv.data, long = 50, last = 10, minbpm = 45, maxbpm = 180)
      hrv.data$Beat = hrv.data$Beat %>% data.frame() %>%
        dplyr::mutate(niHR= pracma::hampel(niHR,5,5)$y)

      loop_number = loop_number + 1
    }

    hrv.data$Beat
  }

  .data = .data %>%
    dplyr::mutate(contents = purrr::map(.data$names, filt))

}
