require("caret")
require("readxl")
require("stringr")

load_data <- function(base_data_path, base_data_path2, type_d){
  
  
  read_data <- function(base_data_path){
    
    Inputdata <- read.csv2(base_data_path, sep=",", stringsAsFactors = FALSE)
    
    Inputdata <- apply(Inputdata, 2, as.numeric)
    Inputdata <- as.data.frame(Inputdata)
    
    target = Inputdata$Votes
    Inputdata <- Inputdata[, -ncol(Inputdata)]
    Inputdata <- cbind(target=target, Inputdata)
    
    return(Inputdata)
  }
  
  read_data1 <- function(base_data_path, type_d){
    
    Inputdata <- read.csv2(base_data_path, sep=",", stringsAsFactors = FALSE)
    
    Inputdata <- apply(Inputdata, 2, as.numeric)
    Inputdata <- as.data.frame(Inputdata)
    
    
    if (type_d == "longitude"){
        # target = Inputdata[, 314]
        # Inputdata <- Inputdata[, -c(314, 315)]
        
        target = Inputdata[, 150]
        Inputdata <- Inputdata[, -c(150, 151)]
        
        # target = Inputdata[, 4]
        # Inputdata <- Inputdata[, -c(4, 5)]
        
        Inputdata <- cbind(target=target, Inputdata)
    }
    else{
        # target = Inputdata[, 315]
        # Inputdata <- Inputdata[, -c(314, 315)]
        
        target = Inputdata[, 151]
        Inputdata <- Inputdata[, -c(150, 151)]
        
        # target = Inputdata[, 5]
        # Inputdata <- Inputdata[, -c(4, 5)]
        
        Inputdata <- cbind(target=target, Inputdata)
    }
    
    
    return(Inputdata)
  }
  
  training_data <- read_data1(base_data_path, type_d)
  test_data <- read_data1(base_data_path2, type_d)
  
  
  # Create training and test data
  set.seed(8745)
  # train_indices <- createDataPartition(y = as.factor(Inputdata$target), p = 0.85, list = FALSE)
  # training_data <- Inputdata[train_indices, ]
  # test_data <- Inputdata[-train_indices, ]
  
  print("\n#############################")
  print("Data read-in successfully")
  # print(paste("Rows:", nrow(Inputdata), " Cols:", ncol(Inputdata)))
  print(paste("Train data Rows:", nrow(training_data), " Cols:", ncol(training_data)))
  print(paste("Test data Rows:", nrow(test_data), " Cols:", ncol(test_data)))
  print("\n#############################")
  
  out = list("train_data" = training_data, "test_data" = test_data)
  return(out)
  
}