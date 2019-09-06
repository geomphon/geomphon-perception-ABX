#!/usr/bin/env Rscript

# using sampled .csv datafile and model parameters taken from master_df
# make standats, save them, and then run the models 
# Author: Ameila Kimball

#ARGS <- commandArgs(TRUE)

DATA_FOLDER <- "sampled_data" #ARGS[1]#
MASTER <-  "master_df_hk_dinst2.csv" #ARGS[2] #
RDS_FOLDER<-"model_output_rds"#  ARGS[3] #
EXPERIMENT<-"hk" #ARGS[4] #

BATCH_SIZE <- 2



model_comps<-"fn_model_comparison_functions.R"
source(model_comps)

create_standat<-"fn_create_standat_function_pos_neg.R"
source(create_standat)




################
#CREATE STANDAT#
################
master_df<-readr::read_csv(MASTER)
master_df$standat_h<- vector(mode="list", length=nrow(master_df))
master_df$hk<- NA


for (i in 1:nrow(master_df)) {
  master_df$standat_h[[i]] <-
     create_standat(data_file=paste(DATA_FOLDER,
                                    master_df$csv_filename[i],
                                    sep="/"),
                    pos_vars= master_df$m_pos_vars[i],
                    neg_vars= master_df$m_neg_vars[i])
                                       
  master_df$hk[i] <- paste(DATA_FOLDER,
                               master_df$csv_filename[i],
                               sep ="/")
                            }

######################
#fit  and save models#
######################
library(rstan)
library(doParallel)
#library(doMC)
options(cores=8) #ceiling number of cores to use total
options(mc.cores = 4)#cores per model (= should equal numb of chains) 
registerDoParallel(cores=4)
fit_save_stan_mod <- "fn_fit_save_stan_mod_function.R"
source(fit_save_stan_mod)

#batchname 

batch_starts <- seq(1, nrow(master_df) - 1, BATCH_SIZE)

# batchlist<- list( c(1:5),
#                   c(6:10),
#                   c(11:15),
#                   c(16:20),
#                   c(21:25),
#                   c(26:30),
#                   c(31:35),
#                   c(36:40),
#                   c(41:45),
#                   c(46:50),
#                   c(51:55),
#                   c(56:60),
#                   c(61:65),
#                   c(66:70),
#                   c(71:75),
#                   c(76:80),
#                   c(81:85),
#                   c(86:90),
#                   c(91:95),
#                   c(96:100))
#                   c(101:105),
#                   c(106:110),
#                   c(111:115),
#                   c(116:120),
#                   c(121:125),
#                   c(126:130),
#                   c(131:135),
#                   c(136:140),
#                   c(141:145),
#                   c(146:150),
#                   c(151:155),
#                   c(156:160),
#                   c(161:165),
#                   c(166:170),
#                   c(171:175),
#                   c(176:180),
#                   c(181:185),
#                   c(186:190),
#                   c(191:195),
#                   c(196:200),
#                   c(201:205),
#                   c(206:210),
#                   c(211:216))


filelist = list.files(paste(RDS_FOLDER,EXPERIMENT,sep="/"))


for (batch_start in batch_starts){

    foreach(i=batch_start:(batch_start+BATCH_SIZE)) %dopar% {
          
            filename = model_fit_filename(master_df[i,])
          
            out_file = paste0(RDS_FOLDER,
                           "/",
                           EXPERIMENT,
                           "/",
                           model_fit_filename(master_df[i,])
                           )
          
              if (!filename %in% filelist){
                    fit_save_stan_mod(stan_model_filename = master_df$m_stanfile[i],
                                    standat             = master_df$standat_h[[i]],
                                    chains              = 4,
                                    iter                = 2000,
                                    seed                = master_df$seed[i],
                                    output_filename     = out_file)
                    } else {
                print(paste(filename,"already exists, model skipped",sep=" "))
                }
         }
}






