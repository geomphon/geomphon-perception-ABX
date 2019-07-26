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
- cython 
- textgrid: pip install git+git://github.com/kylebgorman/textgrid.git
- pydub
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

Naming conventions : You have to name your files accordingly. If the speaker is male, the first character of the .wav and .texgrid associated must be M. (F for female). If not, the program won't run properly. It is mandatory to respect this even if there's no difference of gender in your data.
Ex : a female speaker name Katie must have both following files : Fkatie.wav , Fkatie.textgrid.

You also have to make sure that your textgrids are correctly formatted. You must have a tier name "word", in which only the words you want to work on are marked. You also have to make sure that there's exactly 3 words per sound per .wav.
Ex : If you want to study "AKA" , you can only have 3 "AKA" following each other in .wav. You can change this in the script stimlist/generate_design.py (more on this later).

Finally, you will need to change triplet_creation/combine_triplet_meta_information.Rscript. You'll have to add your own code that you used to annote your texgrids. You can just add it to the list without deleting anything.
```
### You will have to adapt the makefile too :

Warning : the makefile is not in a finished state right now (26/07/2019) and some changes still need to be done..


If you have changed the path to the TextGrid files or the wav files in step 2, you must :
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
Step 1 : The TextGrid and wav files will be convert to ABX_ITEM_FILE.csv in the folder `tmp`
        This .csv will contain a tables with 5 columns :
                - column 1 = file (path and name of the file)
                - column 2 = onset
                - column 3 = offset
                - column 4 = item (Example : Someone_1)
                - column 5 = word (Example : AKA)
Step 2 : The triplet are created in ABX_ITEM_FILE_COMPLETE.csv
Step 4 : ABX_ITEM_FILE.csv are used to create triplet.csv
```
On the ABX files :
Despite the names, those are simple .csv and not .item or ABX files.This is because we needed ABXpy in earlier versions of the project, but changed later due to compatibility issues. You should not need ABXpy anymore for this program.

On generate_triplet.py :
This script makes triplets of sounds based on ABX_ITEM_FILE_COMPLET.csv, but it does NOT generate ALL triplets. 

Some conditions are made that are based on what we needed for the last experiment. You have to take a look at this file to see everything it's 
generating, otherwise you may have trouble for the next parts. We had roughly 1000 sounds, and making all triplets for these created a 270gb file that was completely unusable. 
If you really need every possible triplet, make sure the file created is not bigger than 7gb (biggest file that worked for later scripts).
This script takes a lot of time to run. For the last experiment it lasted for several hours (I don't know the exact amount, I left it running the night before we needed the file, you should do the same).

One last thing to note is that there may be conflict between the triplets generating and the design (if you don't generate all triplets there may be triplets needed for the design that you didn't generate, or maybe the design is wrong and asks for triplets you shouldn't need).
 There's still problems within the conditions sets in this script to generate te triplets and it needs to be revised.

### stimlist/stimuli_intervals :

This part of the makefile generates all stimuli based on you textgrid. Make sure you followed the formatted marked above.
You will have to replace every filenames in the makefile by yours.

Ex : If you have Mgeorge.Textgrid and .wav, you will need to write :
raw_data/textGrid/Mgeorge.TextGrid,raw_data/wav/Mgeorge.wav \

### stimulus_list.csv :
This part of the makefile generate the design of the experiment, and choose all stimuli that will be used.
There's a lot of arguments, some of them are redundant, but make sure you understand every one before attempting to change them.
There's also a few remarks concerning the generation of the design.
First, the design produces 3 files : design.csv, stimulus_list.csv and stimuli_list.txt.
Currently, the design is adapted for hindi files, and our current experiment and files. You will have to change this script if you want to use other files.

### stimlist/item_meta_information_with_distances.csv :
There's still problems within several of these files that need to be addressed.
First, the file item_meta_information.csv generated by combine_triplet_meta_information.Rscript is incomplete. The script shouldn't be at fault, but I think that the error comes from either generate_triplets.py (which does not generate all triplets) or generate_design.py (which has some features that have not been fully tested).
This results in an incomplet distances/tmp/PAIRS_TMP file. 
But even with the last file completed, no distance could be calculated, because of a segmentation fault. (segfault 11). This issue is currently being corrected.


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
