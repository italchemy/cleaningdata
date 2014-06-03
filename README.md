README
========================================================

This repo contains an R script that processes the Samsung UCI HAR data set to produce summary data sets. See the following web site for a more in-depth description of the study:

[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones]

Follow the link below to download the original study data:

[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip]

##Contents

The repo contains the following files:

###README.md
This file.

###run_analysis.R
An R script for processing the UCI HAR data. The script is designed to be run in the root directory of the data set and produces the following two files:

1. **musigma_features.csv** - a data set comprised of the subject, activity, and mean and standard deviation features from the UCI testing and training datasets. See the accompanying code book, or the UCI data set file "features_info.txt" for more information on the variables and their meaning.

2. **average_values.csv** - a data set comprised of the average (mean) value for all of the UCI features, grouped by subject and activity. Again, see the accompanying code book and/or the UCI documentation for more information on the variables and their meaning within this data set.

**WARNING**

Both files are created in the script's working directory, i.e. the data set root directory, and the script will overwrite older versions if they exist. In other words, back-up or rename the files if you want to preserve them before running the script a second time.

###CodeBook.md

A markdown document that describes the content of the two summary data sets in detail and documents the processing performed on the original data sets.

```{r}
summary(cars)
```

You can also embed plots, for example:

```{r fig.width=7, fig.height=6}
plot(cars)
```

