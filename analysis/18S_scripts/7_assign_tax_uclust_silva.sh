#!/bin/bash

#===============================================#
# Build assign tax to a rep_set.fna using qiime's 
# assign_taxonomy.py and add
# those assignments to a .biom table
#===============================================#

# Set up directories and clean outputs
homedir=/people/bris469/data/hans_fsfa18S
cd $homedir/otus_vsearch
rm -rf uclust_assign_tax_silva
rm -r otu_table_w_tax_silva*


# assign tax to the same chimera checked rep set you mapped reads back on to.
echo "running assign_taxonomy.py"
parallel_assign_taxonomy_uclust.py -i rep_set.fna -o uclust_assign_tax_silva \
--similarity .8 -O 8 \
-t /people/bris469/bin/databases/SILVA_132_QIIME_release/taxonomy/taxonomy_all/97/taxonomy_7_levels.txt \
-r /people/bris469/bin/databases/SILVA_132_QIIME_release/rep_set/rep_set_all/97/silva132_97.fna
echo "Done!"

# add to biome file
echo "adding metadata"
biom add-metadata -i otu_table.biom -o otu_table_w_tax_silva.biom \
--observation-metadata-fp uclust_assign_tax_silva/rep_set_tax_assignments.txt \
--sc-separated taxonomy --observation-header OTUID,taxonomy

biom summarize-table -i otu_table_w_tax.biom -o otu_table_w_tax.summary.txt

biom convert -i otu_table_w_tax_silva.biom -o otu_table_w_tax_silva.txt \
--to-tsv --header-key taxonomy

# Convert to JSON format, so it's compatable with other software.
biom convert -i otu_table_w_tax_silva.biom -o otu_table_w_tax_silva.biom \
--table-type="OTU table" --to-json

echo "Done!"



