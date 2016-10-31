# Coursera Getting Data Programming Assignment 
# 


## Codebook for **tidyset.txt**
## 

### File structure
The file includes 6 variables separated by space.  Column names are provided in the header record

### Description of variables
"subjectid" "activityName" "measure" "functionapplied" "axis" "meanvalue"

* *objectid*:  consealed identity of study participants.  Possible values are integers from 1 to 30
* *activityName*: what was the physical activity when measurements were takes.  Possible values are WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.
* *measure*:  actual variable being measured or calculated.  Additional information can be found in two files provided "as-is" from the input files for the project:  **features.txt** and **features_info.txt**
* *functionapplied*: the processing function applied to original signals when producing input data sets.  After filtering, only 3 values are present in *tidyset.txt*: "mean", "std", and "meanFreq".  The original data contained many more values, for details refer to **features_info.txt**.
* *axis*: for 3-dimensional signals, the actual axis component.  Possible values are "X", "Y", "Z".  For scalar measurements, such as *tBodyGyroJerkMag*, the values is missing and denoted as NA.
* *meanvalue*: numeric mean value calculated per assignment.  The unit of measure probably varies depending on signal meing measued, and is unknown at this time.

### Reading data into R
To read the file into R, use following statement:

`newtidyset<-read.table("tidyset.txt", header = TRUE, stringsAsFactors = FALSE, na.strings = "NA")
`
