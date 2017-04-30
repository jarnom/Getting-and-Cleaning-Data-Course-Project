run_analysis <- function() {
  
  # 1. Merge the training and the test sets to create one data set.
  merge_files <- function(files_list, source) {
    # Read test data to data frame
    for (file in files_list){
      
      # if the merged dataset doesn't exist, create it
      if (!exists("dataset")){
        dataset <- read.table(file)
        if(basename(file) == 'X_test.txt' | basename(file) == 'X_train.txt') {
          dataset <- extract_mean_and_std(dataset)
        }     
        if(basename(file) == 'y_test.txt' | basename(file) == 'y_train.txt') {
          dataset <- name_activities(dataset)
        }    
        if(basename(file) == 'subject_test.txt' | basename(file) == 'subject_train.txt') {
          dataset <- label_subject(dataset)
        }         
      }
      
      # if the merged dataset does exist, append to it
      if (exists("dataset")){
        temp_dataset <-read.table(file)
        if(basename(file) == 'X_test.txt' | basename(file) == 'X_train.txt') {
          temp_dataset <- extract_mean_and_std(temp_dataset)
        }    
        if(basename(file) == 'y_test.txt' | basename(file) == 'y_train.txt') {
          temp_dataset <- name_activities(temp_dataset)
        }       
        if(basename(file) == 'subject_test.txt' | basename(file) == 'subject_train.txt') {
          temp_dataset <- label_subject(temp_dataset)
        }         
        dataset<-cbind(dataset, temp_dataset)
        rm(temp_dataset)
      }
    }
    
    # add column for data source
    #dataset$source <- source
    
    dataset
  }  
  
  # 2. Extract only the measurements on the mean and standard deviation for each measurement.
  extract_mean_and_std <- function(dataset) {
    
    # read features from file
    features <- read.table('./UCI HAR Dataset/features.txt')
    
    # extract mean() and std() rows from features
    mean_cols <- grep('.*mean\\(\\).*',features$V2)
    std_cols <- grep('.*std\\(\\).*',features$V2)
    #target_features <- features[ ,c(mean_cols, std_cols)]
    
    # rename col names from features file
    dataset <- label_dataset(dataset, features)

    # select mean() and std() columns fom dataset
    dataset <- dataset[ ,c(mean_cols, std_cols)]
    dataset
  }
  
  # 3. Use descriptive activity names to name the activities in the data set
  name_activities <- function(dataset) {
    names(dataset)[1]<-paste("activity") 
    activity_labels <- read.table('./UCI HAR Dataset/activity_labels.txt', col.names = c('id', 'activity_label'))
    dataset <- merge(dataset, activity_labels, by.x = "activity", by.y = "id", all.x = TRUE)    
    dataset <- dataset %>% select(-activity)
    dataset
  }
  
  # 4. Appropriately label the data set with descriptive variable names.
  
  # Label subject data column
  label_subject <- function(dataset) {
    names(dataset)[1] <- paste("subject")
    dataset
  }
  
  # Label training and test set features columns
  label_dataset <- function(dataset, features) {

    for (i in c(1:ncol(dataset))) {
      col_name <- features[i,2]
      names(dataset)[i] <- paste(col_name) 
    }
    dataset
  }
  
  # 5. From the data set in step 4, create a second, independent tidy data set with the average of 
  # each variable for each activity and each subject. 
  create_summary_dataset <- function(dataset) {
    summary_dataset <- dataset %>% 
      group_by(activity_label, subject) %>% 
      summarise_all(mean)
    
    summary_dataset
  }
  
  # List all .txt files with relative path
  test_files_list <- list.files('./UCI HAR Dataset/test/', pattern = ".*\\.txt$", full.names=TRUE, recursive=FALSE)
  train_files_list <- list.files('./UCI HAR Dataset/train/', pattern = ".*\\.txt$", full.names=TRUE, recursive=FALSE)
  
  # Bind data sets
  test_dataset <- merge_files(test_files_list, source='test')
  train_dataset <- merge_files(train_files_list, source='train')
  dataset <- rbind(test_dataset, train_dataset)
  
  # remove dublicate col names
  dataset <- dataset[, !duplicated(colnames(dataset))]
  
  # return summary dataset from function
  summary_dataset <- create_summary_dataset(dataset)
  summary_dataset
}