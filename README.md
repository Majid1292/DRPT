---
Authors: "Majid Afshar and Hamid Usefi"
Date: '01/10/19'
---

## Notice
The code `DRPT.m` is available now, and a link to the paper will be provided soon. If you need more details and explanation about the algorithm, please contact [Majid Afshar](http://www.cs.mun.ca/~mman23/) or [Hamid Usefi](http://www.math.mun.ca/~usefi/).

## Use case
To determine the most important features using the algorithm described in "High-Dimensional Feature Selection for Genomic Datasets" by Majid Afshar and Hamid Usefi

Here is a link to the paper: https://www.sciencedirect.com/science/article/pii/S0950705120305141?dgcid=coauthor

## Compile
This code can be run using MATLAB R2017a and above. Also, the following toolboxes should be installed as the program dependencies:
* Deep Learning Toolbox
* Statistics and Machine Learning Toolbox
* Parallel Computing Toolbox
* Curve Fitting Toolbox

## Run
To  run the code, open `DRPT.m` and pick a dataset to apply the method. The code starts reading the dataset using `readLargeCSV.m` written by [Cedric Wannaz](https://www.mathworks.com/matlabcentral/profile/authors/1078046-cedric-wannaz). We note the dataset does not have any headers (neither the features nor the samples IDs).
An optimal subset of features with the best accuracy along with a standard deviation of the number of selected features and classification accuracies will be returned as the output. 

## Datasets
All datasets must be stored in *datasets* folder in your *Documents* folder. We use datasets from [Gene Expression Omnibus (GEO)](https://www.ncbi.nlm.nih.gov/geo/), and datasets can be cleaned by this [code](https://github.com/jracp/NCBIdataPrep).
