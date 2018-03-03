#!/bin/sh

# short bash script to perform alignments, convert and sort bam

cd $HOME/ref_rad

# declare an array to loop through
INDS=($(for i in ./raw_10k/*.fastq.gz; do echo $(basename ${i%_*}); done | uniq))

for IND in ${INDS[@]};
do

	# first align
	echo "Aligning $IND with bowtie2"
	bowtie2 -x ./gac -1 ./raw_10k/${IND}_1.fastq.gz \
	-2 ./raw_10k/${IND}_2.fastq.gz \
	-N 0 -p 4 \
	-S ./align/${IND}.sam

	# print read statistics to screen
	echo "Read stats for $IND are:"
	samtools flagstat ./align/${IND}.sam

	# convert to bam
	echo "Converting to bam"
	samtools view ./align/${IND}.sam -b -o ./align/${IND}.bam

	# sort bam
	echo "Sorting bam"
	samtools sort ./align/${IND}.bam -o ./align/${IND}_sort.bam

done
