# PCA-CGM-Project
# Identifying Significant Factors in CGM Data

## Background:
This repository contains files from a project that was completed as part of a special topics class in the Texas A&M University (TAMU) Department of Statistics under the guidance of Dr. Irina Gaynanova, an associate professor in the department.

## Project Description:

The dataset being used for this project contains summary statistics, or metrics, drawn from Continuous Glucose Monitor (CGM) data. Some of the metrics in the CGM data are highly related, or correlated (e.g. range and interquartile range, percent of data above 140 mg/dL, above 180 mg/dL, and above 250 mg/dL), which can make interpreting the original data difficult and time consuming. Applying PCA would reduce the number of features while retaining most of the variability from the original data. In particular, applying sparse PCA methods would take only the most correlated subset of original features to build the principal components, or "super-features", to make the data even more interpretable.
The goal of the project is to compare existing PCA methods performance in simulations to examine behavior under different settings of amount of error, rank of signal matrix, and sparsity. Then we apply the methods to the CGM data and determine if the methods were effective in reducing dimensionality and creating "superfeatures".

## Notes on file/folder organization:

The files contained in this repository are limited compared to the original project. For instance, the "Testing" folder was omitted, and the "Figures" folders were not included. To more simply represent R programming ability, one of six simulations were included due to the code being essentially the same. 

The two executable files to run are Simulation6.R and ApplyCGMData.R, which both call functions written in the Methods.R and Metrics.R files. Simulation6.R also calls functions written in the DataGeneration.R folder. It is recommended to change nrep = 1 in Simulation6.R to not overwhelm the computer for testing purposes.

 - **install_packages.R**: file meant to be run once on a new machine to install necessary packages.

 - **CGMData**: *Data* folder contains data, *Figures* folder is used to store figures (pdf outputs), *Outputs* folder is used to store intermediate outputs as needed (.Rda files). Clean data analysis scripts representing final application of methods on the data are stored as .R files directly within CGMData folder
 
 - **Functions**: stores .R scripts that contain **Functions only**. No function applications, no testing of functions, etc. The function scripts are separated into *Methods.R* (here the method wrappers go), *DataGeneration.R* (here the functions to generate simulated data go), *Metrics.R* (here the functions to evaluate the performance go). R scripts named and organized logically to reflect the functions within.
 
 - **Simulations**: *Figures* folder is used to store figures (pdf outputs), *Outputs* folder is used to store intermediate outputs as needed (.Rda files). Clean simulation scripts representing final application of methods on the artificial data are stored as .R files directly within Simulations folder. 
 
 Special thanks to Dr. Irina Gaynanova who served as the faculty advisor and mentor for this project.
