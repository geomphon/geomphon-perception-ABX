#Convert the file created by add_meta_information_to_iten_file.Rscript to csv file with some triplets
#Generating all triplets cannot always be done, it can be too much for the rest of the scripts to handle, so some conditions are set to generate them.

# Author: Nicolas Brasset, Ewan Dunbar

import pandas as pd
import numpy as np
import sys, argparse
import timeit

def remove_hash(df):
    return df.rename(columns=lambda s: s.replace("#", ""))

def add_suffix(df, suffix):
    return df.rename(columns=lambda s: s + suffix)

def duplicate_n(df, n):
    return df.iloc[np.repeat(np.arange(df.shape[0]), n)].reset_index(drop=True)

def repeat_n(df, n):
    return df.iloc[np.tile(np.arange(df.shape[0]), n)].reset_index(drop=True)

def cart_prod(df_a, df_b):
    df_a['KEY'] = 0
    df_b['KEY'] = 0
    return pd.merge(df_a, df_b).drop("KEY", axis=1)

parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
parser.add_argument('--constraints-ab', type=str, default=None,
                    help="additional constraints to place on the target/other pairs")
parser.add_argument('--constraints-ax', type=str, default=None,
                    help="additional constraints to place on the target/X pairs")
parser.add_argument('input_path',
        help="filename of the file created by add_meta_information_to_item_file.Rscript",
        type=str)
parser.add_argument('output_path',
        help="filename for the output file",
        type=str)
args = parser.parse_args()

soundsdf = pd.read_csv(args.input_path)
soundsdf_a = add_suffix(remove_hash(soundsdf[:]), "_TGT")
soundsdf_b = add_suffix(remove_hash(soundsdf[:]), "_OTH")
soundsdf_x = add_suffix(remove_hash(soundsdf[:]), "_X")

soundsdf_ab = cart_prod(soundsdf_a, soundsdf_b)\
        .query("speaker_TGT != speaker_OTH")\
        .query("phone_TGT != phone_OTH")
if args.constraints_ab is not None:
    soundsdf_ab = soundsdf_ab.query(args.constraints_ab)
soundsdf_ax = cart_prod(soundsdf_a, soundsdf_x)\
        .query("speaker_TGT != speaker_X")\
        .query("phone_TGT == phone_X")
if args.constraints_ax is not None:
    soundsdf_ax = soundsdf_ax.query(args.constraints_ax)

soundsdf_abx = pd.merge(soundsdf_ab, soundsdf_ax)\
        .query("speaker_OTH != speaker_X") # Risks running out of memory

soundsdf_abx.to_csv(args.output_path, index=False)

#for TGT in soundsdf.index :
#	TGT_speaker = soundsdf.at[TGT,"speaker"]
#	for OTH in soundsdf.index :
#		OTH_speaker = soundsdf.at[OTH,"speaker"]
#		for X in soundsdf.index :
#			X_speaker = soundsdf.at[X,"speaker"]
#			#We only generate triplets when all speakers are different. (in our case speakers had 2 files, that's why we do not take the last character)
#			if (TGT_speaker[:-1] != X_speaker[:-1]) and (OTH_speaker[:-1] != X_speaker[:-1]) and (OTH_speaker[:-1] != TGT_speaker[:-1]):
#				TGT_phone = soundsdf.at[TGT,"phone"]
#				OTH_phone = soundsdf.at[OTH,"phone"]
#				X_phone = soundsdf.at[X,"phone"]
#				#We only generate triplets when 2 phone are the same (either TGT and X, or OTH and X)
#				if (TGT_phone != OTH_phone) and ((TGT_phone == X_phone) or (OTH_phone == X_phone)): 
#					output_file.write(str(soundsdf.at[TGT,"file"]) + ',' + str(soundsdf.at[TGT,"onset"]) + ',' + str(soundsdf.at[TGT,"offset"]) + ',' + str(soundsdf.at[TGT,"item"]) + ',' + str(soundsdf.at[TGT,"word"]) + ',' + str(soundsdf.at[TGT,"speaker"]) + ',' + str(soundsdf.at[TGT,"CV"]) + ',' + str(soundsdf.at[TGT,"context"]) + ',' + str(soundsdf.at[TGT,"phone"]) + ',' + str(soundsdf.at[OTH,"file"]) + ',' + str(soundsdf.at[OTH,"onset"]) + ',' + str(soundsdf.at[OTH,"offset"]) + ',' + str(soundsdf.at[OTH,"item"]) + ',' + str(soundsdf.at[OTH,"word"]) + ',' + str(soundsdf.at[OTH,"speaker"]) + ',' + str(soundsdf.at[OTH,"CV"]) + ',' + str(soundsdf.at[OTH,"context"]) + ',' + str(soundsdf.at[OTH,"phone"]) + ',' + str(soundsdf.at[X,"file"]) + ',' + str(soundsdf.at[X,"onset"]) + ','+ str(soundsdf.at[X,"offset"]) + ',' + str(soundsdf.at[X,"item"]) + ',' + str(soundsdf.at[X,"word"]) + ',' + str(soundsdf.at[X,"speaker"]) + ','+ str(soundsdf.at[X,"CV"]) + ',' + str(soundsdf.at[X,"context"]) + ',' + str(soundsdf.at[X,"phone"]) + '\n')
#output_file.close()
