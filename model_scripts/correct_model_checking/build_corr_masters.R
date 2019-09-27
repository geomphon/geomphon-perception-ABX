### build full corr_masters 

`%>%` <- magrittr::`%>%`

# This script must be run for each data instance 
#NB fake grid does not have acoustic distance or item 

model_comps<-"../fn_model_comparison_functions.R"
source(model_comps)
#nb these functions must come first because they also have experiment settigns,
#and willoverwrite below variables if come after

EXPERIMENT <- "hindi"
DATA_INST <- "dinst2"

EXP_DATA_COMB <- paste0(EXPERIMENT,"_",DATA_INST)


######
#glm 
######
      master_df <-readr::read_csv(paste0("../master_df_",EXP_DATA_COMB,".csv"))
      
      corr_master <- subset(master_df, master_df$is_correct_model==TRUE)
      
      data_list <- vector(mode = "list")
      mod_list  <- vector(mode = "list")
      sum_list  <- vector(mode = "list")
      
      corr_master$Econ_coef_glm <-NA
      corr_master$Glob_coef_glm <-NA
      corr_master$Loc_coef_glm <-NA
      corr_master$ac_dist_coef_glm <-NA
      corr_master$acoustic_distance <- -.1784 #value of acoustic distance in sampled data
      
      
      for (i in 1:nrow(corr_master)) {
        data_list[[i]] <- readr::read_csv(paste0("../sampled_data/",corr_master$csv_filename[i]))

        mod_list[[i]] <- glm(response_var~Econ+Glob+Loc+acoustic_distance,
                             family=binomial(),
                             data = data_list[[i]])

        sum_list[[i]]<- summary(mod_list[[i]])

         corr_master$Econ_coef_glm[i]<-sum_list[[i]]$coefficients[2] #Econ
         corr_master$Glob_coef_glm[i]<-sum_list[[i]]$coefficients[3] #glob
         corr_master$Loc_coef_glm[i]<-sum_list[[i]]$coefficients[4] #Loc
         corr_master$ac_dist_coef_glm[i]<-sum_list[[i]]$coefficients[5] #acoustic_distance
      }
      
      
      corr_master<- 
          dplyr::mutate(corr_master,Econ_glm_diff = Econ_coef_glm-d_coef_econ) %>%
          dplyr::mutate(.,Glob_glm_diff = Glob_coef_glm-d_coef_glob) %>%
          dplyr::mutate(.,Loc_glm_diff = Loc_coef_glm-d_coef_loc) %>%
          dplyr::mutate(.,ac_dist_diff = ac_dist_coef_glm-acoustic_distance)
      
      
      
###########
#ASSUMING AT THIS POINT THAT BRMS HAVE BEEN RUN USING run_brms_mods.R
      
      
brms_fixef <- vector(mode = "list")
brms_mods  <- vector(mode = "list")
econ_post  <- vector(mode="list")
glob_post  <- vector(mode="list")
loc_post   <- vector(mode="list")
beta_post  <- vector(mode="list")
      
corr_master$intercept_brms_coef <- NA
corr_master$Econ_brms_coef      <-NA
corr_master$Glob_brms_coef      <-NA
corr_master$Loc_brms_coef       <-NA
corr_master$ac_dist_brms_coef   <-NA
      
corr_master$intercept_brms_rhat <-NA
corr_master$Econ_brms_rhat      <-NA
corr_master$Glob_brms_rhat      <-NA
corr_master$Loc_brms_rhat       <-NA
corr_master$ac_dist_brms_rhat   <-NA



for (i in 1:nrow(corr_master)){
    brms_mods[[i]] <- readRDS(paste0("correct_model_rds/",
                                     EXPERIMENT,
                                     "/",
                                     model_fit_filename(corr_master[i,])))
    
    brms_fixef[[i]] <- brms::fixef(brms_mods[[i]])

    corr_master$intercept_brms_coef[i]  <- brms_fixef[[i]][1,1] 
    corr_master$Econ_brms_coef[i]       <- brms_fixef[[i]][2,1] 
    corr_master$Glob_brms_coef[i]       <- brms_fixef[[i]][3,1] 
    corr_master$Loc_brms_coef[i]        <- brms_fixef[[i]][4,1] 
    corr_master$ac_dist_brms_coef[i]    <- brms_fixef[[i]][5,1] 
    
    corr_master$intercept_brms_rhat[i] <-   rhat(brms_mods[[i]])[[1]]
    corr_master$Econ_brms_rhat[i]      <-   rhat(brms_mods[[i]])[[2]]
    corr_master$Glob_brms_rhat[i]      <-   rhat(brms_mods[[i]])[[3]]
    corr_master$Loc_brms_rhat[i]       <-   rhat(brms_mods[[i]])[[4]]
    corr_master$ac_dist_brms_rhat[i]   <-   rhat(brms_mods[[i]])[[5]]
    
    beta_post[[i]] <- brms::posterior_samples(brms_mods[i], "^b")
    
    econ_post[[i]] <- beta_post[[i]][["b_Econ"]]
    glob_post[[i]] <- beta_post[[i]][["b_Glob"]]
    loc_post[[i]]  <- beta_post[[i]][["b_Loc"]]
    
    corr_master$econ_sd[i] <- sd(econ_post[[i]])
    corr_master$glob_sd[i] <- sd(glob_post[[i]])
    corr_master$loc_sd[i]  <- sd(glob_post[[i]])
      
    }
    

readr::write_csv(corr_master, paste0("final_corr_master_",EXP_DATA_COMB,".csv"))




