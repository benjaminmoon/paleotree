% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/inverseSurv.R
\name{inverseSurv}
\alias{inverseSurv}
\alias{make_inverseSurv}
\alias{invSurv}
\title{Inverse Survivorship Models in the Fossil Record}
\usage{
make_inverseSurv(timeList, groups = NULL, p_cont = TRUE, q_cont = TRUE,
  PA_n = "fixed", PB_1 = 0, Nb = 1, drop.extant = TRUE)
}
\arguments{
\item{timeList}{A 2 column matrix with the first and last occurrences of taxa
given in relative time intervals (i.e. ordered from first to last). If a list
of length two is given for timeData, such as would be expected if the output 
of binTimeData was directly input, the second element is used. See details.
Unsampled taxa (e.g. from a simulation of sampling in the fossil record,
listed as NAs in the second matrix) are automatically dropped from the
timeList and from groups simultaneously. Living taxa observed in the modern day
are expected to be listed as last observed in a special interval (0,0), i.e.
begins and ends at 0 time. This interval is always automatically removed prior
to the calculation intermediary data for fitting likelihood functions.}

\item{groups}{Either NULL (the default) or matrix with the number of rows equal
to the number of taxa and the number of columns equal to the number of 'systems'
of categories for taxa. Taxonomic membership in different groups is indicated
by numeric values. For example, a dataset could have a 'groups' matrix composed
of a column representing thin and thick shelled taxa, coded 1 and 2 respectively,
while the second column indicates whether taxa live in coastal,
outer continental shelf, or deep
marine settings, coded 1-3 respectively. Different combinations of groups will
be treated as having independent sampling and extinction parameters in the
default analysis, for example, thinly-shelled deep marine species will have
separate parameters from thinly-shelled coastal species. Grouping systems could
also represent temporal heterogeneity, for example, categorizing Paleozoic versus
Mesozoic taxa. If groups are NULL (the default), all taxa are assumed to be of
the same group with the same parameters. Unsampled taxa (e.g. from a simulation
of sampling in the fossil record, listed as NAs in timeData or timeList)
are automatically dropped from groupings and the time dataset (either timeData
or timeList) and from groups simultaneously.}

\item{p_cont}{If TRUE (the default), then origination is assumed to be a 
continuous time process with an instantaneous rate. If FALSE, the origination
is treated as a pulsed discrete-time process with a probability.}

\item{q_cont}{If TRUE (the default), then extinction is assumed to be a 
continuous time process with an instantaneous rate. If FALSE, the extinction
is treated as a pulsed discrete-time process with a probability.}

\item{PA_n}{The probability of sampling a taxon after the last interval 
included in a survivorship study. Usually zero for extinct groups, 
although more logically has the value of 1 when there are still extant
taxa (i.e., if the last interval is the Holocene and the group is
still alive, the probability of sampling them later is probably 1...).
Should be a value of 0 to 1, NULL, or can be simply "fixed", the default option.
This default "fixed" option allows \code{make_inverseSurv} to decide the value
based on whether there is a modern interval (i.e. an interval that is 
\code{c(0,0)}) or not: if there is one, then \code{PA_n = 1}, if not, 
then \code{PA_n = 0}. If NULL, PA_n is treated as an additional free
parameter in the output model.}

\item{PB_1}{The probability of sampling a taxon before the first interval 
included in a survivorship study. Should be a value of 0 to 1, or NULL. 
If NULL, PB_1 is treated as an additional free parameter in the output model.}

\item{Nb}{The number of taxa that enter an interval (b is for 'bottom'). This
is an arbitrary constant used to scale other values in these calculations and
can be safely set to 1.}

\item{drop.extant}{Drops all extant taxa from a dataset, w}
}
\value{
A function of class "paleotreeFunc", which takes a vector equal to the number
of parameters and returns the *negative* log likelihood (for use with optim and
similar optimizing functions, which attempt to minimize support values). See the
functions listed at \code{\link{modelMethods}} for manipulating and examining
such functions and \code{\link{constrainParPaleo}} for constraining parameters.

The function output will take the largest number of parameters possible with
respect to groupings and time-intervals, which means the number of parameters
may number in the hundreds. Constraining the function for optimization
is recommended except when datasets are very large.

Parameters in the output functions are named 'p', 'q' and 'r', which are
respectively the origination, extinction and sampling parameters. If the
respective arguments 'p_cont' and 'q_cont' are TRUE, then 'p' and 'q' will
represent the instantaneous per-capita origination and extinction rates
(in units of per lineage time-units). When one of these arguments is given as
FALSE, the respective parameter (p or q) will represent per-lineage-interval
rates. For p, this will be the per lineage-interval rate of a lineage producing
another lineage (which can exceed 1 because diversity can more than double) and
for q, this will be the per lineage-interval 'rate' of a lineage going extinct,
which cannot be observed to exceed 1 (because the proportion of diversity that
goes extinct cannot exceed 1). To obtain the per lineage-interval rates from a
set of per lineage-time unit rates, simply multiply the per lineage-time-unit
rate by the duration of an interval (or divide, to do the reverse; see Foote,
2003 and 2005). 'r' is always the instantaneous per-capita sampling rate, in
units per lineage-time units. 

If PA_n or PB_1 were given as NULL in the arguments, two additional parameters
will be added, named respectively 'PA_n' and 'PB_1', and listed separately for every
additional grouping. These are the probability of a taxon occurring before the first
interval in the dataset (PB_1) and the probability of a taxon occurring after
the last interval in a dataset (PA_n). Theses will be listed as 'PA_n.0' and 'PB_1.0'
to indicate that they are not related to any particular time-interval included
in the analysis, unlike the p, q, and r parameters (see below).

Groupings follow the parameter names, separated by periods; by default, the
parameters will be placed in groups corresponding to the discrete intervals
in the input timeList, such that \code{make_inverseSurv} will create a function with
parameters 'p.1', 'q.1' and 'r.1' for interval 1; 'p.2', 'q.2' and 'r.2' for
interval 2 and so on. Additional groupings given by the user are listed after 
this first set (e.g. 'p.1.2.2').

\subsection{Calculating The Results of an Inverse Survivorship Model}{
Because of the complicated grouping and time interval scheme, combined with
the probable preference of users to use constrained models rather that the
full models, it may be difficult to infer what the rates for particular
intervals and groups actually are in the final model, given the parameters
that were found in the final optimization.

To account for this, the function output by \code{inverseSurv} also contains
an alternative mode which takes input rates and returns the final values along with
a rudimentary plotting function. This allows users to output per-interval and per-group
parameter estimates. To select these feature, the argument \code{altMode} must
be TRUE. This function will invisibly return the rate values for each
group and interval as a list of matrices, with each matrix composed of the
p, q and r rates for each interval, for a specific grouping.

This plotting is extremely primitive, and most users will probably find the
invisibly returned rates to be of more interest. The function \code{layout} is
used to play plots for different groupings in sequence, and this may lead to
plots which are either hard to read or even cause errors (because of too many
groupings, producing impossible plots). To repress this, the argument \code{plotPar}
can be set to FALSE.

This capability means the function has more arguments that just the
usual \code{par} argument that accepts the vector of parameters for running an
optimization. The first of these additional arguments, \code{altMode} enables
this alternative mode, instead of trying to estimate the negative log-likelihood
from the given parameters. The other arguments augment the calculation and plotting
of rates.

To summarize, a function output by \code{inverseSurv} has the following arguments:

\describe{
 \item{par}{A vector of parameters, the same length as the number of parameters needed.
For plotting, can be obtained with optimization}
 \item{altMode}{If FALSE (the default) the function will work like ordinary model-fitting functions,
returning a negative log-likelihood value for the input parameter values in \code{par}. If TRUE,
however, the input parameters will instead be translated into the by-interval, by-group rates
used for calculating the log-likelihoods, plotted (if plotPar is TRUE) and these final
interval-specific rates will be returned invisibly as described above.}
 \item{plotPar}{If TRUE (the default) the calculated rates will be plotted, with each
grouping given a separate plot. This can be repressed by setting plotPar to FALSE. As the only
conceivable purpose for setting plotPar to FALSE is to get the calculated rates, these will not
be returned invisibly if plotPar is FALSE.}
 \item{ratesPerInt}{If FALSE, the default option, the rates plotted and returned will
be in units per lineage-time units, if those rates were being treated as rates for a
continuous-time process (i.e. p_cont = TRUE and q_cont = TRUE for p and q, respectively,
while r is always per lineage-time units). Otherwise, the respective rate will be in
units per lineage-interval. If ratesPerInt is TRUE instead, then \emph{all} rates, even
rates modeled as continuous-time process, will be returned as per lineage-interval rates,
even the sampling rate r.}
 \item{logRates}{If FALSE (the default) rates are plotted on a linear scale. If TRUE,
rates are plotted on a vertical log axis.}
 \item{jitter}{If TRUE (default) the sampling rate and extinction rate will be plotted slightly
ahead of the origination rate on the time axis, so the three rates can be easily differentiated. 
If false, this is repressed.}
 \item{legendPoisition}{The position of a legend indicating which line is
which of the three rates on the resulting plot. This
is given as the possible positions for argument 'x' of the function 
\code{\link{legend}}, and by default is "topleft", which will be generally
useful if origination and extinction rates are initially low. If 
legendPosition is NA, then a legend will not be plotted.}
}
}
}
\description{
This function replicates the model-fitting procedure for forward and
reverse survivorship curve data, described by Michael Foote in a series
of papers (2001, 2003a, 2003b, 2005). These methods are discrete interval
taxon ranges, as are used in many other functions in paleotree 
(see function arguments). This function
can implement the continuous time, pulsed interval and mixed models described
in Foote (2003a and 2005).
}
\details{
The design of this function to handle mixed continuous and discrete time models
means that parameters can mean very different things, dependent on how a
model is defined. Users should carefully evaluate their function arguments
and the discussion of parameter values as described in the Value section.
}
\note{
This function is an entirely new rewrite of the methodology derived and presented by Foote in
his studies. Thus, whether it would give identical results cannot be assumed nor is it easy to test
given differences in the way data is handled between our coded functions. Furthermore, there may be
differences in the math due to mistakes in the derivations caught while this function was programmed.
I have tested the function by applying it to the same Sepkoski genus-level dataset that Foote used in
his 2003 and 2005 papers. Users can feel free to contact me for detailed figures from this analysis.
Overall, it seems my function captured the overall pattern of origination and sampling rates, at least
under a model where both origination and extinction are modeled as continuous-time processes. Extinction
showed considerably more variability relative to the published figures in Foote (2005). Additional
analyses are being run to identify the sources of this discrepancy, and the function is being released
here in paleotree on a trial basis, so that it can be more easily loaded onto remote servers. Users should be
thus forewarned of this essentially 'beta' status of this function.
}
\examples{
\donttest{

# let's simulate some taxon ranges from an imperfectly sampled fossil record
set.seed(444)
record <- simFossilRecord(p = 0.1, q = 0.1, nruns = 1,
nTotalTaxa = c(30,40), nExtant = 0)
taxa <- fossilRecord2fossilTaxa(record)
rangesCont <- sampleRanges(taxa,r = 0.5)
#bin the ranges into discrete time intervals
rangesDisc <- binTimeData(rangesCont,int.length = 5)

#apply make_inverseSurv
likFun <- make_inverseSurv(rangesDisc)
#use constrainParPaleo to make the model time-homogenous
  	#match.all~match.all will match parameters so only 2 pars: p = q and r
constrFun <- constrainParPaleo(likFun,match.all~match.all)
results <- optim(parInit(constrFun), constrFun,
      lower = parLower(constrFun), upper = parUpper(constrFun),
      method = "L-BFGS-B", control = list(maxit = 1000000))
results

#plot the results
constrFun(results$par, altMode = TRUE)

#unconstrained function with ALL of 225 parameters!!!
    # this will take forever to converge, so it isn't run
optim(parInit(likFun),likFun,lower = parLower(likFun),upper = parUpper(likFun),
      method = "L-BFGS-B",control = list(maxit = 1000000))
}
}
\references{
Foote, M. 2001. Inferring temporal patterns of preservation, origination, and 
extinction from taxonomic survivorship analysis. \emph{Paleobiology} 27(4):602-630.

Foote, M. 2003a. Origination and Extinction through the Phanerozoic: A New
Approach. \emph{The Journal of Geology} 111(2):125-148.

Foote, M. 2003b. Erratum: Origination and Extinction through the Phanerozoic:
a New Approach. \emph{The Journal of Geology} 111(6):752-753.

Foote, M. 2005. Pulsed origination and extinction in the marine realm.
\emph{Paleobiology} 31(1):6-20.
}
\seealso{
This function extensively relies on \code{\link{footeValues}}.

A similar format for likelihood models can be seen in \code{\link{durationFreq}}.

Also see \code{\link{freqRat}}, \code{\link{sRate2sProb}},
\code{\link{qsRate2Comp}} \code{\link{sProb2sRate}} and \code{\link{qsProb2Comp}}.

For translating between sampling probabilities and sampling rates, see
\code{\link{SamplingConv}}.
}
\author{
David W. Bapst, with some advice from Michael Foote.
}
