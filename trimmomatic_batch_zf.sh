#!/bin/bash

# command line args are
# $1 = F_IN
# $2 = F_OUT

# some house keeping
module purge

# set trimmomatic path
TRIM=/projects/cees/in_progress/mark/bin/Trimmomatic-0.36/trimmomatic-0.36.jar

## set variables ##
# base directory for files
INDIR=/work/users/msravine/zebra_finch/raw
OUTDIR=/work/users/msravine/zebra_finch/trim
LOGDIR=/work/users/msravine/zebra_finch/trim_stats

# forward and reverse read names
F_IN=$INDIR/${1}_R1.fastq.gz
R_IN=$INDIR/${1}_R2.fastq.gz

# make output names
F_PAIR_OUT=$OUTDIR/$(basename ${F_IN%.*.*})_trim_pair.fastq.gz
R_PAIR_OUT=$OUTDIR/$(basename ${R_IN%.*.*})_trim_pair.fastq.gz
F_UNPAIR_OUT=$OUTDIR/$(basename ${F_IN%.*.*})_trim_unpair.fastq.gz
R_UNPAIR_OUT=$OUTDIR/$(basename ${R_IN%.*.*})_trim_unpair.fastq.gz

# log and stats files
SAMPLE=$(basename $1)
STAT=${LOGDIR}/${SAMPLE%_*}.trim

# adapter sequence
ADAPT_FAST=/projects/cees/in_progress/mark/bin/Trimmomatic-0.36/adapters/TruSeq3-PE.fa

# run trimmomatic
echo "Running trimmomatic"
java -jar $TRIM PE -threads 5 \
$F_IN $R_IN $F_PAIR_OUT $F_UNPAIR_OUT $R_PAIR_OUT $R_UNPAIR_OUT \
ILLUMINACLIP:${ADAPT_FAST}:2:30:10 LEADING:5 TRAILING:5 SLIDINGWINDOW:5:10 MINLEN:50 \
|& tee $STAT

# reads are 252 bp long
# scan for sections dropping below 10 and throw out if case
# trim leading trailing bases with less than 5
# minimum length tolerated is 50
