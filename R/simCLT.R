simCLT <- 
function(ns, n, p1=0, p2=1, seed=NULL,
         type=c("normal", "uniform", "lognormal", "antinormal"),
         fill="lightsteelblue3", n_display=0, digits_d=3, 
         subtitle=TRUE, pop=TRUE, 
         main=NULL, pdf=FALSE, width=5, height=5, ...) {


  # a dot in a parameter name to an underscore
  dots <- list(...)
  if (!is.null(dots)) if (length(dots) > 0) {
    change <- c("n.display", "digits.d")
    for (i in 1:length(dots)) {
      if (names(dots)[i] %in% change) {
        nm <- gsub(".", "_", names(dots)[i], fixed=TRUE)
        assign(nm, dots[[i]])
        get(nm)
      }
    }
  }

  type <- match.arg(type)

  if (missing(ns)) {
    cat("\n"); stop(call.=FALSE, "\n","------\n",
      "Specify the number of samples, each of a given size, with:  ns\n\n")
  }

  if (missing(n)) {
    cat("\n"); stop(call.=FALSE, "\n","------\n",
      "Specify the size of each sample, the number of data values, with:  n\n\n")
  }

  manage.gr <- .graphman()
  if (!pdf) {
    if (manage.gr) {
      .graphwin(2)
      dev.set(which=3)
    }
  }
  else { 
    pdf_file <- "SimPopulation.pdf"
    pdf(file=pdf_file, width=width, height=height)
  }

  digits_d <- 3
  max.ln <- 8
   
  # data generation and plot population
  if (!is.null(seed)) set.seed(seed)

  if (type == "normal") {
    mu <- p1
    sigma <- p2
    data.raw <- rnorm(ns*n, mu, sigma)

    if (pop) {
      prob.znorm(mu=mu, sigma=sigma, xlab="Normal Population", 
                 r=0.535, g=0.610, b=0.704)
    }
  }

  if (type == "uniform") {
    min <- p1
    max <- p2
    mu <- (min + max) / 2
    sigma <- (max - min) / sqrt(12)
    data.raw <- runif(ns*n, 0, 4)

    if (pop) { 
      x.min <- min - 2
      x.max <- max + 2
      x <- seq(x.min, x.max, length=500)
      y <- dunif(x, min, max)
      plot(x, y, type="n", ylim=c(0,max(y)+.1), axes=FALSE, xlab="", ylab="")
      if (max-min < 10) axis(1, at=seq(x.min, x.max, by=1)) else axis(1)
      usr <- par("usr")
      rect(usr[1], usr[3], usr[2], usr[4], col="ghostwhite", border="black")
      polygon(c(min, x, max), c(0, y, 0), col=fill, border="black")
      if (subtitle) 
        txt <- paste("min=", toString(0), " max=", toString(x.max), sep="") 
      else txt=""  
      title(xlab="Uniform Population", sub=txt)  
    }
  }

  if (type == "lognormal") {
    meanlog <- p1
    sdlog <- p2
    varlog <- sdlog^2
    mu <- exp(meanlog + varlog/2)
    sigma <- mu * sqrt(exp(varlog) - 1)
    pop.skew <- (exp(varlog) + 2) * sqrt(exp(varlog) - 1)
    pop.med <- exp(meanlog)
    data.raw <- rlnorm(ns*n, meanlog, sdlog)

    if (pop) {
      x.max <- ceiling(mu + 4*sigma)
      x <- seq(0, x.max, length=500)
      y <- dlnorm(x, meanlog=meanlog, sdlog=sdlog)
      plot(x, y, type="n", axes=FALSE, xlab="", ylab="")
      axis(1)
      usr <- par("usr")
      rect(usr[1], usr[3], usr[2], usr[4], col="ghostwhite", border="black")
      polygon(c(0, x, x.max), c(0, y, 0), col="lightsteelblue3", border="black")
      if (subtitle) 
        txt <- paste("meanlog=", toString(meanlog), " sdlog=",
                     toString(sdlog), sep="") 
      else txt=""  
      title(xlab="Lognormal Population", sub=txt)
    }
  }

  if (type == "antinormal") {

    if (p1 != 0) { 
      cat("\n"); stop(call.=FALSE, "\n","------\n",
          "Minimum value of anti-normal distribution must be 0.\n\n")
    }
    x.max <- p2

    mu <- x.max / 2
    sigma <- NULL 
    data.raw <- numeric(length=0)
    for (i in 1:(ns*n))
      if (runif(1) < 0.5) 
        data.raw[i] <- rtriangle(1, a=0, b=x.max/2, c=0+.01)
      else 
        data.raw[i] <- rtriangle(1, a=x.max/2, b=x.max, c=x.max-.01)

    if (pop) {
      x1 <- seq(0, x.max/2, length=250)
      y1 <- dtriangle(x1, a=0, b=x.max/2, c=0+.01)  # triangle function
      plot(0, type="n", axes=FALSE, xlim=c(0-.5, x.max+.5),
           ylim=c(0,max(y1)+.1), xlab="", ylab="")
      axis(1)
      usr <- par("usr")
      rect(usr[1], usr[3], usr[2], usr[4], col="ghostwhite", border="black")
      lines(x1,y1)
      polygon(c(0, x1, x.max/2), c(0, y1, 0), col="lightsteelblue3",
              border="black")
      x2 <- seq(x.max/2, x.max, length=250)
      y2 <- dtriangle(x2, a=x.max/2, b=x.max, c=x.max-.01)
      lines(x2,y2)
      polygon(c(x.max/2, x2, x.max), c(0, y2, 0), col="lightsteelblue3",
              border="black")
      if (subtitle) 
        txt <- paste("min=", toString(0), " max=", toString(x.max), sep="") 
      else txt=""  
      title(xlab="Anti-Normal Population", sub=txt)
    }
  }

  if (pdf) {
    dev.off()
    .showfile(pdf_file, "population distribution")
  }

  if (!pdf) {
    if (manage.gr) {
      dev.set(which=4) 
    }
  }
        

  cat("\n")
  cat("Population mean, mu :", mu, "\n")
  if (!is.null(sigma)) cat("Pop std dev, sigma  :", sigma, "\n")
  if (type == "lognormal") {
    cat("Population skew:     ", pop.skew, "\n")
    cat("Population median:   ", pop.med, "\n")
  }
  cat("\n")
  cat("Number of samples   :", sprintf("%i", ns), "\n")
  cat("Size of each sample :", n, "\n")


  # data analysis
  cat("\n")
  mx <- mean(data.raw)
  sx <- sd(data.raw)
  cat("Mean of the data:", mx, "\n")
  cat("Std Dev of the data:", sx, "\n")
  data.byrep <- matrix(data.raw, nrow=ns, ncol=n)

  Ymean <- apply(data.byrep, 1, mean)
  Ysd <- apply(data.byrep, 1, sd)

  if (!is.null(getOption("theme"))) colors <- getOption("theme")
  else colors="blue"

  if (!pdf) 
    dev.set(which=4) 
  else { 
    pdf_file <- "SimSample.pdf"
    pdf(file=pdf_file, width=width, height=height)
  }

  .dn.main(Ymean, type="normal", xlab="", 
         fill_hist=fill, 
         col.nrm="black", col.gen="black",
         fill_nrm="transparent",
         fill_gen="transparent",
         quiet=TRUE, pdf_file=NULL)
  if (subtitle) 
    txt <- paste(toString(sprintf("%i", ns)), "samples, each of size", toString(n), "from", type)
  else txt=""
  title(xlab="Sample Mean", sub=txt)

  if (pdf) {
    dev.off()
    .showfile(pdf_file, "sample distribution")
    cat("\n\n")
  }

  cat("\nAnalysis of Sample Means\n")
  cat("   Mean:", .fmt(mean(Ymean), digits_d, w=max.ln), "\n")
  cat("Std Dev:", .fmt(sd(Ymean), digits_d, w=max.ln), "\n")
  cat("\n")
  cat("Observed 95% range of Sample Mean\n", 
      "   Original Units:",  quantile(Ymean, prob=c(.025,.975)),"\n")
  if (type != "antinormal") se <- sigma /sqrt(n) else se <- sx / sqrt(n)
  z <- (Ymean-mu) / se
  if (type == "antinormal") cat("   Estimated from Data,")
  cat("  Standard Errors:",  quantile(z, prob=c(.025,.975)),"\n")

  if (n_display > 0)
    for(i in 1:n_display) 
      cat("\nSample", toString(i), "\n",
          "Mean:", sprintf("%.*f", digits_d, Ymean[i]), "\n",
          "Rounded Data Values:", .fmt(data.byrep[i,], digits_d), "\n")

  cat("\n")

}
