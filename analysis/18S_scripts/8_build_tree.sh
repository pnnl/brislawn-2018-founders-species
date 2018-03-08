#!/bin/bash

#===============================================#
# Build assign tax to a rep_set.fna using qiime's 
# parallel_assign_taxonomy_uclust.py and add
# those assignments to a .biom table
# 2016-07-12
#===============================================#

# Set up directories and clean outputs
homedir=/people/bris469/data/hans_fsfa18S
cd $homedir/otus_vsearch
rm -rf pynast_aligned
rm -f *.tre


# nast align your checked rep_set to Silva
# I need to check how well this does as Silva alignments may not work well. 
echo aligning reads
parallel_align_seqs_pynast.py -i rep_set.fna -o pynast_aligned \
-T --jobs_to_start 8 \
-t /people/bris469/bin/databases/SILVA123_QIIME_release/core_alignment/core_alignment_SILVA123.fasta 


echo Filtering alignment
filter_alignment.py -i pynast_aligned/rep_set_aligned.fasta \
--suppress_lane_mask_filter -o pynast_aligned

echo Building phylogenetic tree
make_phylogeny.py -i pynast_aligned/rep_set_aligned_pfiltered.fasta \
-o rep_set.tre

echo Done!
