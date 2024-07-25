# run once on a new machine

install.packages(c("BiocManager",
                   "ltsspca",
                   "sparsepca",
                   "nFactors",
                   "doParallel",
                   "doRNG",
                   "foreach"))

if(!require("BiocManager", quietly=TRUE))
  install.packages("BiocManager")

BiocManager::install("pcaMethods")
