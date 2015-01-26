library(data.table)
library(caret)
library(ggplot2)
library(knitr)
library(xtable)
library(randomForest)

downloadPML <- function() {
    download.file("http://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv", "pml-training.csv")
    download.file("http://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv", "pml-testing.csv")
}

readFile <- function(file) {
    fread(file, na.strings=c("#DIV/0!", ""))
}

dropColumns <- function(x) {
    x[,!c("V1", "user_name", "raw_timestamp_part_1", "raw_timestamp_part_2", "cvtd_timestamp", "new_window", "num_window"),with=F]
}

transform <- function(x) {
    x[,classe:=factor(classe)]
}

pml_training   <- readFile("pml-training.csv")
pml_validation <- readFile("pml-testing.csv")

set.seed(13)

## contains some NA values
na.cols <- pml_training[,sapply(.SD, function(x) any(is.na(x)))]

## try only columns that have values
training <- dropColumns(pml_training[,eval(names(which(na.cols == F))),with=F])
