#generalized model comparison script 
#


library(magrittr)

#likely to change
EXPERIMENT<-"hk"
DATA_SUBDIR<-"sampled_data"
RDS_FOLDER <- "model_output_rds"



EXPERIMENT_COLUMN <- "d_experiment"
MODEL_CORRECT_COLUMN <- "is_correct_model"
MODEL_CORRECT_SUFFIX <- "_CORRECT"
MODEL_INCORRECT_SUFFIX <- "_INCORRECT"




#' Select key col names 
#' 
#' given a df and a key string,returns the 
#'names of dataframe that start with a certain character
#'
#'
#' @param d a data frame 
#' 
#' @param string_key string which starts names of data set columns to be selected
#'
#' @return returns vector of strings, the neames of the data set 
#'       columns that match the key
#' 
#' @export
#'
#' @examples
#' key_cols(cars,"d")
#' 
#' 
key_cols <- function(d, string_key) {
  return(names(d)[startsWith(names(d), string_key)])
}



#' Select col names starting with "d_"
#' 
#' an instane of key_cols(),returns the 
#'names of dataframe that start with "d_", the data set columns for geomphon design
#'
#'
#' @param d a data frame 
#' 
#' @return returns vector of strings, the neames of the data set 
#'       columns that match the key. If no columns match, returns character(0)
#' 
#' @export
#'
#' @examples
#' data_set_key_cols(cars)
#' 
#'
data_set_key_cols <- function(d) {
  return(names(d)[startsWith(names(d), "d_")])
}



#' Select col names starting with "m_"
#' 
#' an instane of key_cols(),returns the 
#'names of dataframe that start with "m_", the model columns for geomphon design
#'
#'
#' @param d a data frame 
#' 
#' @return returns vector of strings, the neames of the data set 
#'       columns that match the key. If no columns match, returns character(0)
#' 
#' @export
#'
#' @examples
#' data_set_key_cols(cars)
#' 
#'
model_key_cols <- function(d) {
  return(names(d)[startsWith(names(d), "m_")])
}


#' Title
#'
#' @param d a data frame containing a column saved in variable EXPERIMENT_COLUMN
#'
#' @return returns a tibble of EXPERIMENT_COLUMN, in this case a df containing 1
#' col of strings 
#' 
#' @export
#'
#' @examples
experiment_subdir <- function(d) {
  return(d[,EXPERIMENT_COLUMN])
}


#' replace spaces and slashes
#'
#' @param x a string, vector of strings, or data frame of strings
#'
#' @return returns an object of the same type as the input 
#' with all blank space characters replaced with "=" and all "/" 
#' replaced with ":"
#' 
#' @export
#'
#' @examples
#' 
sanitized_filename <- function(x) {
  x <- gsub(" ", "=", x)
  x <- gsub("/", ":", x)
  return(x)
}


#' Title
#'
#' @param d  a data frame 
#' takes the subset of columns of interest, 
#' turns into a matrix, 
#' applies sanitize_filename() to replace " " with "=" and "/" with ":", 
#' then collapses values in first column, pasteing them together with "_"
#' 
#' @param cols a vector of strings, the name of columns present in d
#'
#' @return 
#' 
#' @export
#'
#' @examples
key <- function(d, cols) {
  values <- as.matrix(d[,cols])
  values[] <- vapply(values, sanitized_filename, character(1))
  return(apply(values, 1, paste, collapse="__"))
}






#' Title
#'
#'takes a data frame with some columns that start with "d_", 
#'identifies the data set columns with data_set_key_cols(),
#'removes the column with name EXPERIMENT COLUMN, assigns the result
#' to variable key_cols,
#'then applies key() to the given df d and columns key_cols, 
#' returning the subset of columns with filenames sanitized and collapsed
#' 
#'
#'
#' @param d a data frame
#' 
#' @return a dataframe, a subset of d reformatted with key()
#' 
#' @export
#'
#' @examples
data_set_key <- function(d) {
  key_cols <- data_set_key_cols(d)[!data_set_key_cols(d) == EXPERIMENT_COLUMN]
  return(key(d, key_cols))
}


#' Title
#' given dataframe d, selects columns identified by the name,
#'  returns those columns as a dataframe
#'
#' @param d a dataframe
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
#' given a dataframe, create a filename that specifies the model fit including
#' information from the data columns and the model columns, as well as the 
#' subdirectory name that specifies the design
#'
#' @param d a data frame with data set and model values
#'
#' @return returns a vector strings, the model fit filenames 
#' 
#' @export
#'
#' @examples
#' design<-readr::read_csv("model_fits_hk.csv")
#' model_fit_filename(design)
#' 
#' ###ORIGINAL
#' 
#' 
        # model_fit_filename <- function(d) {
        #   subdir <- apply(cbind(experiment_subdir(d), MODEL_FIT_SUBDIR), 1,
        #                   paste, collapse="/")
        #   fn <- paste0(data_set_key(d),"__",model_key(d),".rds")   
        #   return(paste(EXPERIMENT,MODEL_FIT_SUBDIR, fn, sep="/"))
        # }

