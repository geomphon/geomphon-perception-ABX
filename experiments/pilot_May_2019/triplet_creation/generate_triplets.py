#Convert the file created by add_meta_information_to_iten_file.Rscript to csv file with some triplets
#Generating all triplets cannot always be done, it can be too much for the rest of the scripts to handle, so some conditions are set to generate them.

import pandas as pd 
import numpy as np 
import sys, argparse

parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
parser.add_argument('input_path',
        help="filename of the file created by add_meta_information_to_iten_file.Rscript",
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
	TGT_speaker = soundsdf.get_value(TGT,"speaker")
	for OTH in soundsdf.index :
		OTH_speaker = soundsdf.get_value(OTH,"speaker")
		for X in soundsdf.index :
			X_speaker = soundsdf.get_value(X,"speaker")
			#We only generate triplets when all speakers are different. (in our case speakers had 2 files, that's why we do not take the last character)
			if (TGT_speaker[:-1] != X_speaker[:-1]) and (OTH_speaker[:-1] != X_speaker[:-1]) and (OTH_speaker[:-1] != TGT_speaker[:-1]):
				TGT_phone = soundsdf.get_value(TGT,"phone")
				OTH_phone = soundsdf.get_value(OTH,"phone")
				X_phone = soundsdf.get_value(X,"phone")
				#We only generate triplets when 2 phone are the same (either TGT and X, or OTH and X)
				if (TGT_phone != OTH_phone) and ((TGT_phone == X_phone) or (OTH_phone == X_phone)): 
					output_file.write(str(soundsdf.get_value(TGT,"file")) + ',' + str(soundsdf.get_value(TGT,"onset")) + ',' + str(soundsdf.get_value(TGT,"offset")) + ',' + str(soundsdf.get_value(TGT,"item")) + ',' + str(soundsdf.get_value(TGT,"word")) + ',' + str(soundsdf.get_value(TGT,"speaker")) + ',' + str(soundsdf.get_value(TGT,"CV")) + ',' + str(soundsdf.get_value(TGT,"context")) + ',' + str(soundsdf.get_value(TGT,"phone")) + ',' + str(soundsdf.get_value(OTH,"file")) + ',' + str(soundsdf.get_value(OTH,"onset")) + ',' + str(soundsdf.get_value(OTH,"offset")) + ',' + str(soundsdf.get_value(OTH,"item")) + ',' + str(soundsdf.get_value(OTH,"word")) + ',' + str(soundsdf.get_value(OTH,"speaker")) + ',' + str(soundsdf.get_value(OTH,"CV")) + ',' + str(soundsdf.get_value(OTH,"context")) + ',' + str(soundsdf.get_value(OTH,"phone")) + ',' + str(soundsdf.get_value(X,"file")) + ',' + str(soundsdf.get_value(X,"onset")) + ','+ str(soundsdf.get_value(X,"offset")) + ',' + str(soundsdf.get_value(X,"item")) + ',' + str(soundsdf.get_value(X,"word")) + ',' + str(soundsdf.get_value(X,"speaker")) + ','+ str(soundsdf.get_value(X,"CV")) + ',' + str(soundsdf.get_value(X,"context")) + ',' + str(soundsdf.get_value(X,"phone")) + '\n')
output_file.close()