#generalized model comparison script 
#


EXPERIMENT_COLUMN <- "_d_experiment"


MODEL_CORRECT_SUFFIX <- "_CORRECT"
MODEL_INCORRECT_SUFFIX <- "_INCORRECT"
MODEL_FIT_SUBDIR <- "model_fits"



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



#' Select col names starting with "_d_"
#' 
#' an instane of key_cols(),returns the 
#'names of dataframe that start with "_d_", the data set columns for geomphon design
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
  return(names(d)[startsWith(names(d), "_d_")])
}



#' Select col names starting with "_m_"
#' 
#' an instane of key_cols(),returns the 
#'names of dataframe that start with "_m_", the model columns for geomphon design
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
  return(names(d)[startsWith(names(d), "_m_")])
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
  return(apply(values, 1, paste, collapse="_"))
}


#' Title
#'
#'takes a data frame with some columns that start with "_d_", 
#'identifies the data set columns with data_set_key_cols(),
#'removes the column with name EXPERIMENT COLUMN, assigns the result
#' to variable key_cols,
#' then applies key() to the given df d and columns key_cols, 
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
#'  returns those columns as a subset
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


