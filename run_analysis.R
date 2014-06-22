# set working directory to where data set was unzipped
# setwd("~/Desktop/UCI HAR Dataset/")

# install and load library the necessary tables 
# install.packages("plyr");  library(plyr); install.packages("reshape2"); library(reshape2); 
require(plyr); require(reshape2)

#
# Load data sets
#

# read features class data; name the feature class column names
features <- read.table(file=("features.txt"), col.names=c("feature_id","feature_name"))
# strip ","  "-"  "(" ")" characters from feature_name column and add a new column named feature_alt for the alternate names
features$feature_alt <- gsub("\\(|\\)|\\,|-", "", features$feature_name)
dim(features); # [1] 561   3

# read activity class data;  name the activity class column names                    
activities <- read.table(file=("activity_labels.txt"), col.names=c("activity_id","activity_name"))
dim(activities); # [1] 6 2

# read test subject id's; name the id column name                            
test.subjects <- read.table(file=("test/subject_test.txt"), col.names=c("subject_id"), colClasses="numeric")
dim(test.subjects); # [1] 2947    1

# read training subject id's; name the id column name        
training.subjects <- read.table(file=("train/subject_train.txt"), col.names=c("subject_id"), colClasses="numeric")
dim(training.subjects); # [1] 7352    1 

# read test activity label id's; name the id column name
test.data.label <- read.table(file=("test/y_test.txt"), col.names=c("activity_id"), colClasses="numeric")
dim(test.data.label); # [1] 2947    1

# read training activity label id's; name the id column name
training.data.label <- read.table(file=("train/y_train.txt"), col.names=c("activity_id"), colClasses="numeric")
dim(training.data.label); # [1] 7352    1

# read test data set; name the feature's column names with alternate feature name
test.data.set <- read.table(file=("test/X_test.txt"), col.names=features$feature_alt, colClasses="numeric")
dim(test.data.set);  #  [1] 2947  561

# read training data set; name the features column names with alternate feature name
training.data.set <- read.table(file=("train/X_train.txt"), col.names=features$feature_alt, colClasses="numeric")
dim(training.data.set); #   [1] 7352  561

#
# Merges the training and the test sets to create one data set.
#

# merge the test and training subject data sets
all.subjects <- rbind(test.subjects, training.subjects)
rm(test.subjects); rm(training.subjects); # remove unused data frames
dim(all.subjects); # [1] 10299     1
# table(all.subjects)

# merge the test and training activity labels 
all.data.label <- rbind(test.data.label,training.data.label) 
dim(all.data.label); # [1] 10299     1
# join data frames by activity_id to create a new data frame with activity id and activity name  
all.data.activities  <- join(all.data.label, activities, by="activity_id", match="all",  type="left")
dim(all.data.activities); # [1] 10299     2 ; #  head(all.data.activities)
rm(test.data.label); rm(training.data.label); rm(all.data.label) ; # remove unused data frames

# merge the test and training data sets
all.data.set <- rbind(test.data.set,training.data.set)
rm(test.data.set); rm(training.data.set); # remove unused data frames
dim(all.data.set); # [1] 10299   561

# merge the df columns subject id and activity name with data set 
merged.data <- data.frame("subject"=all.subjects$subject_id, "activity"=all.data.activities$activity_name , all.data.set )
dim(merged.data); # [1] 10299   563 ; # transpose first row as.data.frame(t(head(merged.data,1)))

#
# Extracts only the measurements on the mean and standard deviation for each measurement.
# grep( "mean\\(\\)|std\\(\\)",features$feature_name, value=TRUE)
# 
features$all_std_or_mean <- grepl( "mean\\(\\)|std\\(\\)",features$feature_name)

narrow.data <- merged.data[, c(TRUE,TRUE,features$all_std_or_mean) ]
dim(narrow.data); # [1] 10299    68

write.table(narrow.data, "merged-narrow-output.txt", row.names = FALSE)

#
# Uses descriptive activity names to name the activities in the data set
# names(narrow.data)
# Appropriately labels the data set with descriptive variable names.
# table(narrow.data[,2])

#
# Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#

tidy.data <- aggregate(narrow.data[,3:68], by=list(subject=narrow.data$subject,activity=narrow.data$activity), FUN=mean)
dim(tidy.data); # [1] 180  68

write.table(tidy.data, "tidy-output.txt", row.names = FALSE)


# experiment melting data further 
# melt.data <- melt(tidy.data, id=c("subject","activity"), measure.vars=names(tidy.data[,3:68]))
# dim(melt.data); # [1] 11880     4
# head(melt.data)
# rm(melt.data); rm(melt.read);


# Cleanup :
# rm(activities); rm(features); rm(all.subjects); 
# rm(all.data.activities); rm(all.data.set);
# rm(narrow.data); rm(tidy.data); rm(merged.data);
# gc();
