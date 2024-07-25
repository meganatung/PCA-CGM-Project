#####

# Megan Tung
# File contains helper functions to apply PCA methods given MATRIX X and INTEGER 
# k and output results in usable LIST format. Exception is selectK that takes in 
# MATRIX X to output INTEGER k 

######

# loading required packages & sourcing files
library(nFactors)
library(sparsepca)
library(ltsspca)
library(BiocManager)
library(pcaMethods)

## method: nBartlett
selectK = function(X) {
  # assign correlation variable
  corX = cor(X)
  
  # check for negative eigenvalues
  values = eigen(corX)$values
  if (min(values) < 0) {
    # make adjustment so eigenvalues are non-negative
    # create new corX = 0.99 corX + 0.01 I
    corX = 0.999 * corX + 0.001 * diag(ncol(corX))
  }
  
  # get k values for selection
  k = nBartlett(corX, N = 210)
  
  # output k values
  return(k$nFactors[["bartlett"]])
  
}

## method: Randomized Sparse PCA
applyRSPCA = function(X, k) {
  # generating output
  output = rspca(X, k = k)
  
  # returning list of loadings and scores
  return(list(loadings = output$loadings, scores = output$scores))
  
}

## method: Sparse PCA
applySPCA = function(X, k) {
  output = spca(X, k)
  return(list(loadings = output$loadings, scores = output$scores))
}

## method: Non Linear PCA
applyNLPCA = function(X, k) {
  output = nlpca(X, nPcs = k, maxSteps = 1000)
  return(list(loadings = 0, scores = output@scores))
}


## method: Sparse Principal Component Analysis via Regularized Singular Value Decomposition
applyRSVD = function(X, k) {
  output = sPCA_rSVD(X, k = k) # apply method
  return(list(loadings = output$loadings, scores = output$scores))
}