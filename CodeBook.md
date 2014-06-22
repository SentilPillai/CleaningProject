Code Book 
=========

This code book describes the variables, the data, and transformation work performed to clean the data to produce the tidy data output file. 


Human Activity Recognition Using Smartphones Data set Version 1.0
----------------------------------------------------------------
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Universit degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws


The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 


Study design
============


Raw data
--------

A full description of raw data is available at the below linked web site

HTTP://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The raw data for this project needs to be downloaded from the following URL

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Each record is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

    
Contents of downloaded dataset 
------------------------------
The following data files are read into data frames by the run_analysis.R program for analysis

- 'features.txt': A list of identifier, with of all 561 measured features labeled (from accelerometer and gyroscope).
```{r}
str(features)
'data.frame':    561 obs. of  2 variables:
 $ feature_id  : int  1 2 3 4 5 6 7 8 9 10 ...
 $ feature_name: Factor w/ 477 levels "angle(tBodyAccJerkMean),gravityMean)",..: 243 244 245 250 251 252 237 238 239 240 ...
``` 
 
- 'activity_labels.txt':  Links the class labels with their activity name. List of the six activities the performed by the subjects.
```{r}
str(activities)
'data.frame':    6 obs. of  2 variables:
 $ activity_id  : int  1 2 3 4 5 6
 $ activity_name: Factor w/ 6 levels "LAYING","SITTING",..: 4 6 5 2 3 1
``` 
 
 
- 'test/subject_test.txt': Each row identifies the test subject who performed the activity for each window sample. Its range is from 1 to 30.
```{r}
str(test.subjects)
'data.frame':    2947 obs. of  1 variable:
 $ subject_id: num  2 2 2 2 2 2 2 2 2 2 ...
```

- 'train/subject_train.txt': Each row identifies the training subject who performed the activity for each window sample. Its range is from 1 to 30. 
```{r}
str(training.subjects)
'data.frame':    7352 obs. of  1 variable:
 $ subject_id: num  1 1 1 1 1 1 1 1 1 1 ...
```

- 'test/y_test.txt': Test labels. The test activity that corresponds to each row
```{r}
str(test.data.label)
'data.frame':    2947 obs. of  1 variable:
 $ activity_id: num  5 5 5 5 5 5 5 5 5 5 ...
``` 

- 'train/y_train.txt': Training labels. The training activity that corresponds to each row
```{r}
str(training.data.label)
'data.frame':    7352 obs. of  1 variable:
 $ activity_id: num  5 5 5 5 5 5 5 5 5 5 ...
``` 

- 'test/X_test.txt': Contains the measurement data of the test set. Each row has a 561-feature vector
```{r}
str(test.data.set)
'data.frame':    2947 obs. of  561 variables:
 $ tBodyAccmeanX                    : num  0.257 0.286 0.275 0.27 0.275 ...
 560 ... [list output truncated]
``` 

- 'train/X_train.txt': Contains the measurement data of the training set. Each row has a 561-feature vector
```{r}
str(training.data.set)
'data.frame':    7352 obs. of  561 variables:
 $ tBodyAccmeanX                    : num  0.289 0.278 0.28 0.279 0.277 ...
``` 


The data in following two directory were not read or used in analysis 

- 'test/Inertial Signals/'

- 'train/Inertial Signals/'

The following files were information only; not read by the program  

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.


Transformations
---------------

* Concatenate the test and training data sets into new DF (data frames).

    subjects data sets (test.subjects, training.subjects) concatinated into all.subjects DF

    activity lables (test.data.label,training.data.label) are concatinated into all.data.label DF
  
    join all.data.label DF and activities DF by activity_id to create a new all.data.activities DF with acitivity id and acitivity name  
   
    data sets (test.data.set,training.data.set) are concatinated into all.data.set DF
  

* Merge the above DF sets columns to create one data set.

    create a merged.data DF with columns all.subjects$subject_id , all.data.activities$activity_name and all (561) feature columns of all.data.set DF


* Extracts only the measurements on the mean and standard deviation for each measurement.

    The measurement or feature names was examined by grep  

    greping for the word 'mean' or 'std' in the feature names 
    
    `grep( "mean|std",features$feature_name, value=TRUE)` produced 79 features; this would including meanFreq(): Weighted average of the frequency components to obtain a mean frequency.

    greping for feature names ending with 'mean()' or 'std()'
    
    `grep( "mean\\(\\)$|std\\(\\)$",features$feature_name, value=TRUE)` produced 18 features; this would excluding  "...-mean()-Z,...-std()-Y " ending with -X,or -Y or -Z, measured along the 3 axials.
    
    greping for the words 'mean() or std()' in the feature names
    
    `grep( "mean\\(\\)|std\\(\\)",features$feature_name, value=TRUE)` produced 66 features; This critera was chosen for extraction of features. 

* Use of descriptive labels in the data set

    The following four characters were removed 
    ')' '(' ',' '-' from the labels

   
Output data sets
----------------

The following two output files are save to the current directory for further analysis..

* tidy-output.txt

    A 180 x 68 data frame, 30 subjects and 6 activities produces 180 rows in the data set 
    
    First column contains subject's IDs
    
    Second column contains activity names
    
    Columns 3...68 contains the averages for each of the 66 measurement attributes
    
* merged-narrow-output.txt

    A 10299 x 68 data frame, 7352 training subjects measurments + 2947 test subjects measurments equal 10299 rows in data set
    
    First column contains subject's IDs
    
    Second column contains activity names
    
    Columns 3...68 contains all the observations for each of the 66 measurement attributes
    
