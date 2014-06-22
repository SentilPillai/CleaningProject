Getting and Cleaning Data - Coursera project - June 2014 
========================================================

Introduction
------------

The purpose of this project is to demonstrate the ability to collect, work with, and clean data sets. The goal is to prepare tidy data that can be used for later analysis.

The project deliverable s are a link to Git Hub repository with following
* README.md - this file
* CodeBook.md - describes the variables, the data, and any transformations
* run_analysis.R - R script performing the analysis
* tidy-output.txt - tidy data set and merged-narrow-output.txt


Environment
-----------
An environment where R & R Studio is installed is required.

The packages plyr and reshape2 are also required; The code that assumes its installed and libraries are loaded.
If not follow; execute the following commands to install and the load libraries.

```{r}
install.packages("plyr");     library(plyr);
install.packages("reshape2"); library(reshape2);
```

This project's R code was developed and tested using R version 3.0.3 (2014-03-06) on Apple Mac platform "x86_64-apple-darwin10.8.0".

Instruction
-----------
1. Download the below linked raw data zip file to the local environment 

    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

2. Unzip the downloaded zip file to a local current directory 

    e.g. ~/Desktop/UCI HAR Dataset/

3. Download the source code run_analysis.R from below linked git hub URL

    https://github.com/SentilPillai/CleaningProject/run_analysis.R

4. Copy the source code run_analysis.R into the local current directory where data set was downloaded to

5. Set the working directory in R to the local current directory where the data set and code run_analysis.R are
    ```{r}
setwd("~/Desktop/UCI HAR Dataset/")
```

6. Execute the R code in R Studio by  
    ```{r}
source('run_analysis.R', echo=TRUE)
```

7. Check and verify that there are two new files (merged-narrow-output.txt and tidy-data.txt) in the current directory 



Tidy data set
-------------

Verify the output data frames by reading the file back into R Studio
```{r}
tidy.read =  read.table(file=("tidy-data.txt"), comment.char="", header=TRUE)
dim(tidy.read); # [1] 180     68
```

Garbage collect
----------------

```{r}
rm(activities); rm(features); rm(all.subjects);
rm(all.data.activities); rm(all.data.set);
rm(narrow.data); rm(tidy.data); rm(merged.data);

gc();
```

Delete the files in the current directory
