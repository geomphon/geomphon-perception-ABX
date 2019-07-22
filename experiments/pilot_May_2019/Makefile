all: triplet-list \
stimlist/stimuli_intervals \
stimulus_list.csv \
stimlist/item_meta_information_with_distances.csv \
anonymize_data \
split_output_to_results_files \
filter_data \


tmp:
	mkdir -p tmp

triplet-list: tmp
	python ../../src/textgrid_to_abx_item_file_word.py word \
raw_data/textGrid/ \
raw_data/wav/ \
--excluded-words=SAY,AGAIN,sp0 > tmp/ABX_ITEM_FILE.csv \
&& Rscript --vanilla triplet_creation/add_meta_information_to_item_file.Rscript \
tmp/ABX_ITEM_FILE.csv tmp/ABX_ITEM_FILE_COMPLETE.csv \
&& abx-task tmp/ABX_ITEM_FILE_COMPLETE.item tmp/ABX_TASK_FILE.task \
-o word \
&& python ../../src/task2txt.py tmp/ABX_TASK_FILE.task tmp/ABX_TASK_FILE.csv \
&& Rscript --vanilla triplet_creation/add_meta_information_to_triplet_file.Rscript \
tmp/ABX_TASK_FILE.csv tmp/ABX_ITEM_FILE_COMPLETE.item triplet_creation/triplets.csv \

distances/tmp:
	mkdir -p distances/tmp

stimlist/item_meta_information_with_distances.csv: distances/tmp
	Rscript --vanilla distances/combine_triplet_meta_information.Rscript \
stimlist/stimulus_list.csv triplet_creation/triplets.csv stimlist/item_meta_information.csv && \
Rscript --vanilla \
distances/prepare_stimuli_for_distance_calculation_aug.Rscript \
stimlist/item_meta_information.csv raw_data distances/tmp/PAIRS_TMP.csv

distances/tmp/distances__normed_filterbank__dtw_pathlength__by_pair.csv: \
	distances/tmp distances/tmp/PAIRS_TMP.csv
	python ../../src/wav_to_distance.py --normalize-by-speaker distances/tmp/PAIRS_TMP.csv 44100 $@

distances/tmp/distances__unnormed_filterbank__dtw_pathlength__by_pair.csv: \
	distances/tmp distances/tmp/PAIRS_TMP.csv
	python ../../src/wav_to_distance.py distances/tmp/PAIRS_TMP.csv 44100 $@

distances/tmp/distances__normed_mfcc__dtw_pathlength__by_pair.csv: \
	distances/tmp distances/tmp/PAIRS_TMP.csv
	python ../../src/wav_to_distance.py --nceps=13 --normalize-by-speaker distances/tmp/PAIRS_TMP.csv 44100 $@

distances/tmp/distances__unnormed_mfcc__dtw_pathlength__by_pair.csv: \
	distances/tmp distances/tmp/PAIRS_TMP.csv
	python ../../src/wav_to_distance.py --nceps=13 distances/tmp/PAIRS_TMP.csv 44100 $@

distances/tmp/distances__normed_filterbank__dtw_sum__by_pair.csv: \
	distances/tmp distances/tmp/PAIRS_TMP.csv
	python ../../src/wav_to_distance.py --normalize-by-speaker --distance-function=dtw_euclidean  distances/tmp/PAIRS_TMP.csv 44100 $@

distances/tmp/distances__unnormed_filterbank__dtw_sum__by_pair.csv: \
	distances/tmp distances/tmp/PAIRS_TMP.csv
	python ../../src/wav_to_distance.py --distance-function=dtw_euclidean distances/tmp/PAIRS_TMP.csv 44100 $@

distances/tmp/distances__normed_mfcc__dtw_sum__by_pair.csv: \
	distances/tmp distances/tmp/PAIRS_TMP.csv
	python ../../src/wav_to_distance.py --normalize-by-speaker --nceps=13 --distance-function=dtw_euclidean distances/tmp/PAIRS_TMP.csv 44100 $@

distances/tmp/distances__unnormed_mfcc__dtw_sum__by_pair.csv: \
	distances/tmp distances/tmp/PAIRS_TMP.csv
	python ../../src/wav_to_distance.py --nceps=13 --distance-function=dtw_euclidean  distances/tmp/PAIRS_TMP.csv 44100 $@

