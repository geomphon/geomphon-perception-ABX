Pilot_May_2019

The only make command currently working properly is make triplet-list.

We moved all files concerning this command and reorganised them, and edited the makefile to automate it.
We created a tmp file which holds all files that should be deleted after their uses. (we don't know what command to use in the makefile to delete the directory tmp. -rm -rf doesn't work, or we don't know how to use it)

We are trying to do the same with the commands make distance and make stimuli.

Current errors we're trying to fix : 


make distances :


> Traceback (most recent call last):
> File "../../src/wav_to_distance.py", line 10, in <module>  
> import standard_format as sf   
> ImportError: No module named standard_format


-> seems to be an import error, it is the same if I try this command in pilot_Aug_2018.


make stimulus_list.csv :

> Error in file(file, "rt") : cannot open the connection
> Calls: read.csv -> read.table -> file
> In addition: Warning message:
> In file(file, "rt") :
> cannot open file 'design.csv': No such file or directory  
> Execution halted


->seems to be an error in create_stimlist.Rscript, the path of the working directory could be the problem.
