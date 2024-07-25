#### Simulation Setting 6

# source all functions
source("Functions/Metrics.R")
source("Functions/Methods.R")
source("Functions/DataGeneration.R")

# install required packages
library(pcaMethods) # nlpca
library(ltsspca) # sPCA_rSVD
library(sparsepca) # spca and rspca
library(nFactors) # nBartlett

# number of reps per model
nrep = 100

# cluster initialization
library(doParallel)
library(doRNG)
library(foreach)
nworkers = detectCores()
cl = makeCluster(nworkers - 2)
registerDoParallel(cl)

# start timer
start = proc.time()

# set seed
set.seed(489)

# perform replications
results = foreach(i = 1:nrep, .packages = c("nFactors", "sparsepca", "pcaMethods", "ltsspca")) %dorng% {
  
  # data generation
  data = generateSettings(k = 3, s =10, error.sd = 0.1)
  
  # get true values and data matrix X
  X.data = data[[1]]
  
  # center and scale data
  mod.X.data = scale(X.data, center = TRUE, scale = TRUE)
  
  # trueK from generated settings
  trueK = 3
  
  # trueScores - U * D
  trueScores = data[[2]] %*% data[[4]]
  trueLoadings = data[[3]]
  
  # apply methods
  estK = selectK(mod.X.data)
  
  # evaluate accuracy of k
  evalK = testK(k = trueK, khat = estK)
  
  ### rspca 
  outRSPCA = applyRSPCA(X = mod.X.data, k = 3)
  
  # metrics for rspca
  rspcaCD = testChordalDist(V = trueLoadings, Vhat = outRSPCA[[1]])
  rspcaUDV = testUDV(
    loadings = trueLoadings,
    loadingshat = outRSPCA[[1]],
    scores = trueScores,
    scoreshat = outRSPCA[[2]]
  )
  rspcaScores = testScores(scores = trueScores, scoreshat = outRSPCA[[2]])
  
  ### spca
  outSPCA = applySPCA(X = mod.X.data, k = 3)
  
  # metrics for spca
  spcaCD = testChordalDist(V = trueLoadings, Vhat = outSPCA[[1]])
  spcaUDV = testUDV(
    loadings = trueLoadings,
    loadingshat = outSPCA[[1]],
    scores = trueScores,
    scoreshat = outSPCA[[2]]
  )
  spcaScores = testScores(scores = trueScores, scoreshat = outSPCA[[2]])
  
  ### nlpca
  outNLPCA = applyNLPCA(X = mod.X.data, k = 3)
  nlpcaScores = testScores(scores = trueScores, scoreshat = outNLPCA[[2]])
  
  ### spca_rsvd
  outRSVD = applyRSVD(X = mod.X.data, k = 3)
  
  # metrics for spca_rsvd
  rsvdCD = testChordalDist(V = trueLoadings, Vhat = outRSVD[[1]])
  rsvdUDV = testUDV(
    loadings = trueLoadings,
    loadingshat = outRSVD[[1]],
    scores = trueScores,
    scoreshat = outRSVD[[2]]
  )
  rsvdScores = testScores(scores = trueScores, scoreshat = outRSVD[[2]])
  
  
  # list for output of metrics
  output = list(
    metricK = evalK,
    metricV = c(rspcaCD, spcaCD, rsvdCD),
    metricUDV = c(rspcaUDV, spcaUDV, rsvdUDV),
    metricScores = c(rspcaScores, spcaScores, nlpcaScores, rsvdScores)
  )
}

# stop timer
print(proc.time() - start)

# stop cluster
stopCluster(cl)

# save resulting result as output of simulation
filename.rdata = paste0("Simulations/Outputs/sim_setting6_resultsv2", nrep,".Rdata")
save(results, file = filename.rdata)