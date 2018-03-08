#!/bin/bash

#===============================================#
# Build a .biom table from an .fna and input reads
# 2016-07-12
#===============================================#

# Set up directories and clean outputs
homedir=/people/bris469/data/hans_fsfa
reads=$homedir/split/seqs.fna.gz

cd $homedir
# Clean output
rm -rf closed-ref
mkdir closed-ref
cd closed-ref

# map the all reads (including singletons) from add_qiime_lables
# onto the greengenes database
vsearch -usearch_global $reads \
-db /people/bris469/bin/anaconda/envs/qiime-conda/lib/python2.7/site-packages/qiime_default_reference/gg_13_8_otus/rep_set/97_otus.fasta \
-strand plus -id 0.97 -uc gg.map.uc -threads 23
# Matching query sequences: 4526023 of 5408014 (83.69%)


# make a table of OTUs
uc_to_otu.py -i gg.map.uc -o otu_table.txt

# convert that table to biom format (after loading qiime)
#source activate qiime-git
biom convert --table-type="OTU table" -i otu_table.txt \
-o otu_table.biom --to-json

# add taxonomy metadata (directly from greengenes)
biom add-metadata -i otu_table.biom -o otu_table_w_tax.biom \
--observation-metadata-fp /people/bris469/bin/anaconda/envs/qiime-conda/lib/python2.7/site-packages/qiime_default_reference/gg_13_8_otus/taxonomy/97_otu_taxonomy.txt \
--sc-separated taxonomy --observation-header OTUID,taxonomy

biom summarize-table -i otu_table_w_tax.biom -o otu_table_w_tax.summary.txt
