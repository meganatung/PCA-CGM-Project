#####

# FORMAT:
# input: MATRIX: X, INTEGER: k (exception nBartlett)
# output: LIST: loadings = loadings matrix, scores = scores matrix

######

#loading required packages & sourcing files

library(nFactors)
library(sparsepca)
library(ltsspca)
library(BiocManager)
library(pcaMethods)

## method: nBartlett
selectK = function(X = data.matrix) {
  # assign correlation variable
  corX = cor(X)
  
  # check for negative eigenvalues
  values = eigen(corX)$values
  if (min(values) < 0) {
    # make adjustment so eigenvalues are non-negative
    # Create new corX = 0.99 corX + 0.01 I
    corX = 0.999 * corX + 0.001 * diag(ncol(corX))
  }
  
  # get k values for selection
  k = nBartlett(corX, N = 210)
  
  # output k values
  return(k$nFactors[["bartlett"]])
  
}

## method: Randomized Sparse PCA
applyRSPCA = function(X = data.matrix, k = k) {
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
applyNLPCA = function(X = data.matrix, k = k) {
  output = nlpca(X, nPcs = k, maxSteps = 1000)
  return(list(loadings = 0, scores = output@scores))
}


## method: Sparse Principal Component Analysis via Regularized Singular Value Decomposition
applyRSVD = function(X, k) {
  output = sPCA_rSVD(X, k = k) # apply method
  return(list(loadings = output$loadings, scores = output$scores))
}