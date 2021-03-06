.ss.data.frame <-
function(x, n_cat, brief, ...)  {

  for (i in 1:ncol(x)) {
    cat("\n\n")

    nu <- length(unique(na.omit(x[,i])))

    x.name <- names(x)[i]
    options(xname = x.name)

    if (is.numeric(x[,i]) && nu > n_cat) {
      stuff <- .ss.numeric(x[,i], brief=brief, ...)
      txsts <- stuff$tx
      txotl <- .bx.stats(x[,i])$txotl
      class(txsts) <- "out"
      class(txotl) <- "out"
      output <- list(out_stats=txsts, out_outliers=txotl)
      class(output) <- "out_all"
      print(output)
    }

    else if (is.factor(x[,i]) || is.character(x[,i]) ||
             (.is.num.cat(x[,i], n_cat))) {
      gl <- .getlabels()
      x.name <- gl$xn; x.lab <- gl$xb; x.lbl <- gl$xl
      stats <- .ss.factor(x[,i], x.name=x.name, x.lbl=x.lbl, ...)
      txttl <- stats$title
      counts <- stats$counts
      chi <- stats$chi
      class(txttl) <- "out"
      class(counts) <- "out"
      class(chi) <- "out"
      output <- list(out_title=txttl, out_counts=counts, out_chi=chi)
      class(output) <- "out_all"
      print(output)      

      if (is.numeric(x[,i]) && nu <= n_cat)
        cat("\n>>> Variable is numeric, but only has", nu, "<= n_cat =", n_cat, "levels,",
        "so treat as categorical.\n",
        "   To obtain the numeric summary, decrease  n_cat  to indicate a lower\n",
        "   number of unique values such as with function: set.\n", 
        "   Perhaps make this variable a factor with the R factor function.\n")
    }

    else cat("\n>>> The following type of variable not processed: ", 
             class(x[,i]), "\n")

  }

}