distances/distances__%.csv: distances/tmp/distances__%__by_pair.csv
	Rscript --vanilla \
distances/reshape_result_of_distance_calculation_aug.Rscript \
$< stimuli $@

distances: distances/distances__normed_filterbank__dtw_pathlength.csv \
distances/distances__unnormed_filterbank__dtw_pathlength.csv \
distances/distances__normed_mfcc__dtw_pathlength.csv \
distances/distances__unnormed_mfcc__dtw_pathlength.csv \
distances/distances__normed_filterbank__dtw_sum.csv \
distances/distances__unnormed_filterbank__dtw_sum.csv \
distances/distances__normed_mfcc__dtw_sum.csv \
distances/distances__unnormed_mfcc__dtw_sum.csv \
clean-distances-tmp

stimulus_list.csv: stimlist/design.csv 
	python stimlist/generate_design.py 4 18 10 1 0 1 2 3 4 5 8000 0.00001 24 stimlist/design.csv

stimlist/item_meta_information_with_distances.csv: distances
	Rscript --vanilla \
distances/merge_distances.Rscript \
stimlist/item_meta_information.csv \
stimlist/item_meta_information_with_distances.csv \
distances/distances__*.csv

stimlist/stimuli_intervals:
	python stimlist/save_intervals_to_wavs.py word stimlist/stimuli_intervals \
stimlist/meta_info_filelist.csv \
raw_data/textGrid/Mnirbhay1.TextGrid,raw_data/wav/Mnirbhay1.wav \
raw_data/textGrid/Mnirbhay2.TextGrid,raw_data/wav/Mnirbhay2.wav \
raw_data/textGrid/Fsakshi1.TextGrid,raw_data/wav/Fsakshi1.wav \
raw_data/textGrid/Mnirbhay2.TextGrid,raw_data/wav/Fsakshi2.wav \
raw_data/textGrid/Mnirbhay2.TextGrid,raw_data/wav/Fbhavya1.wav \
raw_data/textGrid/Mnirbhay2.TextGrid,raw_data/wav/Fbhavya2.wav \
raw_data/textGrid/Mnirbhay2.TextGrid,raw_data/wav/FNiralee1.wav \
raw_data/textGrid/Mnirbhay2.TextGrid,raw_data/wav/FNiralee2.wav \
raw_data/textGrid/Mnirbhay2.TextGrid,raw_data/wav/Mrajesh1.wav \
raw_data/textGrid/Mnirbhay2.TextGrid,raw_data/wav/Mrajesh2.wav \


#NB- this step ONLY takes absolute paths to raw data files. raw data files contain
#personally identifiable information and  should never be shared or synced to git 
anonymize_data: 
	python anonymize_lmeds_data_filenames.py \
/Users/post-doc/Desktop/output \
/Users/post-doc/Documents/GitHub/geomphon-perception-ABX/experiments/pilot_May_2019/anon_output \
/Users/post-doc/Desktop/anon_key.csv

split_output_to_results_files: anon_output
	python anonymize_data/split_output_to_results_files.py \
anon_output/ \
anon_output/results.csv \
anon_output/presurvey.csv \
anon_output/postsurvey.csv \
anon_output/postsurvey2.csv

filter_data: distances/item_meta_information_with_distances.csv
	Rscript --vanilla results/analysis_step1_preprocess_May_2019_pilot.Rscript \
anon_output/presurvey.csv \
anon_output/results.csv \
anon_output/postsurvey.csv \
anon_output/postsurvey2.csv \
distances/item_meta_information_with_distances.csv \
results/geomphon_pilot_results_for_analysis.csv

clean-design:
	rm stimlist/design.csv

clean-stimulus-list:
	rm stimlist/stimulus_list.csv

clean-distances-tmp:
	rm -rf distances/tmp

clean-distances: clean-distances-tmp
	rm -f distances/distances_*.csv

clean-stimuli-intervals:
	rm -rf raw_data/stimuli_intervals

clean-stimuli-construction: clean-stimuli-intervals

clean-tmp:
	rm -rf tmp
clean-all: clean-design \
clean-stimulus-list \
clean-distances-tmp \
clean-distances \
clean-stimuli_intervals \
clean-stimuli-construction



