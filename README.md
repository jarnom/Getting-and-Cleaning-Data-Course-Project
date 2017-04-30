# Getting-and-Cleaning-Data-Course-Project

This file describes how the run_analysis.R script works. Read the codebook.md for details about the variables and prerequisites for running the run_analysis.R script.


## Functions

the script has the following functions:

### merge_files()

Merges the training and the test sets to create one data set. If merged dataset doesn't exist, the function creates it.


### extract_mean_and_std()

Extract only the measurements on the mean and standard deviation for each measurement from the loaded data set.

### name_activities()

Give descriptive activity names to name the activities in the data set from the activity_labels.txt file.

### label_subject()

Appropriately label the subject data with subject label.

### label_dataset()

Appropriately label the signal data  with descriptive variable names.

### create_summary_dataset()

Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
