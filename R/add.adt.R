#' Add CITE-seq antibody-derived tags (ADT)
#'
#' This function takes a data frame of ADT values per cell and adds it to the scSeqR object.
#' @param x An object of class scSeqR.
#' @param adt.data A data frame containing ADT counts for cells.
#' @return An object of class scSeqR
#' @examples
#' \dontrun{
#' my.obj <- add.adt(my.obj, adt.data = adt.data)
#' }
#'
#' @export
add.adt <- function (x = NULL, adt.data = "data.frame") {
  if ("scSeqR" != class(x)[1]) {
    stop("x should be an object of class scSeqR")
  }
  if (class(adt.data) != "data.frame") {
    stop("ADT data should be a data frame object")
  }
  attributes(x)$adt.raw <- adt.data
  return(x)
}
