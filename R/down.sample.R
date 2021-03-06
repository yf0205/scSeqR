#' Down sample conditions
#'
#' This function takes an object of class scSeqR and down samples the condition to have equal number of cells in each condition.
#' @param x An object of class scSeqR.
#' @return An object of class scSeqR.
#' @examples
#' \dontrun{
#' my.obj <- down.sample(my.obj)
#' }
#' @export
down.sample <- function (x = NULL) {
  if ("scSeqR" != class(x)[1]) {
    stop("x should be an object of class scSeqR")
  }
  DATA <- x@main.data
  CellIds <- colnames(DATA)
  My.Conds.data <- data.frame(do.call('rbind', strsplit(as.character(CellIds),'_',fixed=TRUE)))
  My.Conds.data <- cbind(My.Conds.data,CellIds)
  My.Conds <- as.data.frame(table(My.Conds.data$X1))
  Conds <- paste(as.character(My.Conds$Var1) , collapse=",")
  cond.counts <- paste(as.character(My.Conds$Freq) , collapse=",")
# Print Condition info after filtering
  CondsInfo <- paste("Data conditions: ", Conds, " (",cond.counts,")", sep="")
# samplest sample
  smallest.sample <- min(My.Conds$Freq)
# Get down sampled cell ids to filter
  Conds <- as.character(My.Conds$Var1)
  for (i in Conds) {
  NameCol <- paste("My_Cond",i,sep="_")
  myDATA <- as.character(as.matrix(subset(My.Conds.data, My.Conds.data$X1 == i)[3]))[1:smallest.sample]
  eval(call("<-", as.name(NameCol), myDATA))
  }
  filenames <- ls(pattern="My_Cond_")
  datalist <- mget(filenames)
  ToFilter <- as.character(unlist(datalist))
  DATA <- DATA[ , which(names(DATA) %in% ToFilter)]
  CellIds <- colnames(DATA)
  My.Conds.data <- data.frame(do.call('rbind', strsplit(as.character(CellIds),'_',fixed=TRUE)))
  My.Conds.data <- cbind(My.Conds.data,CellIds)
  My.Conds <- as.data.frame(table(My.Conds.data$X1))
  Conds <- paste(as.character(My.Conds$Var1) , collapse=",")
  cond.counts <- paste(as.character(My.Conds$Freq) , collapse=",")
  # Print Condition info after filtering
  CondsInfo2 <- paste("Data conditions: ", Conds, " (",cond.counts,")", sep="")
# Print
  print("From")
  print(CondsInfo)
  print("to")
  print(CondsInfo2)
# return
  attributes(x)$main.data <- DATA
  return(x)
}

