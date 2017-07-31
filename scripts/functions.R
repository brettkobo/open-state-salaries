library(tidyverse)
library(magrittr)

combind_csv <- function(p) {
  processData <- read.csv(paste0("data/", csv_list[p]), stringsAsFactors = TRUE) %>% 
    select(1:11) %>% 
    set_colnames(rep("na", 11))
  return(processData)
}

excel_combine <- function(file_name, join_string) {
  names <- read_xlsx(file_name, sheet = 2)
  earnings <- read_xlsx(file_name, sheet = 3)
  combined_data <- left_join(names, earnings, by = c("TEMPORARY_EMPLOYEE_ID" = "TEMPORARY_EMPLOYEE_ID"))
  return(combined_data)
}

excel_combine_o <- function(file_name, join_string) {
  names <- read_xlsx(file_name, sheet = 2)
  earnings <- read_xlsx(file_name, sheet = 3)
  combined_data <- left_join(names, earnings, by = c("TEMPORARY_ID" = "TEMPORARY_ID"))
  return(combined_data)
}
