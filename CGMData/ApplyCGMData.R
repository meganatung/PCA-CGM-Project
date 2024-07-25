# applying methods to data

# load real data
load("CGMData/Data/CGMvisit1metrics_masked.Rda")

# source methods
source("Functions/Methods.R")

# libraries
library(nFactors)
library(sparsepca)
library(ltsspca)
library(pcaMethods)
library(ggplot2)

# change to matrix
X= as.matrix(metrics)

# fix the missing value
ind = which(is.na(X), arr.ind = TRUE)
X[ind] = mean(X[, ind[2]], na.rm = TRUE)

# Remove the id column
X = X[, -1]

# center and scale data
X = scale(X, center = TRUE, scale = TRUE)

# get names of features
features = names(metrics)
# remove id label
features = features[-1]


### apply methods ###

# choose rank
khat = selectK_nBartlett(X)

# pca methods
outRSPCA = applyRSPCA(X, khat)
outSPCA = applySPCA(X, khat)
outNLPCA = applyNLPCA(X, khat)
outRSVD = applyRSVD(X, khat)

# extract scores
scoresRSPCA = as.data.frame(outRSPCA$scores)
scoresSPCA = as.data.frame(outSPCA$scores)
scoresNLPCA = as.data.frame(outNLPCA$scores)
scoresRSVD = as.data.frame(outRSVD$scores)

# extract feature names for sparse methods (rspca, spca, spca-rsvd)

# rspca
loadingsRSPCA = outRSPCA$loadings
featureInd = list()
featuresRSPCA = list()

# iterate through each col (each PC)
for(i in c(1:4)) { 
  featureInd[[i]] = which(loadingsRSPCA[,i] != 0)
  featuresRSPCA[[i]] = features[featureInd[[i]]]
}


# spca
loadingsSPCA = outSPCA$loadings
# re-initialize indexes
featureInd = list()
featuresSPCA = list()

# iterate through each col (each PC)
for(i in c(1:4)) { 
  featureInd[[i]] = which(loadingsRSPCA[,i] != 0)
  featuresSPCA[[i]] = features[featureInd[[i]]]
}

# spca rsvd

loadingsRSVD = outRSVD$loadings
# re-initialize indexes
featureInd = list()
featuresRSVD = list()

# iterate through each col (each PC)
for(i in c(1:4)) { 
  featureInd[[i]] = which(loadingsRSVD[,i] != 0)
  featuresRSVD[[i]] = features[featureInd[[i]]]
}

# output
resultsCGM = list(rank = khat,
                        scoresRSPCA = scoresRSPCA,
                        scoresSPCA = scoresSPCA,
                        scoresNLPCA = scoresNLPCA,
                        scoresRSVD = scoresRSVD,
                        featuresRSPCA = featuresRSPCA,
                        featuresSPCA = featuresSPCA,
                        featuresRSVD = featuresRSVD)


### figures for PCs 1 & 2 ###

# unnecessary
# load("~/PCATeamSpring22/CGMData/Outputs/resultsCGM.Rdata")

# set palette
# brown, dark blue, med blue, light blue, red
fillings = c("#CCA474", "#30545F", "#40798C", "#70A9A1", "#851E2F")

scoresRSPCA = resultsCGM$scoresRSPCA

# plot for rspca PCs 1 and 2
plotRSPCA = ggplot(data = scoresRSPCA, aes(x = scoresRSPCA[,1], y = scoresRSPCA[,2])) +
  geom_point(color = fillings[2]) + 
  xlim(c(-15, 15)) +
  ylim(c(-15, 15)) + 
  ggtitle("RSPCA Principal Components 1,2") +
  xlab("PC1") + ylab("PC2")
print(plotRSPCA)
#pdf(file = paste("CGMData/Figures/rspca_pc_fig.pdf"),width = 9, height = 7)
#dev.off()

# plot for spca PCs 1 and 2

scoresSPCA = resultsCGM$scoresSPCA
plotSPCA = ggplot(data = scoresSPCA, aes(x = scoresSPCA[,1], y = scoresSPCA[,2])) +
  geom_point(color = fillings[3]) + 
  xlim(c(-15, 15)) +
  ylim(c(-15, 15)) + 
  ggtitle("SPCA Principal Components 1,2") +
  xlab("PC1") + ylab("PC2")
print(plotSPCA)
#pdf(file = paste("CGMData/Figures/spca_pc_fig.pdf"),width = 9, height = 7)
#dev.off()

# plot for nlpca PCs 1 and 2

scoresNLPCA = resultsCGM$scoresNLPCA
plotNLPCA = ggplot(data = scoresNLPCA, aes(x = scoresNLPCA[,1], y = scoresNLPCA[,2])) +
  geom_point(color = fillings[5]) + 
  xlim(c(-15, 15)) +
  ylim(c(-15, 15)) + 
  ggtitle("NLPCA Principal Components 1,2") + 
  xlab("PC1") + ylab("PC2")
print(plotNLPCA)
#pdf(file = paste("CGMData/Figures/nlpca_pc_fig.pdf"),width = 9, height = 7)
#dev.off()

# plot for spca_rsvd PCs 1 and 2
scoresRSVD = resultsCGM$scoresRSVD
plotRSVD = ggplot(data = scoresRSVD, aes(x = scoresRSVD[,1], y = scoresRSVD[,2])) +
  geom_point(color = fillings[4]) +
  xlim(c(-15, 15)) +
  ylim(c(-15,15)) +
  ggtitle("SPCA RSVD Principal Components 1,2") + 
  xlab("PC1") + ylab("PC2")
print(plotRSVD)
#pdf(file = paste("CGMData/Figures/spcarsvd_pc_fig.pdf"),width = 9, height = 7)
#dev.off()