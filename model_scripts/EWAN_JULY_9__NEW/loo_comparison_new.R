
####################
#do loo comparisons
#last edit by Amelia July 23
#################

#in directory EWAN_JULY_9_NEW
model_comparison_functions<-"model_comparison_functions.R"
source(model_comparison_functions)


##NB!!! 
#### NAs must be input as empty here, not as NA, so that NAs are not populated
#### in model fit names and don't match the .rds files. 
#### thus, read.csv rather than readr::read_csv, which adds NAs for empty cells
all_fitted_models <- read.csv("master_df_hindi_new.csv")

#-------------DEBUG
all_fitted_models <- all_fitted_models[1:8,] 



all_loos <- all_fitted_models %>% #loos
  dplyr::group_by_at(data_set_key_cols(.))%>%
dplyr::do(paired_models(.)) # %>%
#   dplyr::do(loos_for_paired_models(.)) %>%
#   dplyr::ungroup()
  
##-----------UNDEBUG

  pm_correct <-  all_loos %>%
    dplyr::select_at(dplyr::vars(-dplyr::ends_with(MODEL_INCORRECT_SUFFIX))) %>%
    dplyr::rename_all(~ sub(paste0(MODEL_CORRECT_SUFFIX, "$"), "", .))%>%
    dplyr::mutate(mffn=model_fit_filename(.))
  
  pm_incorrect <- all_loos %>%
    dplyr::select_at(dplyr::vars(-dplyr::ends_with(MODEL_CORRECT_SUFFIX))) %>%
    dplyr::rename_all(~ sub(paste0(MODEL_INCORRECT_SUFFIX, "$"), "", .)) %>%
    dplyr::mutate(mffn=model_fit_filename(.))
  
  model_fit_fns <- union(pm_correct$mffn, pm_incorrect$mffn)
  mfs <- sapply(model_fit_fns, readRDS) 

