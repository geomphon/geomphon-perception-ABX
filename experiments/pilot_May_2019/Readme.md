## May pilot 2019


Found under `experiments/pilot_May_2019`.

The goal of this pilot was to collect some ABX data and develop basic tools for preprocessing data, as well as start testing the models we plan to use to analyse the data.

### Requirements

We recommand that you use the Anaconda platform to install the new packages. 
You can download it here https://www.anaconda.com/distribution/
And you will find the documention on how to use it here: https://docs.anaconda.com/anaconda/

**Python**

```
- standard_format: pip install git+git://github.com/geomphon/standard-format.git@v0.1#egg=standard_format
- Custom fork of python_speech_features: pip install git+git://github.com/geomphon/python_speech_features_geomphon.git@v1.0GEOMPH#egg=python_speech_features
- fastdtw==0.3.2 (pip)
- numpy
- scipy
- h5py==2.6.0
- ffmpeg
- pandas
- simanneal
- scikit-learn
- cython (dependency for ABXpy that's not correctly dealt with)
- ABXpy v0.4: pip install git+git://github.com/bootphon/ABXpy.git@v0.4.1#egg=ABXpy
- textgrid: pip install git+git://github.com/kylebgorman/textgrid.git
```

**R**

```
- magrittr
- readr
- tidyr
- dplyr
```

## To start
```
Step 1 : Download the project geomphon-perception-ABX : https://github.com/geomphon/geomphon-perception-ABX.git

Step 2 : Put your `.TextGrid` in `raw_data/textGrid/` which you will find in the project folders.
Step 3 : Put your `.wav` in `raw_data/wav/` which you will find in the project folders.
```
### What need to be changed in the makefile

If you have change the name of the path to the TextGrid files or the wav files in step 2, you must do :
```
1 - Open the makefile in text editor of your choice
2 - Go to triplet-list (It's at the beginning of the file after tmp)
3 - And change the path `raw_data/textGrid/` or `raw_data/wav/` to the name of your folders. 

WARNING : You always need to have separate folders for your .TextGrid and .wav.
```
If your tier name is different from `word` in the makefile, you need to change it in `triplet_list` too.

## Roles of the differents commands in the makefile

### triplet_list

This part of the makefile will create in the folder `triplet_creation` the file `triplet.csv`.
This file will be created in several steps :
```
Step 1 : The TextGrid and wav files will be convert to ABX_ITEM_FILE.item in the folder `tmp`
        This .item will contain a tables with 5 columns :
                - column 1 = file (path and name of the file)
                - column 2 = onset
                - column 3 = offset
                - column 4 = item (Example : Someone_1)
                - column 5 = word (Example : AKA)
Step 2 : The triplet are created in ABX_ITEM_FILE_COMPLETE.item
Step 3 : This ABX_ITEM_FILE_COMPLETE.item is used to create ABX_TASK_FILE.csv
Step 4 : All the previous files are used to create triplet.csv
```

## Run the programm

To run geomphon-perception-ABX you have 2 solutions :

## Solution 1

Execute the file `geomphon_May_2019.sh`. This `.sh` will run every commands from the makefile.

## Solution 2

Execute the commands from the make file like described below

### Create stimuli

WARNING : Be sur to have your data in `raw_data` and in the right sub directory  

Execute the commands :  
&emsp;`make triplet_list`
&emsp;`make stimlist/stimuli_intervals` 
&emsp;`make stimulus_list.csv`  
&emsp;`make stimlist/item_meta_information_with_distances.csv`  
 
### Anonymize your data

Execute the command :  
&emsp;`make anonymize_data`
        
### Process the data

Execute the commands :  
&emsp;`make split_output_to_results_files`  
&emsp;`make filter_data`
        
### Clean the data

Execute the command :  
&emsp;`make clean-all`
        
## Results

You can find your results under the folder `results`
