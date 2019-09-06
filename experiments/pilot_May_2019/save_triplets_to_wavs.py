###########################################
###CONCATENATE INTERVAL .wavs into full wav#
###########################################
#9 November 2018 by Amelia
#5 September 2019 by Ewan

from pydub import AudioSegment
# On Mac: brew install ffmpeg --with-libvorbis
import pandas as pd
import argparse
import os, sys


def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)  # FIXME WRAP


def BUILD_ARGPARSE():
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--ab-silence-interval',
                        type=int,
                        default=500,
                        help="AB Silence interval (ms)")
    parser.add_argument('--bx-silence-interval',
                        type=int,
                        default=500,
                        help="BX Silence interval (ms)")
    parser.add_argument('triplet_file', help="Triplet file name", type=str)
    parser.add_argument('interval_folder',
                        help="Interval folder name",
                        type=str)
    parser.add_argument('triplet_folder',
                        help="Output triplet folder name",
                        type=str)
    return parser


if __name__ == "__main__":
    parser = BUILD_ARGPARSE()
    args = parser.parse_args(sys.argv[1:])

    wav_folder = os.path.join(args.triplet_folder, "wav")
    mp3_folder = os.path.join(args.triplet_folder, "mp3")
    ogg_folder = os.path.join(args.triplet_folder, "ogg")
    for f in [wav_folder, mp3_folder, ogg_folder]:
        if not os.path.isdir(f):
            os.makedirs(f)

    silence_ab = AudioSegment.silent(duration=args.ab_silence_interval)
    silence_bx = AudioSegment.silent(duration=args.bx_silence_interval)

    triplets = pd.read_csv(args.triplet_file)
    for _, triplet in triplets.iterrows():
        try:
            audio_TGT = AudioSegment.from_wav(triplet['file_TGT'])
            audio_OTH = AudioSegment.from_wav(triplet['file_OTH'])
            audio_X = AudioSegment.from_wav(triplet['file_X'])
        except Exception as e:
            eprint("""Problem reading audio file: <M>""".replace(
                "<M>", str(e)).replace("\n", " "))
            sys.exit(1)
        if triplet['AB_Order'] == "TgtOth":
            audio_1, audio_2 = audio_TGT, audio_OTH
        else:
            audio_1, audio_2 = audio_OTH, audio_TGT
        audio = audio_1 + silence_ab + audio_2 + silence_bx + audio_X
        audio.export(os.path.join(wav_folder, triplet['triplet_id'] + ".wav"),
                     format="wav")
        audio.export(os.path.join(mp3_folder, triplet['triplet_id'] + ".mp3"),
                     format="mp3")
        audio.export(os.path.join(ogg_folder, triplet['triplet_id'] + ".ogg"),
                     format="ogg")
