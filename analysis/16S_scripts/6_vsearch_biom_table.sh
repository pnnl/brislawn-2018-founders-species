#!/bin/bash

#===============================================#
# Build a .biom table from an .fna and input reads 
# 2016-07-12
#===============================================#

# Set up directories and clean outputs
homedir=/people/bris469/data/hans_fsfa
reads=$homedir/split/seqs.fna.gz

cd $homedir/otus_vsearch
rm -rf otu_table.map.uc
rm -rf otu_table_mc2.txt
rm -rf otu_table_mc2.biom


# map the all reads (including singletons) from add_qiime_lables onto the rep set of OTUs
vsearch -usearch_global $reads -db rep_set.fna \
-strand plus -id 0.97 -uc otu_table.map.uc -threads 10
# Very high mapping. (Makes sense, as almost no OTUs were removed during 
# chimera checking.)

# make a table of OTUs
uc_to_otu.py -i otu_table.map.uc -o otu_table.txt

# convert that table to biom format (after loading qiime)
#source activate qiime-git
biom convert --table-type="OTU table" -i otu_table.txt \
-o otu_table.biom --to-json 



