rm(list = ls())
gc()

library("magrittr")
library("readxl")
library("tidyr")
library("haven")

data_raw <- haven::read_dta("../public_data/HRS/randhrs1992_2016/randhrs1992_2016v1.dta")

# Select columns to make data smaller
data <- data_raw %>% 
  dplyr::select(
    hhidpn,
    hhid,
    pn,
    rahhidpn,
    dplyr::ends_with("wtresp"), # sampling weight
    dplyr::ends_with("educ"),   # education
    dplyr::ends_with("age_y"),  # age
    dplyr::ends_with("mstat"),  # marital status
    dplyr::ends_with("gender"), # gender
    dplyr::ends_with("atotn"),  # household total net wealth excluding housing
    dplyr::ends_with("atotb"),  # household total net wealth including second residence
    dplyr::ends_with("shlt"),   # self-report health status (Excellent, good, ...)
    dplyr::ends_with("hibp"),   # report high blood pressure
    dplyr::ends_with("diab"),   # report diabetes
    dplyr::ends_with("cancr"),  # report cancer
    dplyr::ends_with("lung"),   # report lung desease
    dplyr::ends_with("heart"),  # report heart problem
    dplyr::ends_with("strok"),  # report stroke
    dplyr::ends_with("psych"),  # report psych problem
    dplyr::ends_with("arthr"),  # report arthritis
    dplyr::ends_with("hibpe"),  # ever had high blood pressure
    dplyr::ends_with("diabe"),  # ever had diabetes
    dplyr::ends_with("cancre"), # ever had cancer
    dplyr::ends_with("lunge"),  # ever had lung desease
    dplyr::ends_with("hearte"), # ever had heart problem
    dplyr::ends_with("stroke"), # ever had stroke
    dplyr::ends_with("psyche"), # ever had psych problem
    dplyr::ends_with("arthre"), # ever had arthritis
    dplyr::ends_with("nrshom"), # nursing home stay (indicator)
    dplyr::ends_with("nrstim"), # nursing home stay (how many times)
    dplyr::ends_with("nrsnit"), # nursing home stay (how many nights)
    dplyr::ends_with("nhmliv"), # living in nursing home now
    dplyr::ends_with("nhmmvy"), # year moving to nursing home
    dplyr::ends_with("nhmmvm"), # month moving to nursing home
    dplyr::ends_with("nhmday"), # days in nursing home from move / previous interview
    dplyr::ends_with("hiltc"),  # have long-term care insurance
    dplyr::ends_with("iearn"),  # earnings
    dplyr::ends_with("ifearn"), # imputation flag
    dplyr::ends_with("icap"),   # capital income
    dplyr::ends_with("itot"),   # total household income
    dplyr::ends_with("child"),  # number of children
    dplyr::ends_with("livbro"), # number of brothers alive
    dplyr::ends_with("livsis"), # number of sisters alive
  ) 

# Change column names
cols <- colnames(data)
nums <- readr::parse_number(cols) %>% 
  as.character()

cols <- gsub("([a-z])([0-9]{1,2})", "\\1", cols)  # remove wave number from the middle
cols <- paste(cols, nums, sep = "_")              # add wave number to the back
cols <- gsub("_NA", "", cols)
colnames(data) <- cols



# From wide to long

to_keep <- grep("[a-z]+$", cols)
temp <- data %>% 
  gather(key = "variable", value = "value", -to_keep) 

temp$wave <- gsub("[a-z]+_", "", temp$variable) %>% as.numeric()
temp$variable <- gsub("_[0-9]{1,2}", "", temp$variable)

data_long <- temp %>% 
  spread(key = variable, value = value)

data <- data_long


save(data, file = "data/data_cleaned.RData")



load(data, file = "data/data_cleaned.RData")