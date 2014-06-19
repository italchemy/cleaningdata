Code Book
========================================================

This document describes the contents of the two summary data sets produced by the script run_analysis.R. The document is broken into two sections, one for each of the data sets.

## Background

The UCI HAR dataset is comprised of measurements from Samsung Galaxy SII phones worn by 30 subjects as they went about their daily activities. The following excerpt from the original data set describes the measurements and their derivations:

> The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 
>
> Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 
>
>Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 
>
>These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.
>
>- tBodyAcc-XYZ
>- tGravityAcc-XYZ
>- tBodyAccJerk-XYZ
>- tBodyGyro-XYZ
>- tBodyGyroJerk-XYZ
>- tBodyAccMag
>- tGravityAccMag
>- tBodyAccJerkMag
>- tBodyGyroMag
>- tBodyGyroJerkMag
>- fBodyAcc-XYZ
>- fBodyAccJerk-XYZ
>- fBodyGyro-XYZ
>- fBodyAccMag
>- fBodyAccJerkMag
>- fBodyGyroMag
>- fBodyGyroJerkMag
>
>The set of variables that were estimated from these signals are: 
>
>- mean(): Mean value
>- std(): Standard deviation
>- mad(): Median absolute deviation 
>- max(): Largest value in array
>- min(): Smallest value in array
>- sma(): Signal magnitude area
>- energy(): Energy measure. Sum of the squares divided by the number of values. 
>- iqr(): Interquartile range 
>- entropy(): Signal entropy
>- arCoeff(): Autorregresion coefficients with Burg order equal to 4
>- correlation(): correlation coefficient between two signals
>- maxInds(): index of the frequency component with largest magnitude
>- meanFreq(): Weighted average of the frequency components to obtain a mean frequency
>- skewness(): skewness of the frequency domain signal 
>- kurtosis(): kurtosis of the frequency domain signal 
>- bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
>- angle(): Angle between to vectors.
>
>Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:
>
>- gravityMean
>- tBodyAccMean
>- tBodyAccJerkMean
>- tBodyGyroMean
>- tBodyGyroJerkMean

Captured activities were:

- sitting
- standing
- resting
- walking
- walking up stairs
- walking down stairs

Additional information on the study methodology can be found on the study web site and in the information files included with the study data sets.

## Means and Standard Deviations (musigma_features.csv)

The means and standard deviations data set (captured in the output file *musigma_features.csv*) contains only the means and standard deviations of the measures listed in the Background section; i.e. tBodyAcc-mean()-X, tBodyAcc-std()-X, etc. Also included in the file are the following two columns:

- **subject** - the subject identifier of the participant that generated the measurement vector; and
- **activity** - a text string that describes the activity performed during the vector measurement period

The data set was created by:

1. Unifying the subject, activity, and feature data sets for each of the UCI train and test data sets to create a single table for each data set.

2. Merging the two data tables to create a single data table comprised of all of the subject, activity, and feature records for the study (the original data set is partitioned such that approximately 70% is in the training data set, and 30% comprises the test data set).

3. Modifying the HCI labels to make the usable as R indices. Specifically:
  * removing empty parentheses, e.g. suffixes like mean() become simply mean;
  * replacing commas with underscores, e.g. fBodyGyro_bandsEnergy_49,64 becomes fBodyGyro_bandsEnergy_49_64; and
  * replacing parentheses around labels with underscores, e.g angle(Z,gravityMean) becomes angle_Z_gravityMean.
  
4. Selecting only those variables with "mean" or "std" as standalone words, i.e. those with _mean_ or _std_, or ending in _mean or _std.

5. Writing the resulting data set to the output file.

## Average Values By Subject Per Selected Activity (average_values.csv)

The average values by subject per activity data set (captured in the output file *average_values.csv*) contains the average value of each measure within the means and standard deviations file per subject per activity. The included variables are the same as those of the *musigma_features.csv* file.

The data set was created by:

1. Unifying the subject, activity, and feature data sets for each of the UCI train and test data sets to create a single table for each data set.

2. Merging the two data tables to create a single data table comprised of all of the subject, activity, and feature records for the study (the original data set is partitioned such that approximately 70% is in the training data set, and 30% comprises the test data set).

3. Modifying the HCI labels to make the usable as R indices. Specifically:
  * removing empty parentheses, e.g. suffixes like mean() become simply mean;
  * replacing commas with underscores, e.g. fBodyGyro_bandsEnergy_49,64 becomes fBodyGyro_bandsEnergy_49_64; and
  * replacing parentheses around labels with underscores, e.g angle(Z,gravityMean) becomes angle_Z_gravityMean.
  
4. Computing the average value of the measures for each subject and activity.

5. Writing the resulting data set to the output file.
