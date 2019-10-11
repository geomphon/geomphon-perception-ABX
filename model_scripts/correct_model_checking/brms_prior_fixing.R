library(brms)
EXPERIMENT <- "hindi" #
DATA_INST <- "dinst4" #
FORMULA <- "response_var ~ Econ + Glob + Loc + (1|subject)" #

corr_master<-readr::read_csv(paste0("corr_master_",
                                    EXPERIMENT,
                                    "_",
                                    DATA_INST,
                                    ".csv"))

brms_data1 <- readr::read_csv(paste0("../sampled_data/",corr_master$csv_filename[1]))


bform <- bf(response_var ~ a + b + c, nl = TRUE,
            lf(a ~ Econ + acoustic_distance , center = TRUE),
            lf(b ~ 0 + Glob, cmc = FALSE),
            lf(c ~ 0 + Loc, cmc = FALSE)
            )

priornl <- 
  prior(normal(0, 10), class = "b", nlpar = "a")+
  prior(normal(0, 10), lb = 0, class = "b", nlpar = "b")+
  prior(normal(0, 10), ub = 0, class = "b", nlpar = "c")


fit1 <- brm(bform,
            data = brms_data1,
            family = 'bernoulli',
            prior = priornl,
            iter = 1000,
            chains = 4,
            cores = 4)










prior1=c(set_prior("normal(0,10)", ub = 0, coef="Econ"),
        set_prior("normal(0,10)", lb = 0, coef="Glob"),
        set_prior("normal(0,10)", coef="Loc"))
prior(horseshoe(1), class = "b", nlpar = "a") + prior(normal(0, 1), class = "b", nlpar = "b")

fit1 <- brm(as.formula(FORMULA),
            data = brms_data1,
            family = 'bernoulli',
            prior = prior,
            iter = 100,
            chains = 4,
            cores = 4)




a_predictors <- "acoustic_distance" # will have regular prior 
b_predictors <- "Econ" # will have truncated pos prior 
c_predictors <- "Glob" # will have truncaged neg prior 
d_predictors <- "Loc" # will have horseshoe prior 

FORMULA <- bf(y ~ a + b + c, nl = TRUE) +
  lf(a ~ a_predictors, cmc = FALSE) +
  lf(b ~ 0 + b_predictors, cmc = FALSE) +
  lf(c ~ 0 + c_predictors, cmc = FALSE) + 
  lf(d ~ 0 + d_predictors, center = TRUE)




priornl <- 
  prior(normal(0, 10), class = "b", nlpar = "a_predictors")+
  prior(normal(0, 10), lb = 0, class = "b", nlpar = "b_predictors") +
  prior(normal(0, 10), ub = 0, class = "b", nlpar = "c_predictors") +
  prior(horseshoe(1), class = "b", nlpar = "d_predictors") 


fit1 <- brm(as.formula(FORMULA),
            data = brms_data1,
            #family = 'bernoulli',
            prior = priornl,
            iter = 100,
            chains = 4,
            cores = 4)

