Input data is stored in multiple files:
  * activity_labels.txt - holds labels for activities performed by subjects during measurements
  * features.txt - holds names of the variables measured in each measurement with single subject
  
  *separated into training and test sets*
  * subject_{train|test}.txt - holds list of subject IDs that measurements were performed on
  * X_{train|test}.txt - holds values for each of variables measured for each subject during specific activity
  * y_{train|test}.txt - holds IDs of the activity performed by subject during measument
  
  Assignment steps:

  1. Merges the training and the test sets to create one data set. Is carried out by call to "merge_training_and_test_sets" function which makes
  2 calls for "construct_tidy_dataset" function provided with string specifying if training or test data set is to be used. 
  Inside that function a data frame is constructed from subject IDs column (subject file), activity column (from y file, but replaced with 
  human-readable string from activity_labels rather than ID) and variable values from X file, annotated via setting colnames to 'Subject', 
  'Activity' and list of feature names from features.txt respectively.
  
  2.  Extracts only the measurements on the mean and standard deviation for each measurement. Is performed with call to "filter_mean_and_std"
  fucntion that returns a subset of provided data frame containing columns ignored by the filter and having its name contain 'mean()' or 'std()' 
  substring. 
  
  3.  Uses descriptive activity names to name the activities in the data set. Human-readable activity descriptions are appended to data frame on step 1.
  
  4.  Appropriately labels the data set with descriptive variable names. Variable names from features.txt are used to set column names on step 1.
  Also characters inappropriate for column names are stripped off.
  
  5.  Creates a second, independent tidy data set with the average of each variable for each activity and each subject. Is performed with call to
  "create_new_dataset" function. Internally uses function ddply from plyr package to apply colMeans on columns of interest.
  
  Function "save_dataset" is called as the last step to save tidy data set using "write.table" function to file 'new_tidy_data.txt' without row names.
