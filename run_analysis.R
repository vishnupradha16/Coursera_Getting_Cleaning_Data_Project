# R Script "run_analysis.R"

# Download .zip file and save to directory
file_url <- "
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file_url,destfile = "./R Workfiles/UCI_dataset.zip")

#Unzip .zip file to directory using unzip() command
unzip(zipfile="./R Workfiles/UCI_dataset.zip",exdir="./R Workfiles")

# Read training dataset 
x_train <- read.table("./R Workfiles/UCI_dataset/train/x_train.txt")
y_train <- read.table("./R Workfiles/UCI_dataset/train/y_train.txt")
subject_train <- read.table("./R Workfiles/UCI_dataset/train/subject_train.txt")

# Read test dataset
x_test <- read.table("./R Workfiles/UCI_dataset/test/X_test.txt")
y_test <- read.table("./R Workfiles/UCI_dataset/test/y_test.txt")
subject_test <- read.table("./R Workfiles/UCI_dataset/test/subject_test.txt")

# Reading feature vector
features <- read.table('./R Workfiles/UCI_dataset/features.txt')

# Reading activity labels
activityLabels = read.table('./R Workfiles/UCI_dataset/activity_labels.txt')

# Assign field/variable names
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
colnames(activityLabels) <- c('activityId','activityType')

# Merge datasets into one
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
merged_all <- rbind(mrg_train, mrg_test)

# Extract mean and SD for each measurement
    # Extract column names into vector
    colNames <- colnames(merged_all)

    # Create vector to identify ID, mean and SD
    mean_and_std <- (grepl("activityId" , colNames) | 
                     grepl("subjectId" , colNames) | 
                     grepl("mean.." , colNames) | 
                     grepl("std.." , colNames) 
)

    # Subset data from merged_data 
    setForMeanAndStd <- merged_all[ , mean_and_std == TRUE]
    
    # Set activity labels
    setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                                  by='activityId',
                                  all.x=TRUE)
    
# Create tidy dataset
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]
    
# Write tidy dataset into new .txt file
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)
