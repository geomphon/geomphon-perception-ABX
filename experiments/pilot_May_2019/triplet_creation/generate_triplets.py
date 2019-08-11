#Convert the file created by add_meta_information_to_iten_file.Rscript to csv file with some triplets
#Generating all triplets cannot always be done, it can be too much for the rest of the scripts to handle, so some conditions are set to generate them.

# Author: Nicolas Brasset, Ewan Dunbar

import pandas as pd
import numpy as np
import sys, argparse

parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
parser.add_argument('input_path',
        help="filename of the file created by add_meta_information_to_item_file.Rscript",
        type=str)
parser.add_argument('output_path',
        help="filename for the output file",
        type=str)
args = parser.parse_args()

soundsdf = pd.read_csv(args.input_path)
soundsdf.columns = ["file","onset","offset","item","word","speaker","CV","context","phone"]
output_file = open(args.output_path,"w")
#Each line will be a triplet, and we need all infos frome the previous file for each sound, so there's 3 times more columns,
output_file.write("file_TGT,onset_TGT,offset_TGT,item_TGT,word_TGT,speaker_TGT,CV_TGT,context_TGT,phone_TGT,file_OTH,onset_OTH,offset_OTH,item_OTH,word_OTH,speaker_OTH,CV_OTH,context_OTH,phone_OTH,file_X,onset_X,offset_X,item_X,word_X,speaker_X,CV_X,context_X,phone_X\n")
for TGT in soundsdf.index :
	TGT_speaker = soundsdf.at[TGT,"speaker"]
	for OTH in soundsdf.index :
		OTH_speaker = soundsdf.at[OTH,"speaker"]
		for X in soundsdf.index :
			X_speaker = soundsdf.at[X,"speaker"]
			#We only generate triplets when all speakers are different. (in our case speakers had 2 files, that's why we do not take the last character)
			if (TGT_speaker[:-1] != X_speaker[:-1]) and (OTH_speaker[:-1] != X_speaker[:-1]) and (OTH_speaker[:-1] != TGT_speaker[:-1]):
				TGT_phone = soundsdf.at[TGT,"phone"]
				OTH_phone = soundsdf.at[OTH,"phone"]
				X_phone = soundsdf.at[X,"phone"]
				#We only generate triplets when 2 phone are the same (either TGT and X, or OTH and X)
				if (TGT_phone != OTH_phone) and ((TGT_phone == X_phone) or (OTH_phone == X_phone)): 
					output_file.write(str(soundsdf.at[TGT,"file"]) + ',' + str(soundsdf.at[TGT,"onset"]) + ',' + str(soundsdf.at[TGT,"offset"]) + ',' + str(soundsdf.at[TGT,"item"]) + ',' + str(soundsdf.at[TGT,"word"]) + ',' + str(soundsdf.at[TGT,"speaker"]) + ',' + str(soundsdf.at[TGT,"CV"]) + ',' + str(soundsdf.at[TGT,"context"]) + ',' + str(soundsdf.at[TGT,"phone"]) + ',' + str(soundsdf.at[OTH,"file"]) + ',' + str(soundsdf.at[OTH,"onset"]) + ',' + str(soundsdf.at[OTH,"offset"]) + ',' + str(soundsdf.at[OTH,"item"]) + ',' + str(soundsdf.at[OTH,"word"]) + ',' + str(soundsdf.at[OTH,"speaker"]) + ',' + str(soundsdf.at[OTH,"CV"]) + ',' + str(soundsdf.at[OTH,"context"]) + ',' + str(soundsdf.at[OTH,"phone"]) + ',' + str(soundsdf.at[X,"file"]) + ',' + str(soundsdf.at[X,"onset"]) + ','+ str(soundsdf.at[X,"offset"]) + ',' + str(soundsdf.at[X,"item"]) + ',' + str(soundsdf.at[X,"word"]) + ',' + str(soundsdf.at[X,"speaker"]) + ','+ str(soundsdf.at[X,"CV"]) + ',' + str(soundsdf.at[X,"context"]) + ',' + str(soundsdf.at[X,"phone"]) + '\n')
output_file.close()
