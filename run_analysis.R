# Load necessary libraries
library(dplyr)

# 1. Download and unzip the dataset
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "dataset.zip")
unzip("dataset.zip")

# 2. Load the datasets
# Training Data
train_x <- read.table("UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("UCI HAR Dataset/train/Y_train.txt")
train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Test Data
test_x <- read.table("UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("UCI HAR Dataset/test/Y_test.txt")
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt")

# 3. Merge the training and test data
x_data <- rbind(train_x, test_x)
y_data <- rbind(train_y, test_y)
subject_data <- rbind(train_subject, test_subject)

# 4. Load feature names and filter columns for mean and standard deviation
features <- read.table("UCI HAR Dataset/features.txt")
mean_std_features <- grep("mean\\(\\)|std\\(\\)", features$V2)

# Subset the data to include only mean and standard deviation features
x_data <- x_data[, mean_std_features]
colnames(x_data) <- features$V2[mean_std_features]

# 5. Use descriptive activity names to name the activities in the dataset
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
y_data$V1 <- factor(y_data$V1, levels = activity_labels$V1, labels = activity_labels$V2)
colnames(y_data) <- "activity"

# 6. Label the data with descriptive variable names
colnames(subject_data) <- "subject"
combined_data <- cbind(subject_data, y_data, x_data)

# 7. Create a second tidy dataset with the average of each variable for each activity and each subject
tidy_data <- combined_data %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

# 8. Write the tidy dataset to a text file
write.table(tidy_data, "tidy_data.txt", row.names = FALSE)
