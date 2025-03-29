require(caret)
suppressMessages(library("caretEnsemble"))


path = getwd()
base_path = dirname(path)


run_ensemble <- function(train_data, number, repeats, best_models){
  
  set.seed(41259)
  control <- trainControl(method = "repeatedcv", 
                          number = number, 
                          repeats = repeats, 
                          savePredictions = "final",
                          index = createResample(train_data$target, number*repeats), 
                          allowParallel = FALSE)
  
  
  model_list <- caretList(target~., data=train_data, trControl=control, methodList=best_models)
  return(model_list)
}


# args = commandArgs(trailingOnly=TRUE)
# wch_data = args[1]
# input_file_name = args[2]


# already_running = "no"
# result_dir_name = "wireless_pred"
input_file_name = "train_pca.csv"
input_file_name_test = "test_pca.csv"
# model_time_file_name = "model_time.csv"

source("DataIO.R")


out_longitude <- load_data(file.path(base_path, "/RegressionPipeline/data", input_file_name), file.path(base_path, "/RegressionPipeline/data", input_file_name_test), "longitude")
train_data_longitude <- out_longitude[[1]]
test_data_longitude <- out_longitude[[2]]


out_latitude <- load_data(file.path(base_path, "/RegressionPipeline/data", input_file_name), file.path(base_path, "/RegressionPipeline/data", input_file_name_test), "latitude")
train_data_latitude <- out_latitude[[1]]
test_data_latitude <- out_latitude[[2]]


# train_data_longitude = train_data_longitude[1:1000, ]
# test_data_longitude = test_data_longitude[1:1000, ]

# train_data_latitude = train_data_latitude[1:1000, ]
# test_data_latitude = test_data_latitude[1:1000, ]


# modelTypes = list(kknn = caretModelSpec(method="kknn", k=5), 
#                   cubist = caretModelSpec(method = "cubist")).

modelTypes = list(cubist = caretModelSpec(method = "cubist"))


model_list_longitude <- caretEnsemble::caretList(
  target ~ .,
  data = train_data_longitude,
  tuneList = modelTypes
)


model_list_latitude <- caretEnsemble::caretList(
  target ~ .,
  data = train_data_latitude,
  tuneList = modelTypes
)

saveRDS(model_list_longitude, file="cubist_pca_long.rds")
saveRDS(model_list_latitude, file="cubist_pca_lat.rds")

# Checking model correlation
# caret::modelCor(caret::resamples(model_list_longitude))
# caret::modelCor(caret::resamples(model_list_latitude))


model_preds_longitude <- as.data.frame(predict(model_list_longitude, newdata = test_data_longitude))
model_preds_latitude <- as.data.frame(predict(model_list_latitude, newdata = test_data_latitude))


model_preds_longitude[, 1] <- as.numeric(model_preds_longitude[, 1])
# model_preds_longitude[, 2] <- as.numeric(model_preds_longitude[,2])
model_preds_latitude[, 1] <- as.numeric(model_preds_latitude[, 1])
# model_preds_latitude[, 2] <- as.numeric(model_preds_latitude[,2])



# output = data.frame("kknn_long"=model_preds_longitude$kknn, "kknn_lat"=model_preds_latitude$kknn, "cubist_long"=model_preds_longitude$cubist,
#                     "cubist_lat"=model_preds_latitude$cubist)
# write.csv(output, file="model_predictions.csv", row.names = FALSE, sep = ",")


output = data.frame("cubist_pca_long"=model_preds_longitude$cubist, "cubist_pca_lat"=model_preds_latitude$cubist)
write.csv(output, file="model_predictions_pca_cubist.csv", row.names = FALSE, sep = ",")


calculate_dist <- function(coords1, coords2){
  temp = 0
  temp = c(temp, sqrt(( ((coords2[, 1] - coords1[, 1])^2) + ((coords2[, 2] - coords1[, 2])^2) ) ))
  return(mean(temp))
}

# dist_kknn = calculate_dist(cbind(model_preds_longitude$kknn, model_preds_latitude$kknn), cbind(test_data_longitude, test_data_latitude))
# dist_cubist = calculate_dist(cbind(model_preds_longitude$cubist, model_preds_latitude$cubist), cbind(test_data_longitude, test_data_latitude))

dist_cubist = calculate_dist(cbind(model_preds_longitude, model_preds_latitude), cbind(test_data_longitude[, 1], test_data_latitude[, 1]))

# print(paste("Average distance (kknn): ", dist_kknn))
print(paste("Average dist: (cubist)", dist_cubist))
