#comapre loos 

master_df<-readr::read_csv("master_df.csv")

#calculate which pairs are of interest 
correct_mods<-dplyr::filter(master_df, modelcorrect=="yes")
cor_mod_7<-correct_mods[rep(seq_len(nrow(correct_mods)), each=7),]
correct_model<-cor_mod_7$model_data_name
wrong_mods<-dplyr::filter(master_df,modelcorrect=="no")
wrong_model<-wrong_mods$model_data_name
mod_pairs<-cbind(wrong_model,correct_model)
mod_pairs<-as.data.frame(mod_pairs)


#get subset of pairs in mod pairs where both files exist
rds_list<- list.files("~/model_scripts/model_scripts/hindi_rds")
cor_list<-list()
wrong_list<-list()

for (i in 1:nrow(mod_pairs)){
  if ((paste0(mod_pairs$wrong_model[i],".rds") %in% rds_list) &
      (paste0(mod_pairs$correct_model[i],".rds") %in% rds_list)) {
          cor_list[i]<-paste(mod_pairs$correct_model[i])
          wrong_list[i]<-paste(mod_pairs$wrong_model[i])
  }
}

output_pairs<- cbind(cor_list,wrong_list)
output_pairs<-as.data.frame(output_pairs)

done_pairs<-dplyr::filter(output_pairs, output_pairs$cor_list!="NULL")
done_pairs$wrong_model<-done_pairs$wrong_list
done_pairs$correct_model<-done_pairs$cor_list



#calculate loos for remaining pairs. 
rds_folder<-"hindi_rds"

correct_model<-list()
wrong_model<-list() 
comparison<-list()


for (i in 1:nrow(done_pairs)) {
  wrong_mod<-readRDS(paste0(rds_folder,"/",done_pairs$wrong_model[i],".rds"))
  corr_mod<-readRDS(paste0(rds_folder,"/",done_pairs$correct_model[i],".rds"))
  loo_wrong<-loo::loo(wrong_mod)
  loo_corr<- loo::loo(corr_mod)
  comp<-loo::compare(loo_wrong,loo_corr)
  
  correct_model[i]<-paste0(rds_folder,"/",done_pairs$correct_model[i],".rds")
  wrong_model[i]<-paste0(rds_folder,"/",done_pairs$wrong_model[i],".rds")
  comparison[[i]]<-comp
}







#HINDI values
comparison<-comp_df_hindi$comparison

elpd_diff<-list()
se<-list()

for (i in 1:length(comparison)){
  elpd_diff[i]<-unname(comparison[[i]][1])
  se[i]<-unname(comparison[[i]][2])
}

hindi_results_df<-as.data.frame(cbind(elpd_diff,se))

write.csv(hindi_results_df,"hindi_results_df.csv")


#Hindi kab values 
comparison_hk<-comp_df$comparison

elpd_diff<-list()
se<-list()

for (i in 1:length(comparison_hk)){
  elpd_diff[i]<-unname(comparison_hk[[i]][1])
  se[i]<-unname(comparison_hk[[i]][2])
}

hindi_kab_results_df<-as.data.frame(cbind(elpd_diff,se))
write.csv(hindi_kab_results_df,"hindi_kab_results_df.csv")






