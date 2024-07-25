####

# Megan Tung
# File contains helper functions to calculate metrics to evaluate accuracy of 
# PCA methods on simulated and real data and output results in usable format

####


testK = function(k, khat) {
  # compare accuracy of k and khat
  
  propK = (k - khat) / k
  return(propK)
}

testChordalDist = function(V, Vhat) {
  # comparing accuracy of V & Vhat (loadings/coefficients), ideally standardize
  
  # k values
  k = ncol(V)
  khat = ncol(Vhat)
  
  choosek = min(k, khat) # uses the smaller k for dimension purposes
  V = V[, 1:choosek]
  Vhat = Vhat[, 1:choosek]
  
  # check orthogonality of Vhat here
  # do svd of non-orthogonal Vhat
  svdV = svd(Vhat)
  
  # the first k left singular vectors are orthogonal basis for the space spanned by the columns of Vhat
  VhatOrtho = svdV$u[, 1:choosek]
  
  # projection matrices
  projV = V %*% t(V)
  projVhat = VhatOrtho %*% t(VhatOrtho)
  
  chorDist = (1 / sqrt(2)) * sqrt(sum((projV - projVhat) ^ 2))
  
  return(chorDist)
  
}

testUDV = function(loadings, loadingshat, scores, scoreshat) {
  # compare accuracy of X and Xhat
  ## || UDV^T - UDhatVhat^T ||^2
  ## true signal matrix - estimated signal matrix
  # calculate X matrices UD * t(V)
  trueUDV = scores %*% t(loadings)
  estUDV = scoreshat %*% t(loadingshat)
  
  propUDV = sqrt(sum((trueUDV - estUDV) ^ 2)) / length(trueUDV)
  
  return(propUDV)
}

testScores = function(scores, scoreshat) {
  
  # k values
  k = ncol(scores)
  khat = ncol(scoreshat)
  
  choosek = min(k, khat) # uses the smaller k for dimension purposes
  trueScores = scores[, 1:choosek]
  estScores = scoreshat[, 1:choosek]
  
  # do svd of non-orthogonal trueScores and estScores
  svdEstScores = svd(estScores)
  
  # first k left singular vectors are orthogonal basis for the space spanned by the columns of hatV
  trueScoresOrtho = svd(trueScores)$u[, 1:choosek]
  estScoresOrtho = svdEstScores$u[, 1:choosek]
  
  # projection matrices
  projTrueScores = trueScoresOrtho %*% t(trueScoresOrtho)
  projEstScores = estScoresOrtho %*% t(estScoresOrtho)
  
  scoresChorDist = (1 / sqrt(2)) * sqrt(sum((projTrueScores - projEstScores) ^ 2))
  
  return(scoresChorDist)
}