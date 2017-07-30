library(foreach)
library(doSNOW)
library(doMC)

csv_list <- list.files("data/")


colname_list <- list()
for(i in 1:10567) {
   colname_list[i] <- paste("data/", csv_list[i], sep = "") %>%
     read.csv(nrows = 1, header = FALSE, stringsAsFactor = FALSE) %>% 
     unlist() %>%
     unname() %>% list()
}

#setting the number of cores for parrell process
cl <- makeCluster(4, outfile="progress.txt") # number of cores. Notice 'outfile'
registerDoSNOW(cl)

#foreach look to conbine .csvs together
total <- length(csv_list)
pb <- txtProgressBar(min = 1, max = total, style = 3)
ca_sal <- foreach(i = 1:total, .combine = rbind, .packages = c("magrittr", "tidyverse")) %dopar% 
  {
    s <- combind_csv(i)
    setTxtProgressBar(pb, i) 
    return(s)
  }
#stopping progress bar and the cluster
close(pb)
stopCluster(cl) 

cal_col_name <- c("employee_name", "job_title","base_pay", "overtime_pay","other_pay","total_benefits", "total_pay", "total_pay_benefits", "year","notes","jurisdiction_name")
colnames(ca_sal) <- cal_col_name

write.csv(ca_sal, "ca_sal.csv")

