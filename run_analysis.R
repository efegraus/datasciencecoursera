#CourseProject- ExploratoryAnalysis
# 7/26/14
# Eric

# Clear everything
rm(list = ls())
#Load Libraries
library(plyr)
library(data.table)
#Get the dataset
if (!file.exists("data")) {
  dir.create("data")
}
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/courseprojectdata.zip", method = "curl")
dateDownloaded <- date()
dateDownloaded
# Unzip the zip file
unzip("./data/courseprojectdata.zip") 
# Load Datasets
# Question 1: Merges the training and the test sets to create one data set.
# Load Training and Test Labels
a <- colnames(mean_std_data)
b <- a[2:87]


# Load Trianing and Test X Training Sets
# First Load Labels
x_labels <-read.table("./data/UCI HAR Dataset/features.txt")
#4. Appropriately labels the data set with descriptive variable names. 
# Get rid of inappropriate characters in column names and replace with _
x_label_clean <- gsub("[\\(.,\\)-]","_",x_labels$V2)
activity_labels <-read.table("./data/UCI HAR Dataset/activity_labels.txt")

# Load Test Datasets
subject_test <-read.table("./data/UCI HAR Dataset/test/subject_test.txt",col.names="subject")
y_test <-read.table("./data/UCI HAR Dataset/test/y_test.txt")
x_test <-read.table("./data/UCI HAR Dataset/test/X_test.txt",col.names=x_label_clean)
test_data <- cbind(y_test,x_test,subject_test)
#Load Trainging Datasets
subject_train <-read.table("./data/UCI HAR Dataset/train/subject_train.txt",col.names="subject")
y_train <-read.table("./data/UCI HAR Dataset/train/y_train.txt")
x_train <-read.table("./data/UCI HAR Dataset/train/X_train.txt",col.names=x_label_clean)
train_data<-cbind(y_train,x_train,subject_train)

# Combine the training and test datasets
all_data <- rbind(test_data,train_data)

#3 Add in Activity Labels
all_data1<- merge(activity_labels,all_data,by.x="V1",by.y="V1")
setnames(all_data1,"V1","Activity_label_id")
setnames(all_data1,"V2","Activity_label") 

#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
std_data <- all_data1[grep(".*[Ss]td",names(all_data1))] 
mean_data <- all_data1[grep(".*[Mm]ean",names(all_data1))]
mean_std_data <- cbind(all_data1$subject,mean_data,std_data,all_data1$Activity_label)
setnames(mean_std_data,"all_data1$subject","Subject")
setnames(mean_std_data,"all_data1$Activity_label","Activity_label")

#5. Creates a second, independent tidy data set with the average of each 
# variable for each activity and each subject.
# Fix the column names
tidy_data <-aggregate(mean_std_data,by=list(mean_std_data$Subject,mean_std_data$Activity_label),FUN=mean,na.rm=TRUE)
# Clean up tidy data table
tidy_data$Subject <-NULL
tidy_data$Activity_label <-NULL
setnames(tidy_data,"Group.1","Subject")
setnames(tidy_data,"Group.2","Activity_label")
# Write out the table
write.table(tidy_data,"tidy_table.txt")
