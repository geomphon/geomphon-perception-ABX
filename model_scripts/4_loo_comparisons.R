#!/usr/bin/env Rscript

####################
#do loo comparisons
#by amelia
#################
# in directory model_scripts


model_comparison_functions<-"fn_model_comparison_functions.R"
source(model_comparison_functions)

#ARGS <- commandArgs(TRUE)
MASTER <- "master_df_hk_dinst1.csv" # ARGS[1] #
OUTFILE <- "loo_diffs_hk_dinst1_Sept_2.csv" #ARGS[2] #
RDS_FOLDER <- "model_output_rds" # ARGS[3] #
EXPERIMENT <- "hk"


all_fitted_models <- readr::read_csv(MASTER)

  
all_loos <- all_fitted_models %>% 
    dplyr::group_by_at(data_set_key_cols(.))%>%
    dplyr::do(paired_models(.))%>%
    dplyr::do(loos_for_paired_models(.)) %>%
    dplyr::ungroup()
  
readr::write_csv(all_loos,OUTFILE)




