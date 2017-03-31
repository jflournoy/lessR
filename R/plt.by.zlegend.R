# plot legend for by variables

.plt.by.legend <-
function(mylevels, stroke, fill, shp, trans.pts, col.bg, usr,
         pt.size=1.1, pt.lwd=0.5) {

  par(xpd=NA)  # allow drawing outside of plot region

  n.levels <- length(mylevels)
  by.name <- getOption("byname")

  legend.labels <- abbreviate(mylevels,6)
  #if (options("device") == "RStudioGD" && .Platform$OS != "windows") {
    #max.width <- which(nchar(legend.labels) == max(nchar(legend.labels)))
    #legend.labels[max.width] <- paste(legend.labels[max.width], "    ", sep="")
  #}

  #wt <- ifelse (options("device") == "RStudioGD", 10, 12)
  wt <- 10
  legend.title  <- abbreviate(by.name, wt)
  #if (options("device") == "RStudioGD" && .Platform$OS != "windows") {
    #if (nchar(legend.title) > nchar(legend.labels[max.width][1]))
      #legend.title <- paste(" ", legend.title, " ", sep="") 
  #}
  ll <- legend(0,0, legend=legend.labels, title=legend.title, cex=.7,
               pt.cex=pt.size, pt.lwd=pt.lwd, plot=FALSE)

  size <- (par("cxy")/par("cin"))  # 1 inch in user coordinates 

  epsilon <- (size[1] - ll$rect$w) / 2

  axis.vert <- usr[4] - usr[3]
  xleft <- usr[2] + epsilon   # usr[2] user coordinate of right axis
  lgnd.vhalf <- (ll$rect$h) / 2
  axis.cntr <- axis.vert / 2  + usr[3]
  ytop <- axis.cntr + lgnd.vhalf  # user coordinate of legend top

  if (trans.pts > 0.85) {  # points too light, reduce legend transparency
    legend.fill <- integer(length=n.levels)
    for (i in 1:n.levels) legend.fill[i] <- .maketrans(stroke[i],.7)
  }
  else 
    legend.fill <- fill

  the.clr <- ifelse(grepl(".black", getOption("colors")), "gray90", "black")

  yi <- ifelse (options("device") == "RStudioGD", 1.4, 1)
  # fill=length(legend.labels):1  puts the legend labels in the correct
  #   order, but only for inflexible boxes that cannot be resized with pt.cex
  legend(xleft, ytop, legend=legend.labels, title=legend.title, 
         pch=shp, horiz=FALSE, cex=.7, pt.cex=pt.size, pt.lwd=pt.lwd,
         box.lwd=.5, box.col="gray30", bg=col.bg, col=stroke, pt.bg=fill,
         text.col=the.clr, y.intersp=yi)

  par(xpd=FALSE)  # cancel drawing outside of plot region (need for RStudio)

}