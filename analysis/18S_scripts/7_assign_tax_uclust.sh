#!/bin/bash

#===============================================#
# Build assign tax to a rep_set.fna using qiime's 
# assign_taxonomy.py and add
# those assignments to a .biom table
#===============================================#

# Set up directories and clean outputs
homedir=/people/bris469/data/hans_fsfa18S
cd $homedir/otus_vsearch
rm -rf uclust_assign_tax
rm -r otu_table_w_tax*


# assign tax to the same chimera checked rep set you mapped reads back on to.
echo "running assign_taxonomy.py"
assign_taxonomy.py -i rep_set.fna -o uclust_assign_tax \
--similarity .7 \
-r /people/bris469/bin/databases/SILVA123_QIIME_release/rep_set/rep_set_18S_only/97/97_otus_18S.fasta \
-t /people/bris469/bin/databases/SILVA123_QIIME_release/taxonomy/18S_only/97/taxonomy_7_levels.txt
# This uses a much lower threshold than usual (.7 instead of .9) to try to get more hits.
# This also uses the taxonomy_7_levels.txt file because the majority and consensus 
# files did not have all matching taxa listed. (Ask Tony Walters about that.)
echo "Done!"

# add to biome file
echo "adding metadata"
biom add-metadata -i otu_table.biom -o otu_table_w_tax.biom \
--observation-metadata-fp uclust_assign_tax/rep_set_tax_assignments.txt \
--sc-separated taxonomy --observation-header OTUID,taxonomy

biom summarize-table -i otu_table_w_tax.biom -o otu_table_w_tax.summary.txt

biom convert -i otu_table_w_tax.biom -o otu_table_w_tax.txt \
--to-tsv --header-key taxonomy

# Convert to JSON format, so it's compatable with other software.
biom convert -i otu_table_w_tax.biom -o otu_table_w_tax.biom \
--table-type="OTU table" --to-json

echo "Done!"



