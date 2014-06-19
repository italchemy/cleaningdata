# #
# 
# A script and associated helper functions to process the UCI HAR Dataset.
# 
# The script should be run in the root directory of the dataset, i.e. in the 
# same directory as the feature and activity description files, along with the 
# "test" and "train" subdirectories.
# 
# The script produces two files:
# 
# musigma_features.csv - a data set comprised of the subject, activity, and mean
# and standard deviation features from the UCI testing and training datasets. 
# See the accompanying code book, or the UCI data set file "features_info.txt" 
# for more information on the variables and their meaning.
# 
# average_values.csv - a data set comprised of the average (mean) value for all 
# of the UCI features, grouped by subject and activity. Again, see the 
# accompanying code book and/or the UCI documentation for more information on 
# the variables and their meaning within this data set.
# 
# * * * WARNING * * *
#
# Both files are created in the script's working directory, i.e. the data set 
# root directory, and the script will overwrite older versions if they exist. In
# other words, back-up or rename the files if you want to preserve them before
# running the script a second time.
# 

require(data.table)

###
#
# mergeDataSet - Merges the subject, activity, and feature vector files of the 
# HCI data into a single datatable.
# 
# The function assumes the files are prefixed with subject_, y_ (for
# activities), and X_ (for feature vectors), and suffixed with the name of the
# provided sub-directory; e.g. X_train.txt, y_test.txt
#
# Arguments:
# 
# directory - the name of a sub-directory within the current working directory 
# that contains the HCI data files
# 
# Returns: a datatable containing the merged data
#
mergeDataSet <- function (directory = character()) {
  
  if ((directory == "") || !file.exists(directory)) {
      stop(paste("Data directory \"", directory, "\" not found in current working directory", sep=""))
  }

  # Generate the names of the subject, activity, and feature files and test to
  # see if they're present
  
  subjectFile <- paste(directory, "/subject_", directory, ".txt", sep="")
  activityFile <- paste(directory, "/y_", directory, ".txt", sep="")
  featureFile <- paste(directory, "/X_", directory, ".txt", sep="")
  
  if (!file.exists(subjectFile)) {
    stop(paste("Subject file \"", subjectFile, "\", not found", sep=""))
  }
  else if (!file.exists(activityFile)) {
    stop(paste("Activity file \"", activityFile, "\", not found", sep=""))    
  } else if (!file.exists(featureFile)) {
    stop(paste("Feature file \"", featureFile, "\", not found", sep=""))    
  }
  
  # Create a single table version of the training data. I'd prefer to use
  # fread() to read all data but there is an known issue in my version of
  # data.table (1.9.2) with reading space-delimited data. Although it's way slow
  # we'll use read.table() instead of using an even slower sed script with fread() to replace
  # the spaces with commas.
  
  subject <- fread(subjectFile)
  activities <- read.table(activityFile)
  
  activity <- matrix(nrow = nrow(activities))
  
  for (i in 1:nrow(activities)) {
    activity[[i,1]] <- activityLabels[activities[[i,1]]]$V2
  }

  features <- read.table(featureFile)
  dataset <- cbind(subject, activity, features)
  setnames(dataset, c("subject", "activity", featureLabels[[2]]))
  
  return(dataset)
  
}

# #
# 
# Main
# 
# The main body of the script. Executes in the root directory of the HCI data
# set.
# 

cleanup <- c("cleanup", "mergeDataSet")

# Pull in 'global' data from the root directory

activityLabelsFile <- "activity_labels.txt"
featureLabelsFile <- "features.txt"
cleanup <- c(cleanup, "activityLabelsFile", "featureLabelsFile")

if (!file.exists(activityLabelsFile)) {
  stop(paste("Activity labels file \"", activityLabelsFile, "\" not found", sep=""))
}

activityLabels <- fread(activityLabelsFile)
setkey(activityLabels)
cleanup <- c(cleanup, "activityLabels")

if (!file.exists(featureLabelsFile)) {
  stop(paste("Feature labels file, \"", featureLabelsFile, "\", not found", sep=""))
}

featureLabels <- fread(featureLabelsFile)
cleanup <- c(cleanup, "featureLabels")

# Create unified versions of the test and training data and merge those into a single datatable

message("Unifying training data...")
trainingSet <- mergeDataSet("train")
message("Unifying test data...")
testSet <- mergeDataSet("test")
message("Merging data sets...")
fullSet <- rbind(trainingSet, testSet)
setkey(fullSet)
cleanup <- c(cleanup, "trainingSet", "testSet", "fullSet")

# Pull out the columns names and remove parentheses because (i) they bug me in 
# variable names, and (ii) they are not usable when referenced in R using the $ 
# notation, i.e. data$somevariable()_X doesn't work. Do the same with hyphens,
# and commas replacing them with underscores.

setnames(fullSet, as.character(lapply(names(fullSet), function(name) { 
  gsub("_$", "",
    gsub("(\\(|\\))", "_",
      gsub("(-|,)", "_", 
        gsub("\\(\\)", "", name)))) 
  })))

# Extract only those features containing _mean_, or _std_, or ending in _mean, or _std

colNames <- names(fullSet)
columns <- colNames[lapply(colNames, function(name) { grepl("_(mean|std)(_|$)", name) }) == TRUE]
message("Creating musigma_features.csv...")
musigma <- fullSet[ , j=c("subject", "activity", columns), with=FALSE]
write.csv(musigma, file="musigma_features.csv", row.names=FALSE)
cleanup <- c(cleanup, "colNames", "columns", "musigma")

# Create a second data set containing the average of each measure of the 
# extracted set for each activity for each subject. This is a tidy data set as
# per Hadley in that it is in Boyce's 3rd normal form.

message("Creating average_values.csv...")
averageSet <- musigma[ , j=lapply(.SD, mean, na.rm=TRUE), by=list(subject, activity)]
write.csv(averageSet, file="average_values.txt", row.names=FALSE)
cleanup <- c(cleanup, "averageSet")

# 
# Be nice and clean up the environment to save on space if the script is running
# in an interactive shell or something like R Studio. Use the cleanup list to
# avoid nuking objects not allocated by the script.
# 

message("Cleaning up the environment...")
rm(list=cleanup)
message("done.")