##
#NEW VERSION
model_fit_filename <- function(d) {
  fn <- paste0(data_set_key(d),"__",model_key(d),".rds")   
  return(fn)
}



#' Title
#' 
#' given a dataframe, create a filename that specifies the model fit including
#' information from the data columns and the model columns, as well as the 
#' subdirectory name that specifies the design
#'
#' @param d a data frame with data set  values
#'
#' @return returns a vector strings, the data set filenames
#' 
#' @export
#'
#' @examples
#' 
data_set_filename <- function(d) {
  subdir <- apply(cbind(experiment_subdir(d), DATA_SUBDIR), 1,
                  paste, collapse="/")
  fn <- paste(data_set_key(d))
  return(paste(subdir, fn, sep="/"))
}



#' Get Paired Models
#' This groups the full design table based on the dataset to arrive at a subset
#' of 8 models, one of which is correct. 
#' It throws an error if in this subset there are no models labeled as correct, 
#' or if there is more than one that is labelled correct
#' Then it creates a df of paired models, with each incorrect model being 
#' compared to the correct one.
#'
#' @param models a data frame containing all the models for one dataset
#'
#' @return a data frame containing pairs of models, and including all the 
#' modelfit info
#' 
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




#'robust_readRDS

#' a wrapper for readRDS that reads the rds if it exists, or returns NULL
#'  if it does not 
#' 
#'
#' @param rds_filename
#' @param RDS_FOLDER
#' 
#

robust_readRDS <- function(rds_filename,RDS_FOLDER) { 
  
  #FIXME hardcoded folder name
  
  filelist = list.files(paste0("model_output_rds","/",EXPERIMENT))
  
  if (rds_filename %in% filelist) {
    rds <- readRDS(paste0(RDS_FOLDER,"/",EXPERIMENT, "/",rds_filename))
  }else{
    rds <-NULL
  }
  return(rds)
  
}


#'robust_loo

#' a wrapper for loo that does the loo if the model exists, or returns "NULL"
#'  if it does not 
#' 
#'
#' @param model 
#' @return 
#


robust_loo <- function(model){ 
  
  if (is.null(model)){
    output <- NULL
  }else{
    output <- loo::loo(model)
  }
  return(output)
}


#'robust_loo_comp

#' a wrapper for loo_compare that does the comparison if the models exist,
#'  or returns "NULL" if either does not
#'  if it does not 
#' 
#' @param model1
#' @param  model2
#' @return 
#


robust_loo_comp <- function(model1,model2){ 
  
  if (is.null(model1)|is.null(model2)){
    output <- NULL
  }else{
    output <-loo::loo_compare(model1,model2)
  }
  return(output)
}


#' Title
#' for a dataframe of paired models, runs the loo comparisons of interest 
#' and then returns the elpd_diff and se for the pairs in new columns added to 
#' the same dataframe
#'
#' @param  paired_models a dataframe of paired models 
#'
#' @return the same dataframe, with added columns for elpd_diff and se
#' @export
#'
#' @examples


loos_for_paired_models <- function(paired_models) {
  
  pm_correct <-  paired_models %>%
    dplyr::select_at(dplyr::vars(-dplyr::ends_with(MODEL_INCORRECT_SUFFIX))) %>%
    dplyr::rename_all(~ sub(paste0(MODEL_CORRECT_SUFFIX, "$"), "", .))%>%
    dplyr::mutate(mffn= model_fit_filename(.))
  
 
  pm_incorrect <- paired_models %>%
    dplyr::select_at(dplyr::vars(-dplyr::ends_with(MODEL_CORRECT_SUFFIX))) %>%
    dplyr::rename_all(~ sub(paste0(MODEL_INCORRECT_SUFFIX, "$"), "", .)) %>%
    dplyr::mutate(mffn= model_fit_filename(.))
  
  
  model_fit_fns <- union(pm_correct$mffn, pm_incorrect$mffn)


    
    mfs <- sapply(X = model_fit_fns,
                  FUN = robust_readRDS,
                  RDS_FOLDER = "model_output_rds"
    )
    
  
  paired_models$elpd_diff <- NA
  paired_models$se_diff <- NA

      for (i in 1:nrow(paired_models)) {
        loo_comparison <- robust_loo_comp(robust_loo(mfs[[pm_correct[["mffn"]][i]]]),
                                           robust_loo(mfs[[pm_incorrect[["mffn"]][i]]]))
        if (is.null(loo_comparison)){
          paired_models$elpd_diff[i] <- NA
          paired_models$se_diff[i] <-NA
        } else{
              if (rownames(loo_comparison)[1] != "model2") {
                paired_models$elpd_diff[i] <- loo_comparison[2,1]
                paired_models$se_diff[i] <- loo_comparison[2,2]
              } else{
                paired_models$elpd_diff[i] <- -(loo_comparison[2,1])
                paired_models$se_diff[i] <- loo_comparison[2,2]
              }
        }

      }
  return(paired_models)
}


