#!/bin/sh
#$ -S /bin/sh
#$ -N process_radtags
#$ -cwd
#$ -M mravinet@nig.ac.jp
#$ -m bea
#$ -j y

cd $HOME/data/cichlid
export PATH=$HOME/stacks-1.29/bin

# run process_radtags - strict

LIB_PATH=./raw/${LIB}
SAMPLE_PATH=./samples/${LIB}


# trim to 175, remove all reads with Phred score less than 20
process_radtags -p $LIB_PATH -i gzfastq -o $SAMPLE_PATH -e sbfI -b ./barcodes/${LIB}_bc.txt \
-q -t 175 -r -s 20 -w 0.15 --inline_null \



