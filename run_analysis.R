rm(list=ls())
library(data.table)
library(dplyr)
##helper function to save typing
getColumnssForSelect <- function (pattern) {
    grep(pattern ,measurements$measurementName,ignore.case = TRUE)
}
rootFileDir<-file.path(getwd()) ##working directory
##all input files in the same directory
testFileDir<-file.path(rootFileDir,".")  
trainFileDir<-file.path(rootFileDir,".")

##variable names
measurements<-read.delim(file.path(rootFileDir,"features.txt"), sep = " ", 
                         header = FALSE, col.names = c("position","measurementName"),
                         stringsAsFactors = FALSE)
##activities
activities<-read.delim(file.path(rootFileDir,"activity_labels.txt"), sep = " ", 
                       header = FALSE, col.names = c ("activityid", "activityName"),
                       stringsAsFactors = FALSE)

##read test and train data into R
rawtestdata<-read.table(file.path(testFileDir,"X_test.txt"), col.names= measurements$measurementName)
testsubjects<-read.table(file.path(testFileDir,"subject_test.txt"), stringsAsFactors = FALSE, col.names = "subjectid")
testactivity<-read.table(file.path(testFileDir,"y_test.txt"), stringsAsFactors = FALSE, col.names = "activityid")


rawtraindata<-read.table(file.path(trainFileDir,"X_train.txt"), col.names= measurements$measurementName)
trainsubjects<-read.table(file.path(trainFileDir,"subject_train.txt"), stringsAsFactors = FALSE, col.names = "subjectid")
trainactivity<-read.table(file.path(trainFileDir,"y_train.txt"), stringsAsFactors = FALSE, col.names = "activityid")

##rowbind three pairs of sets, and then colbind to create a data.table 
finalset<-data.table(  ##combine two sets along with activities and subjects
    rbind(rawtestdata,rawtraindata),
    rbind(testsubjects, trainsubjects),
    rbind(testactivity, trainactivity) 
    )%>%  
    ##pipe to variable selection - only select columns with "mean" or "std" in the names, 
    ##but exclude angles, these are not mean or std despite the name
    select(subjectid, activityid,
           ##here we rely on measurement columns coming before subject and activity
           getColumnssForSelect("mean"), 
           getColumnssForSelect("std"),
           -getColumnssForSelect("^angle")
           )%>%  
    ##merge in activity labels so we can have meaningful names
    merge(activities, by.x = "activityid", by.y = "activityid", sort = FALSE)%>%
    ## remove activityid, no longer needed
    select(-activityid)

## now let's melt the table so we can do group by and summarize on everything at once
averaged<-melt(finalset, id.vars = c("subjectid", "activityName"), variable.factor=FALSE)%>%
    ##now group by
    group_by(subjectid,activityName, variable)%>%
    ##and finally summarize
    summarize(meanvalue=mean(value))

##measurement names are actually a combination of 3 things: actual measurement, averaging method applied, and optionally axis,
## so let;s split the column
tidyset<-separate(averaged,variable, into=c("measure", "functionapplied", "axis"), fill="right")   

##if the last part (axis) is missing, I want it to be NA rather than empty string
tidyset$axis[which(tidyset$axis=="")]<-NA

##now write the data into a file
write.table(tidyset, file = file.path(rootFileDir,"tidyset.txt"), row.names = FALSE)