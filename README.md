# Machine Learning Pipeline for WiFI Indoor Localization


### Rule-Based Ensemble Learning for Wi-Fi Indoor Localization: A Fine-Tuned Approach with Comprehensive Machine Learning Benchmarking

Parichit Sharma, Fadwa Abbas, Nour Alabudi, Roudha Al-Khaldi, Sandra Mansour, Mehmet Tuncel, Ali Ghrayeb, Hasan Kurban

This repository contains the software code and data used in the paper titled - "Rule-Based Ensemble Learning for Wi-Fi Indoor Localization: A Fine-Tuned Approach with Comprehensive Machine Learning Benchmarking". The code is organized into collection of R scripts and instructions for replicating the results are as follows:

**Note:** 

- __Package dependencies__ The software has been tested with R version 4.2.2 and dependency installation is managed by the one of the scripts. However, using newer version of R may require the users to manually install some of the package dependencies needed by the pipeline. If the some of the packages have not been updated for newer R versions then those packages (and the models provided by them) need to be manually removed from the list of models to avoid unexpected failures (this can simply done by removing the package names from the modelList.txt).

- __Expected runtime__ Training all classification models (experiments sections of the manuscript) takes ~72 hours and the actual time may vary depending on the hardware resources of the system on which the program is ran. 


- Following commands should be executed in the terminal/shell/command prompt.

**Clone the repo**

```
git clone 
```

# Running the wrapper script for model training and evaluation.

Change the directory to the repository

```bash
cd MLPipeline_WiFI_Indoor_Localization
```

Run the main script on command line. It is advised to run it as a background job to prevent interference due to system sleeping and killing the job. This script expects 3 command line parameters:

 - Parameter 1 (yes/no): If the script was previously run on the same dataset, and if the execution terminated due to some reason, then ideally the training can resume from the remaining models. Ideally, this option should always be set to 'no'. This is useful when the user wants to resume the trainign for remainig models, but that requires to manually remove the packages from the modelList.txt file to avoid training for previously trained models.

 - Parameter 2 (name of the output folder), string: Name of full path to the output folder. All output files, model evaluation will be saved in this location.

 - Parameter 3 filename (data) (string): name of the file containing train dataset.  

 - Parameter 4 filename (data) (string): name of the file containing test dataset. 

 - Parameter 5 filename (model statistics) (string): name of the file to store the execution time statistics of the model.

```bash
nohup Rscript regressionPipeline.R no dbg_output train_data.csv test_data.csv model_time.txt > dbg_job.log 2>&1 &
```


**Output:** All the output data will be generated as CSV files in the output folder specified on the command line. Evaluation on validation folds are reported in the file __`train_results.csv`__, evaluation on the test data are reported inside the file __`test_results.csv`__. Additionally, the output plots for top models and all models will also be generated in the corresponding output folder.
