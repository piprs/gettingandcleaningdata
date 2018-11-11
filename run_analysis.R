library(dplyr)
setwd("C:/Users/M/Desktop/R/data")

#read training data
xTrain <- read.table("C:/Users/M/Desktop/R/data/UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("C:/Users/M/Desktop/R/data/UCI HAR Dataset/train/y_train.txt")
subjectTrain <- read.table("C:/Users/M/Desktop/R/data/UCI HAR Dataset/train/subject_train.txt")

#read testing data
xTest <- read.table("C:/Users/M/Desktop/R/data/UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("C:/Users/M/Desktop/R/data/UCI HAR Dataset/test/y_test.txt")
subjectTest <- read.table("C:/Users/M/Desktop/R/data/UCI HAR Dataset/test/subject_test.txt")

#read features
features <- read.table("C:/Users/M/Desktop/R/data/UCI HAR Dataset/features.txt")

#read activity labels
activities = read.table("C:/Users/M/Desktop/R/data/UCI HAR Dataset/activity_labels.txt")

xData <- rbind(xTrain, xTest)
yData <- rbind(yTrain, yTest)
subjectData <- rbind(subjectTrain, subjectTest)

#Using descriptive activity names to name the activities in the data set
yData[, 1] <- activities[yData[,1], 2]

#Labels data set with variable names
names(subjectData) <- c("subject")
names(yData) <- c("activity")
names(xData) <- features$V2

#Merging the training and test sets to create one data set
mergedData <- cbind(xData,yData,subjectData)

#Extracting only the measurements on the mean and standard deviation for each measurement
mergedDataMeanStd <- grepl("subject|activity|mean|std", colnames(mergedData))
mergedData <- mergedData[, mergedDataMeanStd]

#Creating second, independent tidy data set with the average of each variable for each activity and each subject
tidySet <- aggregate(. ~subject + activity, mergedData, mean)
tidySet <- tidySet[order(tidySet$subject, tidySet$activity),]
write.table(tidySet, file = "tidy.Data.txt", row.name = FALSE)