# First Task

## Preliminary Steps
Here we start reading the tables of each data files. They will be used in the next steps.
```r
features <- read.table("specdata/features.txt", sep = " ")
activity_labels <- read.table("specdata/activity_labels.txt")
test_set <- read.table("specdata/test/X_test.txt")
test_label <- read.table("specdata/test/y_test.txt")
test_subject <- read.table("specdata/test/subject_test.txt")
train_set <- read.table("specdata/train/X_train.txt")
train_label <- read.table("specdata/train/y_train.txt")
train_subject <- read.table("specdata/train/subject_train.txt")
```

## Step 1: Merges the training and the test sets to create one data set.
To do this step, we used *rbind* to bind the data set of *train* and *test* together and store them in *dat*.
We then named the columns of *dat* with the variable names in *features$V2*.
```r
dat <- rbind(train_set, test_set)
names(dat) <- features$V2
```

## Step 2: Extracts only the measurements on the mean and standard deviation for each measurement
To get the measurements on the mean and standard deviation, a useful function called *grep* can do this for us as it filters all the columns that has the name *mean* or *std* in them. We then stored them in *dat_mean_std*.
```r
dat_mean_std <- dat[grep("(mean\\(\\))|(std\\(\\))",names(dat))]
```

## Step 3:  Uses descriptive activity names to name the activities in the dataset
Here, we defined two new data variables that will store the activity labels and the subjects. Again, *rbind* will be used. We then named their columns "Activity" and "Subject".
```r
activity <- rbind(train_label, test_label)
subject <- rbind(train_subject, test_subject)
names(activity) <- "Activity"
names(subject) <- "Subject"
```
Afterwards we combined them together with *dat_mean_std* as they will serve as subjects and activity labels for each the data.
```r
dat_mean_std <- cbind(subject, activity, dat_mean_std)
dat_mean_std$Activity <- activity_labels[dat_mean_std$Activity, 2]
```

## Step 4: Appropriately labels the data set with descriptive variable names
*gsub* is similar to *grep* where it finds patterns that matches the input string, but it replaces it to a new string.
```r
varNames <- names(dat_mean_std)
varNames <- gsub("^t","Time",varNames)
varNames <- gsub("^f|(Freq())","Frequency",varNames)
varNames <- gsub("-|(|)","",varNames)
varNames <- gsub("Acc", "Accelerometer", varNames)
varNames <- gsub("Gyro","Gyroscope", varNames)
varNames <- gsub("Mag", "Magnitude", varNames)
varNames <- gsub("BodyBody","Body", varNames)
varNames <- gsub("mean()","Mean", varNames)
varNames <- gsub("std()", "STD", varNames)
names(dat_mean_std) <- varNames
```

## Step 5: From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
Lastly, we created a new table named *grouped_data* which will store the returned result of *group_by(dat_mean_std, Subject, Activity)*. This *group_by* function takes in an existing table and turns it into a grouped table so that the operations can be performed by group.
We will then used *summary_all()* to summarize the grouped data with the average of each variable for each activity and subject.
*write.table()* will come in handy as it will export the summarized data to a new file named "tidy_data.txt".

```r
grouped_data <- group_by(dat_mean_std, Subject, Activity)
summary_data <- summarize_all(grouped_data, funs(mean))
write.table(summary_data, "tidy_data.txt")
```
