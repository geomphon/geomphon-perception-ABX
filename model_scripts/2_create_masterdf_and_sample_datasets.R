#!/usr/bin/env Rscript
#last edit June 27 2019 by Amelia


`%>%`<-magrittr::`%>%`
EXPERIMENT_NAME<- "hk"
DATA_INSTANCE <- "dinst1"
MASTER_OUT_CSV <- "EWAN_JULY_9__NEW/master_df_hk.csv"

DATA_SUB_FOLDER <- "sampled_data/hk_144"
DESIGN_CSV<- "exp_designs/exp_design_hk_144.csv"
NUM_TRIALS = 144
NUM_SUBJS = 30 



##################
#create master df#
##################
create_masterdf<-"create_masterdf_function_pos_neg.R"
source(create_masterdf)
master_df<- create_masterdf(vars=c("econ","glob","loc"),
                            coef_vals=c(-1,0,1),
                            exp_name= EXPERIMENT_NAME,
                            data_inst= DATA_INSTANCE)
                            

readr::write_csv(master_df, path=MASTER_OUT_CSV)




####################
#create csv dataset#
####################
design_df <- readr::read_csv(DESIGN_CSV)

colnames(design_df)[colnames(design_df)=="Acoustic distance"] <- "acoustic_distance"




subjs<- c()
for (i in 1:NUM_SUBJS) {
    subjs[i] = paste("subject",i,sep = "_")
}

trials <- c()
for (i in 1:NUM_TRIALS) {
  trials[i] = paste("trial",i,sep = "_")
}

subs_trials <- expand.grid(subjs, trials)
names(subs_trials)<-c("subject","trial")

#THE BELOW IS JUST a dumb way to do rep_len for a df
rep_design<- design_df[rep(seq_len(nrow(design_df)), 100), ]
rep_design <- rep_design[1:(NUM_SUBJS*NUM_TRIALS),
                         c('Phone_NOTENG','Phone_ENG', 'Econ','Loc','Glob','acoustic_distance')]


response_var <-c(sample(c(0,1), nrow(rep_design), replace = TRUE))
#Nb these responses are dummy responses for the moment,but must exist 
#for the sampling function 

full_design <- as.data.frame(cbind(subs_trials,rep_design,response_var))


######################
#sample data and save#
######################
sample_binary_four<-"sample_binary_four_function.R"
source(sample_binary_four)

coef_dist <- -.1784  #effect of acoustic distance. taken from pilot data 
uniq_filenames <- unique(master_df$csv_filename)

for (i in 1:length(uniq_filenames)){
  
  data_i <- sample_binary_four(d = full_design,
                              response_var = "response_var",
                              predictor_vars = c("Econ",
                                                 "Glob",
                                                 "Loc",
                                                 "acoustic_distance"),
                              coef_values = c(master_df$coef_econ[i],
                                              master_df$coef_glob[i],
                                              master_df$coef_loc[i],
                                              coef_dist),
                              intercept = 1.3592
                              )
    readr::write_csv(data_i,path = paste0(DATA_SUB_FOLDER,"/",uniq_filenames[i]))
}





