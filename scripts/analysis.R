library(tidytext)
library(tidyverse)
library(magrittr)

all_states <- read.csv("all_states.csv", stringsAsFactors = FALSE)
all_states %>% mutate(job_title = trimws(tolower(job_title))) %>%
  group_by(job_title) %>% tally() %>% arrange(-n)