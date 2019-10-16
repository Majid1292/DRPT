---
authors: "Majid Afshar and Hamid Usefi"
date: '01/10/19'
---

## Notice
The code `DRPT.m` is available now and a link to the paper will be provided soon. If you need more details and explanation about the algorithm, please contact [Majid Afshar](http://www.cs.mun.ca/~mman23/) or [Hamid Usefi](http://www.math.mun.ca/~usefi/).

## Use case
To determine the most important features using the algorithm described in "High-Dimensional Feature Selection for Genomic Datasets" by Majid Afshar and Hamid Usefi

Here is a link to the paper: will be updated after acceptance.
## Compile
This code can be run using MATLAB R2008a and above

## Run
To  run the code, open `DRPT.m` and pick a dataset to apply the method. The code strats reading the selected dataset using `readLargeCSV.m` written by [Cedric Wannaz](https://www.mathworks.com/matlabcentral/profile/authors/1078046-cedric-wannaz). Then it selects the most important features and find the best subset by looking at the classification accuracies calculated by `cAcc.m`. In the end, a subset with the best accuracy along with a standard deviation of # of selected features and classification accuracies will be returned as the output. 

## Datasets
All datasets must be stored in *datasets* folder in your *Documents* folder. We use datasets from [Gene Expression Omnibus (GEO)](https://www.ncbi.nlm.nih.gov/geo/) and datasets can be cleaned by this [code](https://github.com/jracp/NCBIdataPrep). Note that datasets should have no column and/or row names, and the class values should be all numeric.
