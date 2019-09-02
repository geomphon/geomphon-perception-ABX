#rename old files to new names to allow for loo comparisons 
#create master df based on new rules 

#should be in directory model_scripts

`%>%`<-magrittr::`%>%`
EXPERIMENT_NAME<- "hk"
DATA_INSTANCE <- "dinst1"
KEY_OUT_CSV <- "rds_new_key_hki.txt"
DATA_INSTANCE <- "dinst1"

MASTER_OUT_CSV <- paste0("master_df_",
                         EXPERIMENT_NAME,
                         "_",
                         DATA_INSTANCE,
                         ".csv")

create_masterdf<-"fn_create_masterdf_function_pos_neg.R"
source(create_masterdf)
master_df<- create_masterdf(vars=c("econ","glob","loc"),
                            coef_vals=c(-1,0,1),
                            exp_name= EXPERIMENT_NAME,
                            data_inst= DATA_INSTANCE)

readr::write_csv(master_df,MASTER_OUT_CSV)


#source mdoel_comparison functions, which include function for model fit filename
model_comparison_functions<-"fn_model_comparison_functions.R"
source(model_comparison_functions)

master_df$new_name<-model_fit_filename(master_df)

master_tibble<-tibble::as_tibble(master_df)

#create previous names based on legacy code 

mod_name<-
  dplyr::case_when(
    master_df$m_pos_vars =="Econ+Glob+Loc" ~  "econ_glob_loc",
    master_df$m_pos_vars =="Econ+Glob"~"econ_glob",
    master_df$m_pos_vars =="Econ+Loc"~ "econ_loc",
    master_df$m_pos_vars =="Glob+Loc"~ "glob_loc",
    master_df$m_pos_vars =="Econ"~"econ",
    master_df$m_pos_vars =="Glob"~"glob",
    master_df$m_pos_vars =="Loc"~"loc",
    master_df$m_pos_vars =="NA"~ "none")

master_df$old_name<-paste0(
                          "econ_",master_df$d_coef_econ,
                          "_loc_",master_df$d_coef_loc,
                          "_glob_",master_df$d_coef_glob,
                          "_mod_",mod_name,".rds")
rm(mod_name)

rds_name_key<-as.data.frame(cbind(master_df$old_name,master_df$new_name))

readr::write_tsv(rds_name_key,KEY_OUT_CSV, col_names = FALSE)

#excecute the follolwing in the terminal:
#while read line; do eval mv $line; done < hindi/hindi/model_fits/rds_name_key.txt


