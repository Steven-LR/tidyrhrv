#' Storing plots of RR series in folders for review and produces rmssd and pnn50 output
#'
#' @param .data dataframe
#' @param folder folder for the saved plots
#' @param type whether data are filtered or original
#' @return data frame
#' @export
#' @examples
#' plot_tilt(.data, folder, type)

plot_tilt <- function(.data, folder,type){

  if (!requireNamespace(c("readr", "dplyr","tibble","purrr"), quietly = TRUE)) {
    stop("Packages readr, dplyr, tibble, and purr are needed to run this function.",
         call. = FALSE
    )
  }

  nihr <- function(name,folder){
    # binding global variables

    value <- rowname <- .data<- rMSSD <- pNN50<- NULL
    # creating raw readings
  hrv.data = RHRV::CreateHRVData()
  hrv.data = RHRV::SetVerbose(hrv.data, TRUE )
  hrv.data$Beat <- .data$contents[data$names==name] %>% base::data.frame() %>% stats::na.omit()
  hrv.data = RHRV::BuildNIHR(hrv.data)


    # Saving image of raw readings
  grDevices::png(base::paste0("./",folder,"/",gsub(".csv","_", x=name),type,".png"))
  RHRV::PlotNIHR(hrv.data, main = base::paste0(data$names[data$names==name],type), ylim = c(40,180))
  grDevices::dev.off()

   # creating time analysis for raw and filtered readings
  hrv.data = RHRV::CreateTimeAnalysis(hrv.data, size = 300, interval = 7)

 df = hrv.data$TimeAnalysis  %>%
    base::unlist() %>%
    base::as.data.frame() %>%
    tibble::rownames_to_column() %>%
    dplyr::rename("value" =".") %>%
    tidyr::pivot_wider(
      values_from = value,
      names_from = rowname
    ) %>%
    dplyr::mutate(name = .data$names[.data$names==name]) %>%
    dplyr::select(name,rMSSD,pNN50) %>%
    dplyr::rename(`paste0(type," rMSSD")` = rMSSD, `paste0(type," pNN50")` = pNN50 )



  }

 purrr::map2(.data$names,folder,nihr)


}

