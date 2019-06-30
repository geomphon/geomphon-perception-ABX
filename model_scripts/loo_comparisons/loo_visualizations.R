#loo graphs 

comp_df<-load("comp_df_hindi.RData")
hindi_kab_results<-load("comp_df_hindi_kab.Rdata")
hindi_pared_results<-readr::read_csv("hindi_results_pared_df.csv")

library(purrr)
library(data.table)



comp_hk <- data.frame(sapply(comp_df$comparison,c))
comp_hk<-as.data.frame(t(comp_hk))


comp_hindi <- data.frame(sapply(comp_df_hindi$comparison,c))
comp_hindi<-as.data.frame(t(comp_hindi))



par(mfrow = c(3,1))
hist(hindi_pared_results$elpd_diff,xlim=c(-30,30),ylim=c(0,200))
hist(comp_hk$elpd_diff, xlim =c(-30,30),ylim=c(0,200))
hist(comp_hindi$elpd_diff, xlim =c(-30,30),ylim=c(0,200))

hist(hindi_pared_results$se,xlim=c(0,10),ylim=c(0,100))
hist(comp_hk$se,xlim=c(0,10),ylim=c(0,100))
hist(comp_hindi$se,xlim=c(0,10),ylim=c(0,100))

thing <- subset(comp_hindi,comp_hindi$elpd_diff< -10)


# Harness the power of rbind list

dt <- rbindlist(dt_list, fill = TRUE)

library(ggplot2)
#just hindi graph
ggplot2::ggplot(data=hindi_results_df,aes(hindi_results_df$elpd_diff_list))+ 
  geom_histogram()