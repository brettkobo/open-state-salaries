library(httr)
library(XML)
library(magrittr)
library(rvest)  
library(tidyverse)

texas_sal_list <- readLines("https://s3.amazonaws.com/raw.texastribune.org/") %>% .[2] %>% xmlToDataFrame()

texas_sal_list <- texas_sal_list %>% filter(grepl("salaries", Key), Size > 1)

#downloading all .csv on the sites
for(p in 1:length(texas_sal_list$Key)) {
  downloadCSV <- URLencode(paste0("https://s3.amazonaws.com/raw.texastribune.org/", as.character(texas_sal_list$Key[p])))
  #downloads a files, if 404 then that URL will be logged outside of loop
  fail <- tryCatch({
    download.file(url = downloadCSV, destfile = paste0("states_data/texas/", basename(as.character(texas_sal_list$Key[p]))), method='libcurl')},
    error=function(err) {
      write(downloadCSV, file="log_error.txt", append = TRUE)
      return(TRUE)
    })
  if(fail == TRUE){
    next
  }
  print(p)
}


#flordia - downloaded
http://salaries.myflorida.com/?format=csv 

#idaho - downloaded
https://ibis.sco.idaho.gov/pubtrans/workforce/Workforce%20by%20Name%20Summary%20xls-en-us.xlsx

#washington - downloaded
http://fiscal.wa.gov/WaStEmployeeHistSalary.xlsx

#new york
download.file(url = "https://data.ny.gov/api/views/wryv-rizw/rows.csv?accessType=DOWNLOAD", destfile = "states_data/new_york/local_development.csv", method='libcurl')
download.file(url = "https://data.ny.gov/api/views/fx93-cifz/rows.csv?accessType=DOWNLOAD", destfile = "states_data/new_york/local_authorites.csv", method='libcurl')
download.file(url = "https://data.ny.gov/api/views/unag-2p27/rows.csv?accessType=DOWNLOAD", destfile = "states_data/new_york/state_authorites", method='libcurl')
download.file(url = "https://data.ny.gov/api/views/9yx9-29p4/rows.csv?accessType=DOWNLOAD", destfile = "states_data/new_york/industry development", method='libcurl')
 
#new hampshire - downloaded
https://www.nh.gov/transparentnh/search/documents/2016-employee-pay.xls
https://www.nh.gov/transparentnh/search/documents/2015-employee-pay.xls
https://www.nh.gov/transparentnh/search/documents/2014-employee-pay.xls
https://www.nh.gov/transparentnh/search/documents/2013-employee-pay.xls
https://www.nh.gov/transparentnh/search/documents/2012-employee-pay.xls


#minesota - downloaded
download.file(url = "https://mn.gov/mmb-stat/transparency/employee-salary-data/fiscal-year-2016.xlsx", destfile = "states_data/minesota/minesota_2016.xlsx", method='libcurl')
download.file(url = "https://mn.gov/mmb-stat/transparency/employee-salary-data/fiscal-year-2015.xlsx", destfile = "states_data/minesota/minesota_2015.xlsx", method='libcurl')
download.file(url = "https://mn.gov/mmb-stat/transparency/employee-salary-data/fiscal-year-2014.xlsx", destfile = "states_data/minesota/minesota_2014.xlsx", method='libcurl')
download.file(url = "https://mn.gov/mmb-stat/transparency/employee-salary-data/fiscal-year-2013.xlsx", destfile = "states_data/minesota/minesota_2013.xlsx", method='libcurl')
download.file(url = "https://mn.gov/mmb-stat/transparency/employee-salary-data/fiscal-year-2012.xlsx", destfile = "states_data/minesota/minesota_2012.xlsx", method='libcurl')
download.file(url = "https://mn.gov/mmb-stat/transparency/employee-salary-data/fiscal-year-2011.xlsx", destfile = "states_data/minesota/minesota_2011.xlsx", method='libcurl')

#maryland - downloaded
download.file(url = "https://github.com/baltimore-sun-data/maryland-salaries/raw/master/state-cy-2016.csv", destfile = "states_data/maryland/maryland_2016.csv", method='libcurl')

download.file(url = "", destfile = "states_data/maryland/maryland_2016.csv", method='libcurl')
#conneticut - downloaded
download.file(url = "https://data.ct.gov/api/views/fgmk-ht2c/rows.csv?accessType=DOWNLOAD", destfile = "states_data/conneticut/conneticut_2016.csv", method='libcurl')

#kansas
http://www.kansasopengov.org/kog/table_api.php




