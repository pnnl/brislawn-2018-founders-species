#!/bin/bash

#===============================================#
# Run pictust on closed-ref .biom table
#===============================================#

# Set up directories and clean outputs
homedir=/people/bris469/data/hans_fsfa

cd $homedir
# work directly inside the closed-ref folder
cd closed-ref
# Clean output
rm -rf picrust
mkdir picrust

echo Normalizing table
normalize_by_copy_number.py \
-i otu_table_w_tax.biom \
-o picrust/normalized_otus.biom

echo Run picrust to get KO
predict_metagenomes.py -i picrust/normalized_otus.biom \
-f -o picrust/ko_metagenome_predictions.tab \
-a picrust/nsti_per_sample.tab

# picrust can also predict cog and rfam. Pass using the -t flag.

# After runing picrust, zip file for export
cd $homedir
zip -r closed-ref.zip closed-ref/otu* closed-ref/picrust/*
