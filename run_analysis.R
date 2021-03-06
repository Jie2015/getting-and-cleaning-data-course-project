# getting-and-cleaning-data-course-project
library(reshape2) 
 

 filename <- "getdata_dataset.zip" 
 

 ## Download and unzip the dataset: 
 if (!file.exists(filename)){ 
   fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip " 
   download.file(fileUrl, filename) 
 }   
if (!file.exists("UCI HAR Dataset")) {  
    unzip(filename)  
 } 


# Load activity labels + features 
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt") 
activityLabels[,2] <- as.character(activityLabels[,2]) 
features <- read.table("UCI HAR Dataset/features.txt") 
features[,2] <- as.character(features[,2]) 
 

# Extract only the data on mean and standard deviation 
newfeatures <- grep(".*mean.*|.*std.*", features[,2]) 
newfeatures.names <- features[newfeatures,2] 
newfeatures.names = gsub('-mean', 'Mean',newfeatures.names) 
newfeatures.names = gsub('-std', 'Std', newfeatures.names) 
newfeatures.names <- gsub('[-()]', '', newfeatures.names) 


 

# Load the datasets 
train <- read.table("UCI HAR Dataset/train/X_train.txt")[newfeatures] 
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt") 
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt") 
train <- cbind(trainSubjects, trainActivities, train) 


test <- read.table("UCI HAR Dataset/test/X_test.txt")[newfeatures] 
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt") 
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt") 
test <- cbind(testSubjects, testActivities, test) 


 # merge datasets and add labels 
allData <- rbind(train, test) 
colnames(allData) <- c("subject", "activity", newfeatures.names) 
 # turn activities & subjects into factors 
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2]) 
allData$subject <- as.factor(allData$subject) 


allData.melted <- melt(allData, id = c("subject", "activity")) 
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean) 


write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE) 






