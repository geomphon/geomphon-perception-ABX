
#' run and save a brms mod 
#' 
#' @param brmsdat
#' @param form_prior a list the output of fn_build_brms_formula_and_priors.R
#' @param posvars a string or vector of strings, predictors to be truncated positive
#' @param negvars a string or vector of strings,predictors to be truncated negative
#' @param normvars a string or vector of strings, predictors to apply a not truncated N(0,10) prior 
#' @param chains 
#' @param iterations 
#' @param seed 
#' @param output_filename 
#' 
#' @return 

brmfit <- brm(bform,
              data = brms_data1,
              family = 'bernoulli',
              prior = form_prior[[,2]],
              iter = 100,
              chains = 4,
              seed = 2,
              cores = 4)

saveRDS(brmfit, file=brms_function_test.rds)



brms_dat <- brms_data1
iterations = 100
chains = 4
seed = 72 
output_filename = "working.rds"

posvars <- "Glob"
negvars <- NULL
normvars <- "Loc"

