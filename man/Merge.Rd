\name{Merge}
\alias{Merge}
\alias{mrg}

\title{Merge Two Data Frames Horizontally or Vertically}

\description{
Abbreviation: \code{mrg}

Based directly on the standard R \code{\link{merge}} function for a vertical merge and the \code{\link{rbind}} function for a horizontal merge.
}

\usage{
Merge(data1, data2, by=NULL, quiet=getOption("quiet"), \ldots)

mrg(\ldots)
}

\arguments{
  \item{data1}{The name of the first data frame from which to create the merged 
       data frame.}
  \item{data2}{The name of the second data frame from which to create the merged 
       data frame.}
  \item{by}{If specified, then signals a vertical merge and the variable by
        which the data frames are merged. Specify \code{"row.names"} for merging
        according to the row names.}
  \item{quiet}{If set to \code{TRUE}, no text output. Can change system default
       with \code{\link{set}} function.}
  \item{\dots}{The specified arguments.}
}

\details{
\code{Merge} creates a merged data frame from two input data frames.

If \code{by} is specified the merge is vertical. That is the variables in the second input data frame are presumed different from the variables in the first input data frame. The merged data frame is the combination of variables from both input data frames, with the rows aligned by the value of \code{by}, a variable common to both data frames. \code{Merge} relies upon the R function  \code{\link{rbind}} for the vertical merge.

If \code{by} is not provided, then the merge is horizontal. The variables are presumed the same in each input data frame.  The merged data frame consists of the rows of both input data frames. \code{Merge} relies upon the R function  \code{\link{merge}} for the horizontal merge. 

Guidance and feedback regarding the merge are provided by default. The first five lines of each of the input data frames are listed before the merge operation, followed by the first five lines of the output data frame.
}

\value{
The merged data frame is returned, usually assigned the name of \code{mydata} as in the examples below.  This is the default name for the data frame input into the \code{lessR} data analysis functions.
}

\author{David W. Gerbing (Portland State University; \email{gerbing@pdx.edu})}

\seealso{
\code{\link{merge}}, \code{\link{rbind}}.
}

\examples{
# construct the data frames to merge
mydata <- Read("Employee", format="lessR")
Emp1a <- mydata[1:4, c("Years", "Gender", "Dept", "Salary")]
Emp1b <- mydata[1:4, c("Satisfaction", "HealthPlan")]
Emp2a <- mydata[1:4, ]
Emp2b <- mydata[7:10, ]
rm(mydata)

# horizontal merge
mydata <- Merge(Emp1a, Emp1b, by="row.names")

# vertical merge
mydata <- Merge(Emp2a, Emp2b)


}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ merge }

