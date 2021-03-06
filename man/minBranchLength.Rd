% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/minBranchLength.R
\name{minBranchLength}
\alias{minBranchLength}
\title{Scales Edge Lengths of a Phylogeny to a Minimum Branch Length}
\usage{
minBranchLength(tree, mbl)
}
\arguments{
\item{tree}{A phylogeny with edge lengths of class 'phylo'.}

\item{mbl}{The minimum branch length}
}
\value{
A phylogeny with edge lengths of class 'phylo'.
}
\description{
Rescales a tree with edge lengths so that all edge lengths are at least some minimum branch length (mbl),
without changing the relative distance of the tips from the root node. Edge lengths are transformed so they are
greater than or equal to the input minimum branch length, by subtracting edge length from more rootward edges
and added to later branches.
}
\details{
This function was formally an internal segment in \code{\link{timePaleoPhy}}, and now is called by \code{timePaleoPhy}
instead, allowing users to apply \code{minBranchLength} to trees that already have edge lengths.
}
\examples{

#simulation with an example non-ultrametric tree

tree <- rtree(20)
# randomly replace edges with ZLBs, similar to multi2di output
tree <- degradeTree(tree,0.3,leave.zlb = TRUE) 	

tree2 <- minBranchLength(tree,0.1)

layout(1:2)
plot(tree);axisPhylo()
plot(tree2);axisPhylo()

layout(1)

#now let's try it with an ultrametric case

# get a random tree
tree <- rtree(30)
# randomly replace edges with ZLBs, similar to multi2di output
tree <- degradeTree(tree,0.5,leave.zlb = TRUE) 
# now randomly resolve	
tree <- di2multi(tree)
# give branch lengths so its ultrametric
tree <- compute.brlen(tree)

plot(tree) #and we have an ultrametric tree with polytomies, yay!

#now randomly resolve, get new branch lengths as would with real data
tree2 <- multi2di(tree)
tree2 <- minBranchLength(tree2,0.1)

layout(1:2)
plot(tree,show.tip.label = FALSE);axisPhylo()
plot(tree2,show.tip.label = FALSE);axisPhylo()

layout(1)
}
\seealso{
This function was originally an internal piece of \code{\link{timePaleoPhy}}, which implements the minimum branch
length time-scaling method along with others, which may be what you're looking for
(instead of this miscellaneous function).
}
\author{
David W. Bapst
}
