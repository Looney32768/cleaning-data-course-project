dataDir <- 'UCI HAR Dataset'
subject_data_name = 'subject'
features_data_name = 'X'
activities_data_name = 'y'
data_file_extension = '.txt'
feature_names = read.table(sprintf('%s/features.txt', dataDir))
activity_labels = read.table(sprintf('%s/activity_labels.txt', dataDir))

run_analysis <- function() {
    tidy <- merge_training_and_test_sets()
    tidy <- filter_mean_and_std(tidy)
    new_ds <- create_new_dataset(tidy)
    save_dataset(new_ds)
}

save_dataset <- function(df) {
    write.table(df, file='new_tidy_data.txt', row.names=F)
}

create_new_dataset <- function(df, ignore_mean_for_columns = c('Subject', 'Activity')) {
    ignore_col_indices <- which(colnames(df) %in% ignore_mean_for_columns)
    ds <- ddply(df, ignore_mean_for_columns, function(df) colMeans(df[, -ignore_col_indices]))
    colnames(ds)[-ignore_col_indices] <- paste(colnames(ds)[-ignore_col_indices], "_mean", sep='')
    ds
}

filter_mean_and_std <- function(df, not_filtered_indices = c(1,2)) {
    matching_columns <- grep('(mean()|std())', colnames(df))
    df[, c(not_filtered_indices, matching_columns)]
}

merge_training_and_test_sets <- function(train_dataset = 'train',
                                         test_dataset = 'test') {
    rbind(construct_tidy_dataset(train_dataset), construct_tidy_dataset(test_dataset))    
}

construct_tidy_dataset <- function(dataset) {
    prefix <- sprintf('%s/%s/', dataDir, dataset)
    postfix <- sprintf('_%s%s', dataset, data_file_extension)
    tidy <- read.table(sprintf('%s%s%s', prefix, subject_data_name, postfix))
    features <- read.table(sprintf('%s%s%s', prefix, features_data_name, postfix))
    activities <- read.table(sprintf('%s%s%s', prefix, activities_data_name, postfix))
    
    colnames(tidy) <- 'Subject'
    tidy['Activity'] = activity_labels[activities$V1, ]$V2
    colnames(features) <- gsub('[(),-]+', '_', feature_names$V2)
    tidy <- cbind(tidy, features)
}
