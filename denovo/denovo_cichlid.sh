#!/bin/sh

cd ~/denovo_rad

denovo_map.pl -m 3 -M 4 -n 4 -T 4 -b 1 -t \
-S -i 1 \
-O cichlid.popmap \
-o ./stacks \
-s ./raw_10k/citronellus_10.fq.gz \
-s ./raw_10k/citronellus_11.fq.gz \
-s ./raw_10k/citronellus_12.fq.gz \
-s ./raw_10k/citronellus_13.fq.gz \
-s ./raw_10k/citronellus_14.fq.gz \
-s ./raw_10k/citronellus_15.fq.gz \
-s ./raw_10k/citronellus_16.fq.gz \
-s ./raw_10k/citronellus_1.fq.gz \
-s ./raw_10k/citronellus_2.fq.gz \
-s ./raw_10k/citronellus_3.fq.gz \
-s ./raw_10k/citronellus_4.fq.gz \
-s ./raw_10k/citronellus_5.fq.gz \
-s ./raw_10k/citronellus_6.fq.gz \
-s ./raw_10k/citronellus_7.fq.gz \
-s ./raw_10k/citronellus_8.fq.gz \
-s ./raw_10k/citronellus_9.fq.gz \
-s ./raw_10k/labiatus_10.fq.gz \
-s ./raw_10k/labiatus_11.fq.gz \
-s ./raw_10k/labiatus_12.fq.gz \
-s ./raw_10k/labiatus_13.fq.gz \
-s ./raw_10k/labiatus_1.fq.gz \
-s ./raw_10k/labiatus_2.fq.gz \
-s ./raw_10k/labiatus_3.fq.gz \
-s ./raw_10k/labiatus_4.fq.gz \
-s ./raw_10k/labiatus_5.fq.gz \
-s ./raw_10k/labiatus_6.fq.gz \
-s ./raw_10k/labiatus_7.fq.gz \
-s ./raw_10k/labiatus_8.fq.gz \
-s ./raw_10k/labiatus_9.fq.gz
