
library(omopgenerics)
library(dplyr)
library(readr)

renameCdm <- function(res){
  res |> 
    mutate(cdm_name = 
             case_when(str_detect(tolower(cdm_name), "aurum|heron_cdm")  ~ "CPRD Aurum",
                       str_detect(tolower(cdm_name), "gosh") ~ "Great Ormond Street Hospital",
                       str_detect(tolower(cdm_name), "idril") ~ "Lancashire Teaching Hospital",
                       str_detect(tolower(cdm_name), "ltht") ~ "Leeds Teaching Hospitals",
                       str_detect(tolower(cdm_name), "uclh") ~ "University College London Hospitals",
                       str_detect(tolower(cdm_name), "dataloch") ~ "DataLoch Lothian",
                       .default = cdm_name
             )
    ) 
}

characterisation_results <- importSummarisedResult(here::here("data_network",
                                                              "data_raw",
                                                              "characterisation")) |> 
  renameCdm()

snapshot <- characterisation_results |> 
  filterSettings(result_type == "summarise_omop_snapshot")
exportSummarisedResult(snapshot, fileName = here::here("data_network", "data", "snapshot.csv"))

clinical_records <- characterisation_results |> 
  filterSettings(result_type == "summarise_trend") |> 
  tidy()
write_csv(clinical_records, here::here("data_network", "data", "clinical_records.csv"))
