# Getting and Cleaning Data Course Project
# 
# Just a general note, I'm not doing the order of operations (part 1, part 2, etc.) in that
# order, it's easier to do them opportunistically. I'll be calling them out though to make
# it easier for you to grade.

library(data.table)
library(plyr)
library(reshape2)

# First we need to download the file and extract the data tables from it.

# Download file
tempFileName <- tempfile()
fileUri <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUri, tempFileName, mode="wb")

# Extract data directly from zip file. 
features <- read.table(unz(tempFileName, "UCI HAR Dataset/features.txt"))
activity_labels <- read.table(unz(tempFileName, "UCI HAR Dataset/activity_labels.txt"), 
                              col.names=c("ActivityID","ActivityName"))
x_train <- read.table(unz(tempFileName, "UCI HAR Dataset/train/X_train.txt"))
y_train <- read.table(unz(tempFileName, "UCI HAR Dataset/train/y_train.txt"), 
                      col.names=c("ActivityID"))
subject_train <- read.table(unz(tempFileName, "UCI HAR Dataset/train/subject_train.txt"), 
                            col.names=c("SubjectID"))
x_test <- read.table(unz(tempFileName, "UCI HAR Dataset/test/X_test.txt"))
y_test <- read.table(unz(tempFileName, "UCI HAR Dataset/test/y_test.txt"), 
                     col.names=c("ActivityID"))
subject_test <- read.table(unz(tempFileName, "UCI HAR Dataset/test/subject_test.txt"), 
                           col.names=c("SubjectID"))

# Delete the temp zip file.
file.remove(tempFileName)

# Question part 2: Extract only the measurements on the mean and standard deviation for
# each measurement.
# Get the column indices to keep. We'll prune the training/test data now before the merge,
# since that way we won't need to special case the Y/Subject columns.
important_measurement_column_indices <- which(features$V2 %like% "mean" | features$V2 %like% "std")
important_measurement_column_names <- features[important_measurement_column_indices,]$V2

x_train_pruned = x_train[,important_measurement_column_indices]
names(x_train_pruned) <- important_measurement_column_names
x_test_pruned = x_test[,important_measurement_column_indices]
names(x_test_pruned) <- important_measurement_column_names

# Question part 1: Merge training and test data
# We'll merge training and test data sets individually first. It just makes a bit more
# sense to merge two whole data sets (training and test) rather than merge X-train and
# X-test, then Y-train and Y-test, etc. and then merging X/Y/Z. Maybe less prone to
# error.
training_data <- cbind(subject_train, y_train, x_train_pruned)
test_data <- cbind(subject_test, y_test, x_test_pruned)
merged_data_initial <- rbind(training_data, test_data)

# Question part 3: Use descriptive activity names
merged_data_with_activity_name <- join(merged_data_initial, activity_labels, by="ActivityID")

# Question part 5: Create a second, independent tidy data set with the average
# of each variable for each activity and each subject
#
# First melt it to convert it to long format
merged_data_melted <- melt(merged_data_with_activity_name, 
                           id.vars=c("SubjectID","ActivityName"),
                           measure.vars=important_measurement_column_names)
# then get the average value given the same values of SubjectID and ActivityName
tidy_data <- ddply(merged_data_melted, 
                   c("SubjectID","ActivityName","variable"),
                   summarize,
                   mean = mean(value))

write.table(tidy_data, "gacCourseProject.txt", row.names=FALSE)
