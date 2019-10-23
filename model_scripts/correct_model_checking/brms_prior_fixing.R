library(brms)
EXPERIMENT <- "hindi" #
DATA_INST <- "dinst4" #

corr_master<-readr::read_csv(paste0("corr_master_",
                                    EXPERIMENT,
                                    "_",
                                    DATA_INST,
                                    ".csv"))

brms_data1 <- readr::read_csv(paste0("../sampled_data/",corr_master$csv_filename[1]))


source("fn_build_brms_formula.R")

form1<- build_brms_formula(posvars = corr_master$m_pos_vars[1],
                           normvars = "acoustic_distance",
                           negvars = corr_master$m_neg_vars[1])


source("fn_build_brms_priors.R")
prior1<- build_brms_priors(posvars = corr_master$m_pos_vars[1],
                           normvars = "acoustic_distance",
                           negvars = corr_master$m_neg_vars[1])


mod1 = brms::brm(form1,
                  data = brms_data1,
                  family = 'bernoulli',
                  prior = prior1,
                  iter = 100,
                  chains = 4,
                  cores = 4
                )
