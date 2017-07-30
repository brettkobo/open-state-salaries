library(httr)
library(XML)
library(magrittr)
library(rvest)  
library(tidyverse)

#retrives links to list of agencys and schools
agency_links <- read_html("http://transparentcalifornia.com/agencies/salaries/") %>% html_nodes("td:nth-child(1) a") %>% html_attr("href")
school_dis_links <- read_html("http://transparentcalifornia.com/agencies/salaries/school-districts/") %>% html_nodes("td:nth-child(1) a") %>% html_attr("href")
spec_dis_links <- read_html("http://transparentcalifornia.com/agencies/salaries/special-districts/") %>% html_nodes("td:nth-child(1) a") %>% html_attr("href")
charter_sch_links <- read_html("http://transparentcalifornia.com/agencies/salaries/charter-schools/") %>% html_nodes("td:nth-child(1) a") %>% html_attr("href")

all_links <- c(agency_links, school_dis_links, spec_dis_links, charter_sch_links)

#gets list of all .csvs on site
other_sal_export_links <- data.frame()
for(i in 1:length(all_links)) {
  export_link <- read_html(paste0("http://transparentcalifornia.com", all_links[i])) %>% 
    html_nodes(".export-link .export-link") %>% 
    html_attr("href") %>%
    data.frame() %>% unique() %>% mutate(orgin = all_links[i])
  other_sal_export_links <- rbind(other_sal_export_links, export_link)
  print(i)
}

#downloading all .csv on the sites
for(p in 1:length(other_sal_export_links$.)) {
  downloadCSV <- paste0("http://transparentcalifornia.com", as.character(other_sal_export_links$.[p]))
  #downloads a files, if 404 then that URL will be logged outside of loop
  fail <- tryCatch({
    download.file(url = downloadCSV, destfile = paste0("data/", basename(as.character(other_sal_export_links$.[p]))), method='libcurl')},
    error=function(err) {
      write(downloadCSV, file="log_error.txt", append = TRUE)
      return(TRUE)
    })
  if(fail == TRUE){
    next
  }
  print(p)
}
