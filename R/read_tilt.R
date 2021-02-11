#install.packages("tidyverse")
library(tidyverse)

## reading in csv tiltfiles

read_tilt <- function(path,file_type){

  if (!requireNamespace(c("readr","dplyr"), quietly = TRUE)) {
    stop("Packages readr and dplyr are needed to run this function.",
         call. = FALSE)
  }

  files_names<- paste(path, list.files(paste0(path)),sep="")
  files_names<-list.files(paste0(path))

  # Creats a table of the file names and their contents
  df = tibble(names = files_names) %>%
    mutate(contents = map(names, ~file_type(file.path(paste0(path), .))))

  df
}
