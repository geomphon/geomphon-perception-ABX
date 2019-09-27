### build full corr_masters 

`%>%` <- magrittr::`%>%`

# This script must be run for each data instance 

EXP_DATA_COMB <- "fake_grid_dinst1" # e.g. hindi_dinst1",

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
      #corr_master$ac_dist_coef_glm <-NA
     # corr_master$acoustic_distance <- -.1784 #value of acoustic distance in sampled data
      
      
      for (i in 1:nrow(corr_master)) {
        data_list[[i]] <- readr::read_csv(paste0("../sampled_data/",corr_master$csv_filename[i]))

        mod_list[[i]] <- glm(response_var~Econ+Glob+Loc,#+acoustic_distance,
                             family=binomial(),
                             data = data_list[[i]])

        sum_list[[i]]<- summary(mod_list[[i]])

         corr_master$Econ_coef_glm[i]<-sum_list[[i]]$coefficients[2] #Econ
         corr_master$Glob_coef_glm[i]<-sum_list[[i]]$coefficients[3] #glob
         corr_master$Loc_coef_glm[i]<-sum_list[[i]]$coefficients[4] #Loc
        # corr_master$ac_dist_coef_glm[i]<-sum_list[[i]]$coefficients[5] #acoustic_distance
      }
      
      
      corr_master<- 
          dplyr::mutate(corr_master,Econ_glm_diff = Econ_coef_glm-d_coef_econ) %>%
          dplyr::mutate(.,Glob_glm_diff = Glob_coef_glm-d_coef_glob) %>%
          dplyr::mutate(.,Loc_glm_diff = Loc_coef_glm-d_coef_loc)# %>%
         # dplyr::mutate(.,ac_dist_diff = ac_dist_coef_glm-acoustic_distance)
      
    
      readr::write_csv(corr_master, paste0("corr_master_",EXP_DATA_COMB,".csv"))
      
      
###########
#ASSUMING AT THIS POINT THAT BRMS HAVE BEEN RUN USING run_brms_mods.R
      
      brms_fixef <-vector(mode = "list")
      
      corr_master$intercept_brms_coef <- NA
      corr_master$Econ_brms_coef <-NA
      corr_master$Glob_brms_coef <-NA
      corr_master$Loc_brms_coef <-NA
     # corr_master$ac_dist_brms_coef <-NA
      
      corr_master$intercept_brms_rhat <- NA
      corr_master$Econ_brms_rhat <-NA
      corr_master$Glob_brms_rhat <-NA
      corr_master$Loc_brms_rhat <-NA
      #corr_master$ac_dist_brms_rhat <-NA
    
      #corr_master$loo <-NA
      
      
      
for (i in 1:nrow(corr_master)){
  
    brms_fixef[[i]] <- brms::fixef(brms_mods[[i]])

    corr_master$intercept_brms_coef[i]  <- brms_fixef[[i]][1,1] 
    corr_master$Econ_brms_coef[i]       <- brms_fixef[[i]][2,1] 
    corr_master$Glob_brms_coef[i]       <- brms_fixef[[i]][3,1] 
    corr_master$Loc_brms_coef[i]        <- brms_fixef[[i]][4,1] 
    #corr_master$ac_dist_brms_coef[i]    <- brms_fixef[[i]][5,1] 
    
    corr_master$intercept_brms_rhat[i] <-   rhat(brms_mods[[i]])[[1]]
    corr_master$Econ_brms_rhat[i]      <-   rhat(brms_mods[[i]])[[2]]
    corr_master$Glob_brms_rhat[i]      <-   rhat(brms_mods[[i]])[[3]]
    corr_master$Loc_brms_rhat[i]       <-   rhat(brms_mods[[i]])[[4]]
   # corr_master$ac_dist_brms_rhat[i]   <-   rhat(brms_mods[[i]])[[5]]
    
    }
      

readr::write_csv(corr_master, paste0("final_corr_master_",EXP_DATA_COMB,".csv"))



      


