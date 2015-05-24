# Code Book for Getting and Cleaning Data Course Project

This document is for the code in 'run_analysis.R'.

## Input

* Data is downloaded from the UCI HAR .zip file provided in the course project notes.
* It is stored in a randomly generated file name while the needed data is extracted. The temp file is then deleted.
* 'features' contains the information in 'features.txt'
* 'activity_labels' contains the information in 'activity_labels.txt', with the columns renamed to ActivityID and ActivityName
* 'x_train' and 'x_test' contain the information from 'X_train.txt' and 'X_test.txt' respectively. 
* 'y_train' and 'y_test' contain the information from 'y_train.txt' and 'y_test.txt', with the input column renamed to ActivityID.
* 'subject_train' and 'subject_test' contain the information from 'subject_train.txt' and 'subject_test.txt', with the input column renamed to SubjectID.

## Data Cooking

* We first determine the "important columns" - that is, the columns specifying the mean and/or standard deviation, by processing 'features' to search for anything containing 'mean' or 'std'. The feature IDs are stored in 'important_measurement_column_indices' and the feature names in 'important_measurement_column_names'
* We then take both x tables, prune them to keep only these columns, and then rename the columns. Output of this step are the tables 'x_train_pruned' and 'x_test_pruned'
* The training and the test data (containing the subject, y, and X tables) are merged independently into the tables 'training_data' and 'test_data', then merges these into 'merged_data_initial'
* Activity names are joined into the table resulting in 'merged_data_with_activity_name'
* We melt the table by SubjectID and ActivityName, producing the DT 'merged_data_melted'
* Finally we ddply the table to get the mean of each variable per activity and subject, into the DT 'tidy_data'

The data at this point is in long format and appears like so:
```
       SubjectID ActivityName             variable        mean
    1          1       LAYING    tBodyAcc-mean()-X  0.22159824
    2          1       LAYING    tBodyAcc-mean()-Y -0.04051395
    3          1       LAYING    tBodyAcc-mean()-Z -0.11320355
    4          1       LAYING     tBodyAcc-std()-X -0.92805647
    5          1       LAYING     tBodyAcc-std()-Y -0.83682741
    6          1       LAYING     tBodyAcc-std()-Z -0.82606140
    7          1       LAYING tGravityAcc-mean()-X -0.24888180
    8          1       LAYING tGravityAcc-mean()-Y  0.70554977
    9          1       LAYING tGravityAcc-mean()-Z  0.44581772
    10         1       LAYING  tGravityAcc-std()-X -0.89683002
```

# Output
We write the result to the file 'gacCourseProject.txt' in the local directory with row.name=FALSE
using write.table