
#' Storing plots of RR series in folders for review
#'
#' @param .data dataframe
#' @param time hr time var
#' @param hr heart beat
#' @param rr heart beat intervals
#' @param folder folder for the saved plots
#'
#' @return data frame
#' @export
#' @examples
#' plot_tilt(data frame, time, hr, rr, folder)

plot_tilt <- function(.data, folder){

  folder = dir.create(paste0(folder))

  nihr <- function(name,folder){

  hrv.data = RHRV::CreateHRVData()
  hrv.data = RHRV::SetVerbose(hrv.data, TRUE )
  hrv.data$Beat <- .data$contents[.data$names==name] %>% data.frame() %>% na.omit()
  hrv.data = RHRV::BuildNIHR(hrv.data)

  png(paste(folder,name,"org.png"))
  RHRV::PlotNIHR(hrv.data, main = paste0(.data$names[.data$names==name],"Original HRV"), ylim = c(40,180))
  dev.off()

  hrv.data = RHRV::CreateTimeAnalysis(hrv.data, size = 300, interval = 7)

  hrv.data$TimeAnalysis  %>%
    base::unlist() %>%
    base::as.data.frame() %>%
    tibble::rownames_to_column() %>%
    dplyr::rename("value" =".") %>%
    tidyr::pivot_wider(
      values_from = value,
      names_from = rowname
    ) %>%
    dplyr::mutate(name = data$names[data$names==name]) %>%
    dplyr::select(name,rMSSD,pNN50) %>%
    dplyr::rename("org_rmssd" = rMSSD, "org_pnn50"= pNN50 )
  }

  purrr::map2(.data$names,folder,nihr)

}

