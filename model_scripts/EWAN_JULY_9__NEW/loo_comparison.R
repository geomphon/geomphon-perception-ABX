library(magrittr)

MODEL_CORRECT_COLUMN <- "is_correct_model"
MODEL_CORRECT_SUFFIX <- "_CORRECT"
MODEL_INCORRECT_SUFFIX <- "_INCORRECT"
EXPERIMENT_COLUMN <- "_d_experiment"
MODEL_FIT_SUBDIR <- "model_fits"

#' Title
#'
#' @param d 
#'
#' @return
#' @export
#'
#' @examples
#' 
data_set_key_cols <- function(d) {
  return(names(d)[startsWith(names(d), "_d_")])
}

#' Title
#'
#' @param d 
#'
#' @return
#' @export
#'
#' @examples
model_key_cols <- function(d) {
  return(names(d)[startsWith(names(d), "_m_")])
}

#' Title
#'
#' @param d 
#'
#' @return
#' @export
#'
#' @examples
experiment_subdir <- function(d) {
  return(d[,EXPERIMENT_COLUMN])
}

#' Title
#'
#' @param d 
#'
#' @return
#' @export
#'
#' @examples
sanitized_filename <- function(x) {
  x <- gsub(" ", "=", x)
  x <- gsub("/", ":", x)
  return(x)
}

#' Title
#'
#' @param d 
#' @param cols 
#'
#' @return
#' @export
#'
#' @examples
key <- function(d, cols) {
  values <- as.matrix(d[,cols])
  values[] <- vapply(values, sanitized_filename, character(1))
  return(apply(values, 1, paste, collapse="_"))
}

#' Title
#'
#' @param d 
#'
#' @return
#' @export
#'
#' @examples
data_set_key <- function(d) {
  key_cols <- data_set_key_cols(d)[!data_set_key_cols(d) == EXPERIMENT_COLUMN]
  return(key(d, key_cols))
}

#' Title
#'
#' @param d 
#'
#' @return
#' @export
#'
#' @examples
model_key <- function(d) {
  return(key(d, model_key_cols(d)))
}

#' Title
#'
#' @param d 
#'
#' @return
#' @export
#'
#' @examples
model_fit_filename <- function(d) {
  subdir <- apply(cbind(experiment_subdir(d), MODEL_FIT_SUBDIR), 1,
                  paste, collapse="/")
  fn <- paste(data_set_key(d), model_key(d), sep="_")
  return(paste(subdir, fn, sep="/"))
}


#' Title
#'
#' @param d 
#'
#' @return
#' @export
#'
#' @examples
paired_models <- function(models) {
  n_model_correct <- sum(models[[MODEL_CORRECT_COLUMN]])
  if (n_model_correct < 1) {
    warning("No correct models in model table")
    return(NULL)
  }
  if (n_model_correct > 1) {
    stop("More than one correct model in model table")
  }
  models_correct <- models %>% 
    dplyr::filter_at(MODEL_CORRECT_COLUMN, ~ .) %>%
    dplyr::rename_at(model_key_cols(.), ~ paste0(., MODEL_CORRECT_SUFFIX)) %>%
    dplyr::select(-!!MODEL_CORRECT_COLUMN)
  models_incorrect <- models %>% 
    dplyr::filter_at(MODEL_CORRECT_COLUMN, ~ !.) %>%
    dplyr::rename_at(model_key_cols(.), ~ paste0(., MODEL_INCORRECT_SUFFIX)) %>%
    dplyr::select(-!!MODEL_CORRECT_COLUMN)
  result <- dplyr::left_join(models_correct, models_incorrect,
                             by=data_set_key_cols(models))
  return(result)
}

#' Title
#'
#' @param d 
#'
#' @return
#' @export
#'
#' @examples
loos_for_paired_models <- function(paired_models) {
  pm_correct <- paired_models %>%
    dplyr::select_at(dplyr::vars(-dplyr::ends_with(MODEL_INCORRECT_SUFFIX))) %>%
    dplyr::rename_all(~ sub(paste0(MODEL_CORRECT_SUFFIX, "$"), "", .)) %>%
    dplyr::mutate(mffn=model_fit_filename(.))
  pm_incorrect <- paired_models %>%
    dplyr::select_at(dplyr::vars(-dplyr::ends_with(MODEL_CORRECT_SUFFIX))) %>%
    dplyr::rename_all(~ sub(paste0(MODEL_INCORRECT_SUFFIX, "$"), "", .)) %>%
    dplyr::mutate(mffn=model_fit_filename(.))
  model_fit_fns <- union(pm_correct$mffn, pm_incorrect$mffn)
  # --- DEBUG ---
  model_fit_fns <- sapply(model_fit_fns,
                  function (x)
                        sample(c("econ_-1_loc_-1_glob_0_mod_econ_glob_loc.rds",
                                 "econ_-1_loc_-1_glob_0_mod_econ.rds"), 1))
  # --- DEBUG ---
  mfs <- sapply(model_fit_fns, readRDS)
  paired_models$elpd_diff <- NA
  paired_models$se_diff <- NA
  for (i in 1:nrow(paired_models)) {
    loo_comparison <- loo::loo_compare(loo::loo(mfs[[pm_correct[["mffn"]][i]]]),
                                  loo::loo(mfs[[pm_incorrect[["mffn"]][i]]]))
    paired_models$elpd_diff <- loo_comparison[2,1]
    paired_models$se_diff <- loo_comparison[2,2]
  }
  rm(mfs) # Almost certainly not necessary
  return(paired_models)
}

all_fitted_models <- readr::read_csv("model_fits_hk.csv")
# --- DEBUG ---
all_fitted_models <- all_fitted_models[7:8,]
# --- DEBUG ---


loos <- all_fitted_models %>%
  dplyr::group_by_at(data_set_key_cols(.)) %>%
  dplyr::do(paired_models(.)) %>%
  dplyr::do(loos_for_paired_models(.)) %>%
  dplyr::ungroup()
  
  


