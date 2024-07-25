####

# Megan Tung
# File contains helper functions to generate matrices given combination of parameters
# INTEGER k, INTEGER n, INTEGER p, INTEGER s to return MATRICES U, V, D, errorMat in LIST

####


generateU = function(k, n) {
  # generating U - n*k
  # superfeatures
  # gets a random normal matrix
  
  N = matrix(rnorm(k * n), n, k)
  # take first k singular vectors
  U = svd(N)$u[, 1:k]
  
  return(U)
}
generateV = function(k, p, s) {
  # generating v - p*k - coefficients
  
  N = matrix(rnorm(k * s), s, k) # non-zero submatrix
  Vsmall = svd(N)$u[, 1:k] # take first k singular vectors
  V = matrix(0, p, k) # full matrix
  index_s = sample(1:p, s) # position of non-zeros
  V[index_s, ] = Vsmall # plugs "small" V into "big final" V
  
  return(V)
}

generateD = function(k) {
  # generating D - k*k 
  # determines signal strength
  
  if (k == 3) {
    diag.elements = c(50, 40, 10) # diagonal is the same for each k
    D = diag(diag.elements, nrow = 3, ncol = 3)
  } else if (k == 8) {
    diag.elements = c(36, 25, 20, 15, 10, 5, 3, 2)
    D = diag(diag.elements, nrow = 8, ncol = 8)
  }
  
  return(D)
}

generateError = function(sd, n = 210, p = 48) {
  # generating error/noise matrix - n*p
  
  errorMat = matrix(rnorm(n * p, mean = 0, sd = sd), nrow = n, ncol = p)
  
  return(errorMat)
}

generateSettings = function(k, errorSD, s, n = 210, p = 48) {
  # generating all matrices
  
  U = generateU(k = k, n = n)
  V = generateV(k = k, p = p, s = s)
  D = generateD(k = k)
  errorMat = generateError(sd = errorSD, n = n, p = p)
  X = (U %*% D %*% t(V)) + errorMat
  
  return(list(X = X, U = U, V = V, D = D, E = errorMat))
}