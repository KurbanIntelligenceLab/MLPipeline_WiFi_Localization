require(caret)
suppressMessages(library("caretEnsemble"))


path = getwd()
setwd(file.path(path))
base_path = dirname(path)



# args = commandArgs(trailingOnly=TRUE)
# wch_data = args[1]
# input_file_name = args[2]


already_running = "no"
result_dir_name = "wireless_pred"

input_file_name = "train_pca.csv"
input_file_name_test = "test_pca.csv"

model_time_file_name = "model_time.csv"



source("DataIO.R")

out_longitude <- load_data(file.path(base_path, "RegressionPipeline/data", input_file_name), file.path(base_path, "RegressionPipeline/data", input_file_name_test), "longitude")
train_data_longitude <- out_longitude[[1]]
test_data_longitude <- out_longitude[[2]]


out_latitude <- load_data(file.path(base_path, "RegressionPipeline/data", input_file_name), file.path(base_path, "RegressionPipeline/data", input_file_name_test), "latitude")
train_data_latitude <- out_latitude[[1]]
test_data_latitude <- out_latitude[[2]]



grid <- expand.grid(committees = c(20, 50, 100), neighbors = c(0, 1, 9))

set.seed(2)

caret_grid_long <- train(
  x = subset(train_data_longitude, select = -target),
  y = train_data_longitude$target,
  method = "cubist",
  tuneGrid = grid,
  trControl = trainControl(method = "cv", number=5)
)

# ggplot(caret_grid_long)


caret_grid_lat <- train(
  x = subset(train_data_latitude, select = -target),
  y = train_data_latitude$target,
  method = "cubist",
  tuneGrid = grid,
  trControl = trainControl(method = "cv", number=5)
)

# ggplot(caret_grid_lat)


model_preds_longitude <- as.data.frame(predict(caret_grid_long, test_data_longitude))
model_preds_latitude <- as.data.frame(predict(caret_grid_lat, test_data_latitude))


model_preds_longitude[, 1] <- as.numeric(model_preds_longitude[, 1])
model_preds_latitude[, 1] <- as.numeric(model_preds_latitude[, 1])

saveRDS(caret_grid_long, file="cubist_tuned_pca_long.rds")
saveRDS(caret_grid_lat, file="cubist_tuned_pca_lat.rds")



# kknn_rms_long <- RMSE(model_preds_longitude$kknn, test_data_longitude$target)
# cubist_rms_long <- RMSE(model_preds_longitude$cubist, test_data_longitude$target)
# 
# kknn_rms_lat <- RMSE(model_preds_latitude$kknn, test_data_latitude$target)
# cubist_rms_lat <- RMSE(model_preds_latitude$cubist, test_data_latitude$target)

# output = data.frame("kknn_long"=model_preds_longitude$kknn, "kknn_lat"=model_preds_latitude$kknn, "cubist_long"=model_preds_longitude$cubist,
#                     "cubist_lat"=model_preds_latitude$cubist)
# 
# write.csv(output, file="testfile.csv", row.names = FALSE, sep = ",")

output = data.frame("cubist_pca_long"=model_preds_longitude$cubist, "cubist_pca_lat"=model_preds_latitude$cubist)
write.csv(output, file="model_predictions_pca_cubist_tuned.csv", row.names = FALSE, sep = ",")


calculate_dist <- function(coords1, coords2){
  temp = 0
  temp = c(temp, sqrt(( ((coords2[, 1] - coords1[, 1])^2) + ((coords2[, 2] - coords1[, 2])^2) ) ))
  return(mean(temp))
}


# dist_kknn = calculate_dist(cbind(model_preds_longitude$kknn, model_preds_latitude$kknn), cbind(test_data_longitude, test_data_latitude))
dist_cubist = calculate_dist(cbind(model_preds_longitude, model_preds_latitude), cbind(test_data_longitude[, 1], test_data_latitude[, 1]))


# print(paste("Average distance (kknn): ", dist_kknn))
print(paste("Average dist: (cubist)", dist_cubist))


