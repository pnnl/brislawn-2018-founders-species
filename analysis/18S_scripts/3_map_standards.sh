#!/bin/bash

#===============================================#
# Identify how many reads in our samples closely
# match our standards. This let's us estimate 
# the cross contamination rate between samples
# on this run.
# 2015-09-01
#===============================================#

homedir=/people/bris469/data/hans_fsfa18S
# Used all reads (or subsampled reads)
reads=$homedir/split/seqs.fna.gz
ref=$homedir/standards/Mock_Hot_Lake_Community.aligned.v4.fna
out=$homedir/standards/map
which vsearch


# I don't have the known sequences from the 
# diatom-standard MiSeq positive controls. 
# This script was not run, but these standards were used
# in other ways, see script 0_explore_standard.sh. 
exit


cd $homedir

rm -rf $out
mkdir $out


vsearch -search_exact $reads -db $ref \
-strand plus -id 1.0 -uc $out/map_100.uc -threads 10
#Matching query sequences: 0 of 5408014 (0.00%)


vsearch -usearch_global $reads -db $ref \
-strand plus -id 0.99 -uc $out/map_99.uc -threads 10
#Matching query sequences: 744613 of 5408014 (13.77%)


# We'll have to investigate that... 

cd $out
# make a table of OTUs
uc_to_otu.py -i map_100.uc -o map_100.txt
uc_to_otu.py -i map_99.uc -o map_99.txt




