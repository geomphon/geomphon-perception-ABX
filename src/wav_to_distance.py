from __future__ import print_function

import sys
import argparse
import os.path as osp

import numpy as np
import pandas as pd

import shennong.features.pipeline as snpipeline
from fastdtw import fastdtw


def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)  # FIXME WRAP


def get_item(df, row, frame_tolerance):
    if 'onset' in row.index and 'offset' in row.index \
       and 'time' in df.columns:
        rep = df[(df['file'] == row['file']) \
                 & (df['time'] >= row['onset'] - frame_tolerance) \
                 & (df['time'] <= row['offset'] + frame_tolerance)]
    else:
        rep = df[df['file'] == row['file']]
    meta = pd.DataFrame([row])
    result = rep.merge(meta, on='file', how='left')
    result['item_frame'] = range(rep.shape[0])
    return result


# FIXME: It is broke!

#def dtw_euclidean(x, y):
#    return fastdtw(x, y, dist=2)[0]

#def dtw_norm_max_euclidean(x, y):
#    dtw = fastdtw(x, y, dist=2)
#    return dtw[0] / len(dtw[1])

#def dtw_norm_both_euclidean(x, y):
#    dtw = fastdtw(x, y, dist=2)
#    return dtw[0] / (x.shape[0] + y.shape[0])

#def get_item_1(df, row):
#    info = pd.DataFrame([row[[c for c in row.keys() \
#            if len(c) > 2 and c[-2:] == "_1"]]])
#    info.columns = [c[:-2] for c in info.columns]
#    item = info.merge(df, how='left')
#    return item[[c for c in item.columns if c[0] == "F"]]
#
#
#def get_item_2(df, row):
#    info = pd.DataFrame([row[[c for c in row.keys() \
#                            if len(c) > 2 and c[-2:] == "_2"]]])
#    info.columns = [c[:-2] for c in info.columns]
#    item = info.merge(df, how='left')
#    return item[[c for c in item.columns if c[0] == "F"]]


def center_time(frame_numbers, frame_shift):
    return frame_numbers * frame_shift


#def replace_content(d, new_content):
#    result = d.copy()
#    result[sf.content_keys(d)] = new_content
#    return result

#        features_ = psf.mfcc(signal, wav_sampling_rate, feature_window_length,
#                             feature_frame_shift, nceps, nfilt, 512, 133.3333,
#                             6855.4976, 0.97, 0, True, np.hamming)
#        features_ = psf.logfbank(signal, wav_sampling_rate,
#                                 feature_window_length, feature_frame_shift,
#                                 nfilt, 512, 133.3333, 6855.4976, 0.97,
#                                 np.hamming)

#        columns=["F" + str(i) for i in range(1, features_.shape[1] + 1)])
#    # FIXME - use the (non-existent) standard_format API to set meta-columns
#    features_df['_frame_number'] = range(features_.shape[0])
#    # FIXME - this is safe to do independent of the treatment ONLY
#    # because stft used zero-padding; if it had truncated, we would have
#    # needed the feature function to give us back the times
#    features_df['_time'] = center_time(features_df['_frame_number'],
#                                       feature_frame_shift)
#    features_df['_file'] = filename


def calculate_distances(pairs, features, distance_fn):
    '''Calculate distances between given pairs.
    
    :param pairs: Pairs to be calculated
    :type pairs: Pandas DataFrame
    :param features: A dictionary of Shennong Features objects, indexed by
    filename
    :type features: dict
    :param distance_fn: A distance function applying to pairs of ndarrays
    :type distance_fn: function
    :return: A list of distance values
    :rtype: list
    '''
    return [distance_fn(get_item(features,
                                 pairs.iloc[i].loc['file_1'],
                                 pairs.iloc[i].loc['onset_1'],
                                 pairs.iloc[i].loc['offset_1']),
                        get_item(features,
                                 pairs.iloc[i].loc['file_2'],
                                 pairs.iloc[i].loc['onset_2'],
                                 pairs.iloc[i].loc['offset_2'])) \
            for i in range(len(pairs))]


def BUILD_ARGPARSE():
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    #    parser.add_argument('--distance-function', help="Name of a distance "\
    #            "function (default is 'dtw_norm_max_euclidean')", type=str,
    #            default="dtw_norm_max_euclidean")
    parser.add_argument('pair_file', help="Pair file", type=str)
    parser.add_argument('shennong_config_file',
                        help="Shennong feature extraction config file",
                        type=str)
    parser.add_argument('output_file',
                        nargs='?',
                        help="Output file",
                        type=str,
                        default=None)
    return parser


if __name__ == "__main__":
    parser = BUILD_ARGPARSE()
    args = parser.parse_args(sys.argv[1:])
    try:
        pairs = pd.read_csv(args.pair_file)
    except Exception as e:
        eprint("""Issue with pair file (<F>): <M>""".replace(
            "<F>", str(args.pair_file)).replace("<M>",
                                                str(e)).replace("\n", " "))
        sys.exit(1)

    items_1 = pairs[[
        c for c in pairs.columns if len(c) > 2 and c[-2:] == "_1"
    ]]
    items_1.columns = [c[:-2] for c in items_1.columns]
    items_2 = pairs[[
        c for c in pairs.columns if len(c) > 2 and c[-2:] == "_2"
    ]]
    items_2.columns = [c[:-2] for c in items_2.columns]
    if set(items_1.columns) != set(items_2.columns):
        eprint("""Issue with pair file (<F>):
columns don't match""".replace("<F>", str(args.pair_file)))
        sys.exit(1)
    if not set(['file', 'onset', 'offset']).issubset(items_1.columns):
        eprint("""Issue with pair file (<F>): missing 'file', 'onset',
and 'offset' columns""".replace("<F>", str(args.pair_file)))
        sys.exit(1)
    items = pd.concat([items_1, items_2], sort=True).drop_duplicates()
    files = items['file'].unique()

    #    try:
    #        distance_fn = globals()[args.distance_function]
    #    except Exception as e:
    #        eprint("""Issue with distance function (<F>): <M>""".replace(
    #            "<F>",
    #            str(args.distance_function)).replace("<M>",
    #                                                 str(e)).replace("\n", " "))
    #        sys.exit(1)

    features = snpipeline.extract_features(args.shennong_config_file, files)
    distances = calculate_distances(pairs, features, distance_fn)
    pairs['distance'] = distances

    if args.output_file is None:
        pairs.to_csv(sys.stdout, index=False)
    else:
        pairs.to_csv(args.output_file, index=False)

