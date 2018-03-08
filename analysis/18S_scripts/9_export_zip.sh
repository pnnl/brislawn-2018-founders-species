#!/bin/bash

#===============================================#
# Export key files to a zip archive for easy
# downloading and sharing
# 2016-08-01
#===============================================#

# Set up directories and clean outputs
homedir=/people/bris469/data/hans_fsfa18S
cd $homedir
rm -f otus_vsearch.zip

zip otus_vsearch.zip \
otus_vsearch/otu_table_w_tax.biom \
otus_vsearch/otu_table_w_tax.summary.txt \
otus_vsearch/rep_set.* \
otus_vsearch/seqs.derep.mc2.log \
otus_vsearch/chimeras/seqs.checked_denovo.log

echo Done!
