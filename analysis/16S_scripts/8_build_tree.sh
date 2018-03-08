#!/bin/bash

#===============================================#
# Build assign tax to a rep_set.fna using qiime's 
# parallel_assign_taxonomy_uclust.py and add
# those assignments to a .biom table
# 2016-07-12
#===============================================#

# Set up directories and clean outputs
homedir=/people/bris469/data/hans_fsfa
cd $homedir/otus_vsearch
rm -rf pynast_aligned
rm -f *.tre


# nast align your checked rep_set to green_genes
echo aligning reads
parallel_align_seqs_pynast.py -i rep_set.fna -o pynast_aligned \
-T --jobs_to_start 8

# Filter alignment
echo filtering
filter_alignment.py -i pynast_aligned/rep_set_aligned.fasta \
-o pynast_aligned

# Build phylogenetic tree
echo building tree
make_phylogeny.py -i pynast_aligned/rep_set_aligned_pfiltered.fasta \
-o rep_set.tre

echo Done!
