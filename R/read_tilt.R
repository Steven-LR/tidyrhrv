#install.packages("tidyverse")
library(tidyverse)

## reading in csv tiltfiles

read_tilt <- function(path, study){
  files_names<- paste("./Autonomics raw data/",study,list.files(paste0("./Autonomics raw data/",study)),sep="")
  files_names<-list.files(paste0("./Autonomics raw data/",study))
  data = tibble(names = files_names) %>%
    mutate(contents = map(names, ~read_csv(file.path(paste0("./Autonomics raw data/",study), .))))

  data
}
