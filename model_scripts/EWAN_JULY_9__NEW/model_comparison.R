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
