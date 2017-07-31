library(tidyverse)
library(magrittr)
library(readxl)
library(readr)
library(data.table)
library(lubridate)

#data format
# state | year | name | job_title | agency | base_pay
standard_col_name <- c("state", "year", "name", "job_title", "agency", "base_pay")

#california
california_sal <- fread("states_data/california/ca_sal.csv")

clean_california <- california_sal %>%
  mutate(state = "california")%>%
  select(state, year, employee_name, job_title, jurisdiction_name, base_pay) %>%
  set_colnames(standard_col_name)

#conneticut
conneticut_sal <- fread("states_data/conneticut/conneticut_2016.csv")
colnames(conneticut_sal)


clean_conneticut <- conneticut_sal %>% 
  mutate(state = "conneticut") %>%
  filter(grepl("Salaries", `COMPENSATION TYPE`)) %>% #filtering out non-salaries, need to revisit
  select(state, `FISCAL YEAR`, NAME, `JOB TITLE`, AGENCY, AMOUNT) %>%
  set_colnames(standard_col_name)
  
#flordia
flordia_sal <- fread("states_data/flordia/all-salaries.csv")
colnames(flordia_sal)

clean_flordia <- flordia_sal %>% 
  mutate(state = "flordia", year = 2017, name = paste(`Last Name`, `First Name`, sep = ",")) %>% #need to check the year updated
  select(state, year, name, `Class Title`, `Agency Name`, Salary) %>%
  set_colnames(standard_col_name)

#idaho
idaho_sal <- read_xlsx("states_data/idaho/all_state.xlsx", sheet = 1)
colnames(idaho_sal)

clean_idaho <- idaho_sal %>% 
  mutate(state = "idaho", year = 2017, base_pay = if_else(`Pay Basis` == "HOURLY", `Pay Rate`*2080, `Pay Rate`)) %>%
  select(state, year, Name, `Job Title`, Agency, base_pay) %>%
  set_colnames(standard_col_name)


#kansas
kansas_sal <- fread("states_data/kansas/all_kansas.csv")
colnames(kansas_sal)

clean_kansas <- kansas_sal %>%
  mutate(state = "kansas", name = paste(`Last Name`, `First Name`, sep = ",")) %>%
  select(state, Year, name, Position, Agency, `Total Pay`) %>%
  set_colnames(standard_col_name)

#maryland

maryland_colnames <- c('first-name','middle-initial','last-name','suffix','system','agency-number','organization-name','organization-subtitle','class-code','annual-salary','regular-earnings','eod','overtime-earnings','other-earnings','ytd-gross','pay-rate')
maryland_sal_2015 <- fread("states_data/maryland/export2015.csv") %>% 
  select(1:16) %>% 
  mutate(state = "maryland", year = 2016, name = paste(`last-name`, `first-name`, sep = ",")) %>%
  select(state, year, name, `class-code`, `organization-name`, `regular-earnings`) %>%
  set_colnames(standard_col_name)
  
maryland_sal_2016 <- fread("states_data/maryland/maryland_2016.csv") %>% 
  set_colnames(c("num", maryland_colnames)) %>% 
  select(2:17) %>%
  mutate(state = "maryland", year = 2016, name = paste(`last-name`, `first-name`, sep = ",")) %>%
  select(state, year, name, `class-code`, `organization-name`, `annual-salary`) %>%
  set_colnames(standard_col_name)

maryland_sal_2014 <- read.csv("states_data/maryland/all_2014.csv") %>% select(1:16) %>%
  set_colnames(maryland_colnames) %>% 
  as.data.table() %>%
  mutate(state = "maryland", year = 2014, name = paste(`last-name`, `first-name`, sep = ",")) %>%
  select(state, year, name, `class-code`, `organization-name`, `annual-salary`) %>%
  filter(`annual-salary` < 1000000000) %>%
  set_colnames(standard_col_name)

job_title_join_maryland <- read_excel("states_data/maryland/salaryplan.xlsx") %>% select(1:2) %>% set_colnames(c("id", "desc"))

clean_maryland <- do.call(rbind, list(maryland_sal_2016, maryland_sal_2015, maryland_sal_2014)) %>% 
  left_join(job_title_join_maryland, by = c("job_title" = "id"))


#minnesota
minesota_sal_2012 <- excel_combine("states_data/minesota/minesota_2012.xlsx", "TEMPORARY_EMPLOYEE_ID") %>% mutate(state = "minesota", year = 2012)
minesota_sal_2011 <- excel_combine("states_data/minesota/minesota_2011.xlsx", "TEMPORARY_EMPLOYEE_ID") %>% select(1:38) %>% mutate(state = "minesota", year = 2011) %>% set_colnames(colnames(minesota_sal_2012))
minesota_sal_2013 <- excel_combine("states_data/minesota/minesota_2013.xlsx", "TEMPORARY_EMPLOYEE_ID") %>% select(1:38) %>% mutate(state = "minesota", year = 2013) %>% set_colnames(colnames(minesota_sal_2012))
minesota_sal_2014 <- excel_combine("states_data/minesota/minesota_2014.xlsx", "TEMPORARY_EMPLOYEE_ID") %>% mutate(state = "minesota", year = 2014) %>% set_colnames(colnames(minesota_sal_2012))
minesota_sal_2015 <- excel_combine("states_data/minesota/minesota_2015.xlsx", "TEMPORARY_EMPLOYEE_ID") %>% mutate(state = "minesota", year = 2015) %>% set_colnames(colnames(minesota_sal_2012))

