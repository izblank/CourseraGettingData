
# Coursera GettingData Programming Assignment


## How the script works
## 


### Packages used
The code uses two additional packages beyond standard installation:
* data.table
* dplyr

### File location
It is assumed all input and output files are located in working directory (getwd().  
To change location, modify the code that initializes *rootFileDir*, *testFileDir*, and *trainFileDir* variables. 

### Processing steps

1. All input files are originally loaded as data frames.  Column namnes for actual measurements are taken from features.txt file loaded into *measurements* variable. 
2. Similar data from both training and test data sets are row binded together and then column binded into a data table
3. The previous result is piped into a column selection call that selects grouping columns alomg with all columns whose name contain "mean" or "std".  Additionally, columns dealing with angles are excluded as they do not represent means.
4. The result is then piped to be merged with activity names, and after that the activityid column is dropped from the table and, for clarity, this is stored in an intermediate variable *finalset*
5. Now we are ready to calculate the mean values.  For that, the previous resulting *finalset* is **melt**ed converting all measurement columns into rows, this being piped to **group_by** and then to **summarize**.  The result is stored in the *averaged* variable.


### Creating a tidy data set

As one can see from the features_info.txt file, the column names themselves contain additional information: 
  * processing function such as *mean*, *std*, etc
  * for vector measuremnts, axis  such as *X*, *Y*, or *Z*
  
  Therefore, the *averaged$variable* column is being split into three:  actual measurement, function applied, and axis.  For scalar measurement axis does not exist, so the corresponding value is set to **NA**
  
 ### Narrow versus wide consideration
 Main reason for staying "narrow" was a mix of 3-dimensional and scalar observations.  In the narrow form, the 3-dimentional one would need "X-mean", "Y-mean", and "Z-mean" columns, whereas scalar observation would need "scalar-mean".  This would essentially be two separate data sets combined into one, wich would make it untidy
  
