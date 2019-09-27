#!/usr/bin/env Rscript

##########################
##### brms #####
##########################
ARGS <- commandArgs(TRUE)

EXPERIMENT <- ARGS[1] #"fake_grid"#"hindi"
DATA_INST <- ARGS[2] #"dinst1" #"dinst5"
FORMULA <- ARGS[3] #"response_var ~ Econ + Glob + Loc + (1|subject)"#

corr_master<-readr::read_csv(paste0("corr_master_",
                                    EXPERIMENT,
                                    "_",
                                    DATA_INST,
                                    ".csv"))

EXP_DATA_COMB <- paste0(EXPERIMENT,"_",DATA_INST)


library(brms)
model_fns <- "../fn_model_comparison_functions.R"
source(model_fns)

brms_mods <- vector(mode = "list")

for (i in c(1:nrow(corr_master))){
  out_file = paste0("correct_model_rds/",
                    model_fit_filename(corr_master[i,]))
  
  brms_data <- readr::read_csv(paste0("../sampled_data/",corr_master$csv_filename[i]))
  
  brms_mods[[i]] = brms::brm(
    as.formula(FORMULA),
    data = brms_data,
    family = 'bernoulli',
    prior = brms::set_prior('normal(0, 10)'),
    iter = 2000,
    chains = 4,
    cores = 4
  ) 
  saveRDS(brms_mods[[i]],file=out_file)
}


saved_brms_mod_list <-saveRDS(brms_mods, paste0("brms_mods_list_",EXP_DATA_COMB,".rds"))