minesota_temp <- do.call(rbind, list(minesota_sal_2011, minesota_sal_2012, minesota_sal_2013, minesota_sal_2014, minesota_sal_2015)) %>%
    select(state, year, EMPL_NM, JOB_DESC, EMPLT_AGENCY_NM, REGWAGES) %>%
    set_colnames(standard_col_name)

minesota_sal_2016 <- excel_combine_o("states_data/minesota/minesota_2016.xlsx", "TEMPORARY_ID") %>% mutate(state = "minesota", year = 2016) %>%
    select(state, year, EMPLOYEE_NAME, JOB_TITLE, AGENCY_NAME, REGULAR_WAGES) %>%
    set_colnames(standard_col_name)

clean_minesota <- rbind(minesota_temp, minesota_sal_2016)

#new_hampshire
new_hampsire_sal_2012 <- read_xls("states_data/new_hampshire/2012-employee-pay.xls", sheet = 2)
new_hampsire_sal_2013 <- read_xls("states_data/new_hampshire/2013-employee-pay.xls", sheet = 2)
new_hampsire_sal_2014 <- read_xls("states_data/new_hampshire/2014-employee-pay.xls", sheet = 2)
new_hampsire_sal_2015 <- read_xls("states_data/new_hampshire/2015-employee-pay.xls", sheet = 2)
new_hampsire_sal_2016 <- read_xls("states_data/new_hampshire/2016-employee-pay.xls", sheet = 2)

#new_york
new_york_sal_sa <- fread("states_data/new_york/state_authorites.csv", stringsAsFactors = FALSE)
new_york_sal_ld <- fread("states_data/new_york/local_development.csv", stringsAsFactors = FALSE)
new_york_sal_ida <- fread("states_data/new_york/industrial_development_agencies.csv", stringsAsFactors = FALSE)
new_york_sal_la <- read.csv("states_data/new_york/local_authorites.csv", stringsAsFactors = FALSE) %>% set_colnames(colnames(new_york_sal_ld))

clean_new_york <- do.call(rbind, list(new_york_sal_ida, new_york_sal_la, new_york_sal_ld, new_york_sal_sa)) %>%
  mutate(state = "new york", name = paste(`First Name`, `Last Name`, sep = ",")) %>%
  select(state, `Fiscal Year End Date`, name, Title, `Authority Name`, `Actual Salary Paid`) %>%
  set_colnames(standard_col_name)

#rhode_island
rhode_island_sal <- read.csv("states_data/rhode_island/rhode_island_all.csv", stringsAsFactors = FALSE)
colnames(rhode_island_sal)

clean_rhode_island <- rhode_island_sal %>%
  mutate(state = "rhode island", name = paste(last, first, sep = ",")) %>%
  select(state, fiscal_year, name, title, department, regular) %>%
  set_colnames(standard_col_name)

#washington
washington_sal <- read_excel(path = "states_data/washington/WaStEmployeeHistSalary.xlsx", sheet = 1, range = cell_rows(7:399430))
colnames(washington_sal) 

clean_washigton <- washington_sal %>%
  gather(key = year, value = base_pay, 4:8) %>%
  mutate(state = "washington") %>%
  select(state, year, Name, Position, Agency, base_pay) %>%
  set_colnames(standard_col_name)

#texas

#combinging states together
#data format: chr | int | chr | chr | chr | num
str(clean_california)
clean_california <- clean_california %>% mutate(year = as.numeric(year), base_pay = as.numeric(base_pay))

str(clean_conneticut)
clean_conneticut <- clean_conneticut %>% mutate(year = as.numeric(year), base_pay = as.numeric(gsub("\\$", "", base_pay)))

str(clean_flordia)
clean_flordia <- clean_flordia %>% mutate(year = as.numeric(year), base_pay = as.numeric(gsub("\\$|\\,", "", base_pay)))

str(clean_idaho)
str(clean_minesota)

str(clean_washigton)
clean_washigton <- clean_washigton %>% mutate(year = as.numeric(year))

str(clean_new_york)
clean_new_york <- clean_new_york %>% mutate(year = as.numeric(format(mdy(year), "%Y")), base_pay = as.numeric(gsub("\\$|\\,", "", base_pay)))

str(clean_kansas)
clean_kansas <- clean_kansas %>% mutate(year = as.numeric(year), base_pay = as.numeric(gsub("\\$|\\,", "", base_pay)))

str(clean_rhode_island)
clean_rhode_island <- clean_rhode_island %>% mutate(year = as.numeric(year), base_pay = as.numeric(gsub("\\$|\\,", "", base_pay)))

all_states <- bind_rows(clean_california, clean_conneticut, clean_flordia, clean_idaho, clean_kansas, clean_minesota, clean_new_york, clean_rhode_island, clean_washigton)

write.csv(all_states, "all_states.csv", row.names = FALSE)
