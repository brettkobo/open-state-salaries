library(tidyverse)
library(magrittr)

combind_csv <- function(p) {
  processData <- read.csv(paste0("data/", csv_list[p]), stringsAsFactors = TRUE) %>% 
    select(1:11) %>% 
    set_colnames(rep("na", 11))
  return(processData)
}