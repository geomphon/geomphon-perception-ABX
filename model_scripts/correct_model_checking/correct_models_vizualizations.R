


hindi_dinst1<-readr::read_csv("corr_master_hindi_dinst1.csv")
  hindi_dinst1$numsubjs<-30
hindi_dinst2<-readr::read_csv("corr_master_hindi_dinst2.csv")
  hindi_dinst2$numsubjs<-30
hindi_dinst3<-readr::read_csv("corr_master_hindi_dinst3.csv")
  hindi_dinst3$numsubjs<-60
hindi_dinst4<-readr::read_csv("corr_master_hindi_dinst4.csv")
  hindi_dinst4$numsubjs <- 90
hindi_dinst5<-readr::read_csv("corr_master_hindi_dinst5.csv")
  hindi_dinst5$numsubjs<- 10
hindi_dinst6<-readr::read_csv("corr_master_hindi_dinst6.csv")
  hindi_dinst6$numsubjs<- 1000

  #skipping 2 so that have equal numbers of each 
hindi_for_hists<-dplyr::bind_rows(hindi_dinst1,
                                  hindi_dinst3,
                                  hindi_dinst4,
                                  hindi_dinst5,
                                  hindi_dinst6)



Econ_hist <- ggplot2::ggplot(hindi_for_hists, aes(x = Econ_glm_diff)) +
  geom_histogram(binwidth = .1,position="identity", alpha = 0.4)+
  scale_x_continuous(limits = c(-6,6))+
  ggtitle("Econ coef differenece,hindi data,calculated by glm, by number of subjects")+
  facet_grid(numsubjs ~ .)
Econ_hist


Glob_hist <- ggplot2::ggplot(hindi_for_hists, aes(x = Glob_glm_diff)) +
  geom_histogram(binwidth = .1,position="identity", alpha = 0.4)+
  scale_x_continuous(limits = c(-6,6))+
  ggtitle("Glob coef differenece, hindi data, calculated by glm, by number of subjects")+
  facet_grid(numsubjs ~ .)
Glob_hist

Loc_hist <- ggplot2::ggplot(hindi_for_hists, aes(x = Loc_glm_diff)) +
  geom_histogram(binwidth = .1,position="identity", alpha = 0.4)+
  scale_x_continuous(limits = c(-6,6))+
  ggtitle("Loc coef differenece, hindi data,calculated by glm, by number of subjects")+
  facet_grid(numsubjs ~ .)
Loc_hist



fake_grid_dinst1<-readr::read_csv("corr_master_fake_grid_dinst1.csv")
    fake_grid_dinst1$numsubjs  <-30
fake_grid_dinst2<-readr::read_csv("corr_master_fake_grid_dinst2.csv")
    fake_grid_dinst2$numsubjs  <-60
fake_grid_dinst3<-readr::read_csv("corr_master_fake_grid_dinst3.csv")
    fake_grid_dinst3$numsubjs  <-90
fake_grid_dinst4<-readr::read_csv("corr_master_fake_grid_dinst4.csv")
    fake_grid_dinst4$numsubjs <- 10
fake_grid_dinst5<-readr::read_csv("corr_master_fake_grid_dinst5.csv")
    fake_grid_dinst5$numsubjs <- 1000

fake_grid_for_hists<-dplyr::bind_rows(fake_grid_dinst1,
                                      fake_grid_dinst2,
                                      fake_grid_dinst3,
                                      fake_grid_dinst4,
                                      fake_grid_dinst5)



Econ_hist <- ggplot2::ggplot(fake_grid_for_hists, aes(x = Econ_glm_diff)) +
  geom_histogram(binwidth = .1,position="identity", alpha = 0.4)+
  scale_x_continuous(limits = c(-6,6))+
  ggtitle("Econ coef differenece,fake grid data,calculated by glm, by number of subjects")+
  facet_grid(numsubjs ~ .)
Econ_hist


Glob_hist <- ggplot2::ggplot(fake_grid_for_hists, aes(x = Glob_glm_diff)) +
  geom_histogram(binwidth = .1,position="identity", alpha = 0.4)+
  scale_x_continuous(limits = c(-6,6))+
  ggtitle("Glob coef differenece, fake grid data, calculated by glm, by number of subjects")+
  facet_grid(numsubjs ~ .)
Glob_hist

Loc_hist <- ggplot2::ggplot(fake_grid_for_hists, aes(x = Loc_glm_diff)) +
  geom_histogram(binwidth = .1,position="identity", alpha = 0.4)+
  scale_x_continuous(limits = c(-6,6))+
  ggtitle("Loc coef differenece, fake grid data,calculated by glm, by number of subjects")+
  facet_grid(numsubjs ~ .)
Loc_hist
















par(mfrow=c(3,1))

hindi_dinst1<- 
  dplyr::mutate(hindi_dinst1,Econ_brms_diff = Econ_brms_coef-d_coef_econ) %>%
  dplyr::mutate(.,Glob_brms_diff = Glob_brms_coef-d_coef_glob) %>%
  dplyr::mutate(.,Loc_brms_diff = Loc_brms_coef-d_coef_loc)



Glob_hist <- ggplot2::ggplot(all_hindi, aes(x = Glob_brms_diff, fill = d_id)) +
  geom_histogram()+
  scale_x_continuous(limits = c(-6,6))+
  ggtitle("Glob_Brms_difference")
Glob_hist


Loc_hist <- ggplot2::ggplot(all_hindi, aes(x = Loc_brms_diff, fill = d_id)) +
  geom_histogram()+
  scale_x_continuous(limits = c(-6,6))+
  ggtitle("Loc_Brms_difference")
Loc_hist







hk_dinst2<-readr::read_csv("corr_master_hk_dinst2.csv")



hk_dinst2<- 
  dplyr::mutate(hk_dinst2,Econ_brms_diff = Econ_brms_coef-d_coef_econ) %>%
  dplyr::mutate(.,Glob_brms_diff = Glob_brms_coef-d_coef_glob) %>%
  dplyr::mutate(.,Loc_brms_diff = Loc_brms_coef-d_coef_loc)

hist(hk_dinst2$Econ_glm_diff, main= "hk_dinst2_glm_Econ_diff", xlim =c(-10,10))
hist(hk_dinst2$Glob_glm_diff,main= "hk_dinst2_glm_Glob_diff", xlim =c(-10,10))
hist(hk_dinst2$Loc_glm_diff,main= "hhk_dinst2_glm_Loc_diff", xlim =c(-10,10))

hist(hk_dinst2$Econ_brms_diff, main= "hk_dinst2_brms_Econ_diff", xlim =c(-10,10))
hist(hk_dinst2$Glob_brms_diff,main= "hk_dinst2_brms_Glob_diff", xlim =c(-10,10))
hist(hk_dinst2$Loc_brms_diff,main= "hk_dinst2_brms_Loc_diff", xlim =c(-10,10))







