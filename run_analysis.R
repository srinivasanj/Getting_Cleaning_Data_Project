### This script is for the Getting and Cleaning Data course assignment on Coursera.
### This script assumes that the current folder the script is run in is the folder with all the data files.
### This script will create a tidy data set in the .txt format.

## Check for required packages and install if necessary
if(!("data.table" %in% installed.packages()))
{
	install.packages.("data.table")
}

if(!("dplyr" %in% installed.packages()))
{
	install.packages.("dplyr")
}

if(!("tidyr" %in% installed.packages()))
{
	install.packages.("tidyr")
}

## Load the installed packages
library(data.table)
# library(dplyr)
# library(tidyr)

## Start reading the input files

## Read the file on the activity names
activity_labels <- read.table("activity_labels.txt",col.names=c("ID","NAME"))

## Read the file on the activity features
features <- read.table("features.txt")

## Read the X_Train and X_Test data
x_train <- read.table("./train/X_train.txt")
x_test <- read.table("./test/X_test.txt")

## Read the y_train and y_test data
y_train <- read.table("./train/y_train.txt")
y_test <- read.table("./test/y_test.txt")

## Read the subject_train and subject_test data
subject_train <- read.table("./train/subject_train.txt")
subject_test <- read.table("./test/subject_test.txt")

## Rename column names for x_test and x_train.

## The column names are from the features.tx file which are stored in the features variable
colnames(x_test) <- features[,2]
colnames(x_train) <- features[,2]

## Name the columns in y_test and y_train
colnames(y_test) <- "Activity_ID"
colnames(y_train) <- "Activity_ID"

## Name the columns in subject_test and subject_train
colnames(subject_test) <- "Subject_ID"
colnames(subject_train) <- "Subject_ID"

## Identify all columns that contain "mean" and "std" in the column name

# Create the variable to extract the columns and store the extracted data in a variable
extractor <- grep("mean|std", names(x_test), ignore.case = TRUE)
newXTest <- x_test[,extractor] # Will only contain columns with "mean" and "std" in the name

# Create the variable to extract the columns and store the extracted data in a variable
extractor <- grep("mean|std", names(x_train), ignore.case = TRUE)
newXTrain <- x_train[,extractor] # Will only contain columns with "mean" and "std" in the name

## All data has been loaded, columns named and the right columns omitted.

# Merge test data and train data by x, y and subject
testDat <- cbind(subject_test, y_test, newXTest)
trainDat <- cbind(subject_train,y_train, newXTrain)

## Combine the test and train data into a single data set
fullDat <- rbind(testDat,trainDat)

## Calculate the mean of every column and group them by subject and activity

# Ensure the fully merged data is of data.table class
fullDat <- data.table(fullDat)

# Calculate the average (mean) of every column and group by subject and activity
finalDat <- fullDat[, lapply(.SD,mean), by=c("Subject_ID", "Activity_ID")]

# Output the final clean and tidy data set into a file for further analysis
write.table(finalDat,"clean_Data.txt")
