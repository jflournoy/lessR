corReorder <-
function (R=mycor, order=c("hclust", "chain", "manual"),
          hclust_type = c("complete", "ward.D", "ward.D2", "single",
                          "average", "mcquitty", "median", "centroid"),
          n_clusters=NULL, vars=NULL,chain_first=0,
          heat_map=TRUE, diagonal_new=TRUE,
          main=NULL, bottom=3, right=3,
          pdf_file=NULL, width=5, height=5, ...) {

  # a dot in a parameter name to an underscore
  dots <- list(...)
  if (!is.null(dots)) if (length(dots) > 0) {
    change <- c("n.clusters", "chain.first", "heat.map",
                "diagonal.new", "pdf.file")
    for (i in 1:length(dots)) {
      if (names(dots)[i] %in% change) {
        nm <- gsub(".", "_", names(dots)[i], fixed=TRUE)
        assign(nm, dots[[i]])
        get(nm)
      }
    }
  }

  order <- match.arg(order)
  hclust_type <- match.arg(hclust_type)

  # cor matrix:  mycor as class out_all, mycor$R, or stand-alone matrix
  cor.nm <- deparse(substitute(R))
  .cor.exists(cor.nm)  # see if matrix exists in one of the 3 locations
  if ("out_all" %in% class(R))    # R 4.0 results in two values: matrix, array
    R <- eval(parse(text=paste(cor.nm, "$R", sep="")))  # go to $R 

  NVOld <- nrow(R)
  nvc <- as.integer(NVOld)
  Label <- integer(length=NVOld)

  if (!missing(vars)) order <- "manual"

  # -----
  # ORDER

  if (order == "manual") {
    # translate variable names into column positions
    vars.all <- as.list(seq_along(as.data.frame(R)))
    names(vars.all) <- names(as.data.frame(R))
    vars.num <- eval(substitute(vars), vars.all, parent.frame())
    Label <- as.integer(as.vector(vars.num))
  }

  else if (order == "hclust") {
    dst <- as.dist(1-R)
    ord <- hclust(dst, method=hclust_type)
    Label <- ord$order

    if (!is.null(n_clusters)) {
     clt <- sort(cutree(ord, k=n_clusters)) 
     ttl <- paste(as.character(n_clusters), " Cluster Solution", sep="")
     cat("\n", ttl, "\n")
     .dash(nchar(ttl) + 1)  
     print(clt)
    }
  }

  else if (order == "chain") {  # Hunter 1973

    i.first <- as.integer(chain_first)

    nv <- nvc

  # If i.first = 0 (default), best variable is chosen first
  # If i.first gt 0, i.first is the first variable chosen by user

    Label <- rep(0, nv)

  # i.first gives starting value
  # Find max sum sq variable for i.first if not user specified
    if (i.first == 0) {
      v.max <- 0.0
      for (i in 1:nv) {
        vt <- 0.0
        for (j in 1:nv) {
          vt <- vt + R[i,j]**2
        }
        if (vt > v.max) {
          v.max <- vt
          i.max <- i
        }
      }
      i.first <- i.max
    }

  # get Labels

    Label[1] <- i.first * 1000
    Label[i.first] <- Label[i.first] + 1

    for (i in 2:nv) {
      R.max <- 0.0
      k <- Label[i-1] / 1000
      for (j in 1:nv) {
        Lbctad <- Label[j] - (Label[j] %/% 1000) * 1000
        if (Lbctad == 0) {
          if (abs(R[k,j]) > R.max) {
            R.max <- abs(R[k,j])
            i.max <- j
          }
        }
      }
      Label[i.max] <- Label[i.max] + i
      Label[i] <- Label[i]+1000 * i.max
    }

    for (i in 1:nv) {
      Label[i] <- Label[i] %/% 1000
    }

    #vars.num <- Label  # derived vars.num (not user specified)
  }


  # -----------------------------
  # re-order R matrix
  R <- R[Label,Label]
  nv <- ncol(R)

  # save diagonal if change
  Rdiag <- double(length=nv)
  for (i in 1:nv) Rdiag[i] <- R[i,i]

  # diagonal is based on adjacent values
  if (diagonal_new) {
      R[1,1] <- R[1,2]
    if (nv > 2) {
      for (i in 1: nv) {
        for (i in 2:(nv-1)) {
          R[i,i] <- (R[i,i-1] + R[i,i+1]) / 2
          R[i,i] <- round(R[i,i], 2)
        }
      }
      R[nv,nv] <- R[nv,nv-1]
    }  # end > 2
    
  }

  if (heat_map)
     .corcolors(R, nrow(R), main, bottom, right, diag=NULL,
                pdf_file, width, height)

  # restore diagonal if changed
  if (diagonal_new)
    for (i in 1:nv) R[i,i] <- Rdiag[i]
    

  # finish
  cat("\n")
  invisible(R)
}





