#' Filters data form prep data function iteratively
#'
#' Uses window functions native to the RHRV package and hampel window filter.
#'
#' @param .data tilt data frame
#' @param g greater than median of spline
#' @param l less than median of spline
#' @return date from of rmssd and pnn50
#' @export
#' @examples
#' filter_tilt(.data, g, l)
filter_tilt <- function(.data,g,l){

  filt <- function(name){
      niHR <- NULL
    hrv.data = RHRV::CreateHRVData()
    hrv.data$Beat = .data$contents[.data$names==name] %>% base::data.frame() %>% stats::na.omit()
    hrv.data = RHRV::BuildNIHR(hrv.data)

    hrv.data.time.grid <- base::seq(base::range(hrv.data$Beat$Time)[1],base::range(hrv.data$Beat$Time)[2])
    mod <- stats::smooth.spline(hrv.data$Beat$Time, hrv.data$Beat$niHR)
    pred <- stats::predict(mod, x = hrv.data.time.grid)$y

    loop_number = 1

    while( base::max(hrv.data$Beat$niHR) > g*stats::median(pred) | base::min(hrv.data$Beat$niHR) < l*stats::median(pred) & loop_number < 6){
      hrv.data = RHRV::FilterNIHR(hrv.data, long = 50, last = 10, minbpm = 45, maxbpm = 180)
      hrv.data$Beat = hrv.data$Beat %>% base::data.frame() %>%
        dplyr::mutate(niHR= pracma::hampel(niHR,5,5)$y)

      loop_number = loop_number + 1
    }

    hrv.data$Beat
  }

  .data = .data %>%
    dplyr::mutate(contents = purrr::map(.data$names, filt))

}
