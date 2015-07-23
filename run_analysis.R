#set the path to the folder

#1. Merges the training and the test sets to create one data set

#read data into data frames
setwd("C:\\Users\\kiwi\\Desktop\\06172015\\Data Science\\GetCleanData\\project\\UCI HAR Dataset\\train")
subject_train <- read.table("subject_train.txt")
X_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")
setwd("C:\\Users\\kiwi\\Desktop\\06172015\\Data Science\\GetCleanData\\project\\UCI HAR Dataset\\test")
subject_test <- read.table("subject_test.txt")
X_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")


##3. Uses descriptive activity names to name the activities in the data set
#add column names 
names(subject_train) <- "subjectID"
names(subject_test)  <- "subjectID"
setwd("C:\\Users\\kiwi\\Desktop\\06172015\\Data Science\\GetCleanData\\project\\UCI HAR Dataset")
features   <- read.table("features.txt")
names(X_train) <- features$V2
names(X_test)  <- features$V2
names(y_train) <- "activity"
names(y_test)  <- "activity"
#combine into one dataset 
all_train <- cbind(subject_train, y_train, X_train)
all_test  <- cbind(subject_test, y_test, X_test)
all <- rbind(all_train, all_test)


#2: Extracts only the measurements on the mean and standard deviation for each measurement.
#determine which columns contain "mean()" or "std()"
colMeanStd <- grepl("mean\\(\\)", names(all)) | grepl("std\\(\\)", names(all))
#ensure that we also keep the subjectID and activity columns
colMeanStd[1:2] <- TRUE
#remove unnecessary columns
all <- all[, colMeanStd]

#4. Appropriately labels the data set with descriptive activity names. 

# convert the activity column from integer to factor
all$activity <- factor(all$activity, labels=c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))

#5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
install.packages("reshape2")
library(reshape2)
melted <- melt(all, id=c("subjectID","activity"))
tidyDataSet <- dcast(melted, subjectID+activity ~ variable, mean)
write.table(tidyDataSet, "C:\\Users\\kiwi\\Desktop\\06172015\\Data Science\\GetCleanData\\project\\tidyDataSet.txt", row.names=FALSE)