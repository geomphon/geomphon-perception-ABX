## May pilot 2019


Found under `experiments/pilot_May_2019`.

The goal of this pilot was to collect some ABX data and develop basic tools for preprocessing data, as well as start testing the models we plan to use to analyse the data.

## To start

Put your data in the folder `raw_data`. 

### Requirements

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

## Install

Download the project geomphon-perception-ABX : https://github.com/geomphon/geomphon-perception-ABX.git

## Run the programm

In your terminal go to `/Users/adele/Documents/GitHub/geomphon-perception-ABX/experiments/pilot_May_2019`

### Create stimuli

WARNING : Be sur to have your data in `raw_data`   

Execute the commands :  
&emsp;`make triplet_list`  
&emsp;`make stimulus_list.csv`  
&emsp;`make stimlist/item_meta_information_with_distances.csv`  
&emsp;`make stimlist/stimuli_intervals`  
        
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
