


hindi_dinst1<-readr::read_csv("final_corr_master_hindi_dinst1.csv")
  hindi_dinst1$numsubjs<-30
hindi_dinst2<-readr::read_csv("final_corr_master_hindi_dinst2.csv")
  hindi_dinst2$numsubjs<-30
hindi_dinst3<-readr::read_csv("final_corr_master_hindi_dinst3.csv")
  hindi_dinst3$numsubjs<-60
hindi_dinst4<-readr::read_csv("final_corr_master_hindi_dinst4.csv")
  hindi_dinst4$numsubjs <- 90
hindi_dinst5<-readr::read_csv("final_corr_master_hindi_dinst5.csv")
  hindi_dinst5$numsubjs<- 10
#hindi_dinst6<-readr::read_csv("corr_master_hindi_dinst6.csv")
#  hindi_dinst6$numsubjs<- 1000

  #skipping 1 so that have equal numbers of each 
hindi_for_hists<-dplyr::bind_rows(hindi_dinst2,
                                  hindi_dinst3,
                                  hindi_dinst4,
                                  hindi_dinst5) 

                                  #hindi_dinst6)


Econ_hist <- ggplot2::ggplot(hindi_for_hists, ggplot2::aes(x = Econ_glm_diff)) +
             ggplot2::geom_histogram(binwidth = .1,
                                     position="identity",
                                     alpha = 0.4)+
             ggplot2::scale_x_continuous(limits = c(-10,10))+
             ggplot2::ggtitle("Econ coef differenece,hindi data,
                              calculated by glm, by number of subjects")+
             ggplot2::facet_grid(numsubjs ~ .)
Econ_hist


Glob_hist <- ggplot2::ggplot(hindi_for_hists, ggplot2::aes(x = Glob_glm_diff)) +
             ggplot2::geom_histogram(binwidth = .1,
                                     position="identity",
                                     alpha = 0.4)+
             ggplot2::scale_x_continuous(limits = c(-10,10))+
             ggplot2::ggtitle("Glob coef differenece, hindi data, 
                              calculated by glm, by number of subjects")+
             ggplot2::facet_grid(numsubjs ~ .)
Glob_hist

Loc_hist <- ggplot2::ggplot(hindi_for_hists, ggplot2::aes(x = Loc_glm_diff)) +
            ggplot2::geom_histogram(binwidth = .1,
                                    position="identity",
                                    alpha = 0.4)+
            ggplot2::scale_x_continuous(limits = c(-10,10))+
            ggplot2::ggtitle("Loc coef differenece, hindi data,
                             calculated by glm, by number of subjects")+
            ggplot2::facet_grid(numsubjs ~ .)
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


Econ_hist <-ggplot2::ggplot(fake_grid_for_hists, aes(x = Econ_glm_diff)) +
            ggplot2::geom_histogram(binwidth = .1,position="identity", alpha = 0.4)+
            ggplot2::scale_x_continuous(limits = c(-10,10))+
            ggplot2::ggtitle("Econ coef differenece,fake grid data,calculated by glm, by number of subjects")+
            ggplot2::facet_grid(numsubjs ~ .)
Econ_hist

Glob_hist <-ggplot2::ggplot(fake_grid_for_hists, aes(x = Glob_glm_diff)) +
            ggplot2::geom_histogram(binwidth = .1,position="identity", alpha = 0.4)+
            ggplot2::scale_x_continuous(limits = c(-10,10))+
            ggplot2::ggtitle("Glob coef differenece, fake grid data, calculated by glm, by number of subjects")+
            ggplot2::facet_grid(numsubjs ~ .)
Glob_hist

Loc_hist <- ggplot2::ggplot(fake_grid_for_hists, ggplot2::aes(x = Loc_glm_diff)) +
            ggplot2::geom_histogram(binwidth = .1,position="identity", alpha = 0.4)+
            ggplot2::scale_x_continuous(limits = c(-10,10))+
            ggplot2::ggtitle("Loc coef differenece, fake grid data,calculated by glm, by number of subjects")+
            ggplot2::facet_grid(numsubjs ~ .)
Loc_hist


#inspect the loc scores- are they wonky? 

# if we take out loc, can we extract the coeffs better / with fewer subjects? 






