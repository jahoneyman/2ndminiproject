library(data.table)
library(dplyr)

# Reading files in specdata
features <- read.table("specdata/features.txt", sep = " ")
activity_labels <- read.table("specdata/activity_labels.txt")
test_set <- read.table("specdata/test/X_test.txt")
test_label <- read.table("specdata/test/y_test.txt")
test_subject <- read.table("specdata/test/subject_test.txt")
train_set <- read.table("specdata/train/X_train.txt")
train_label <- read.table("specdata/train/y_train.txt")
train_subject <- read.table("specdata/train/subject_train.txt")

# Step 1
# Merges the training and the test sets to create one data set.
## 'rbind' binds the row of data in 'train_set' and 'test_set', and stores them in 'dat'

dat <- rbind(train_set, test_set)
names(dat) <- features$V2

# ==================================================

# Step 2
# Extracts only the measurements on the mean and standard deviation for each measurement
## 'features$V2' contains the names which will be used to describe each column in dat
## grep takes the first argument as the word to be searched, the second argument is the target of the search
## grep function will find names that have 'mean' or 'std' in the column names in 'features'
## dat_mean_std will store the result of 'dat[grep("mean|std",names(dat))]'

dat_mean_std <- dat[grep("mean|std",names(dat))]

# ==================================================

# Step 3
# Uses descriptive activity names to name the activities in the dataset

activity <- rbind(train_label, test_label)
subject <- rbind(train_subject, test_subject)
names(activity) <- "Activity"
names(subject) <- "Subject"

dat_mean_std <- cbind(subject, activity, dat_mean_std)
dat_mean_std$Activity <- activity_labels[dat_mean_std$Activity, 2]

# ==================================================

# Step 4
# Appropriately labels the data set with descriptive variable names

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

# ==================================================

# Step 5
# From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
grouped_data <- group_by(dat_mean_std, Subject, Activity)
summary_data <- summarize_all(grouped_data, funs(mean))
write.table(summary_data, "tidy_data.txt")
