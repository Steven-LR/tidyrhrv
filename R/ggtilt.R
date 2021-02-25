#' Data frame of name and content of files.
#'
#' Read in all tilt data files in a folder at once to
#' be iterated through by other functions.
#'
#' @param .data data file
#' @return plot
#' @export
#' @examples
#' read_tilt("path/to/folder/of/tilt/files", read_csv or ... others)


ggtilt <- function(.data){

  plot_f<- function(content, name){

    plot = content %>%
          dplyr::filter(Time <= 300) %>%
         ggplot2::ggplot(ggplot2::aes(x=Time,y=niHR)) +
         ggplot2::geom_line()+
         ggplot2::theme_minimal()

  ggplot2::ggsave(filename = paste0(name,".png"),
                  device = "png",
                  path ="/Users/stevenlawrence/Desktop/cumc_github/Robinsonpap/Autonomics raw data/testplots")


  }


  purrr::map2(.data %>% dplyr::pull(contents),.data %>% dplyr::pull(names),plot_f)


}
