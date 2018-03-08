#!/bin/bash

#===============================================#
# Using vsearch, dereplicate and check for 
# chimeras
# 2016-07-12
#===============================================#

# Setting up folders
homedir=/people/bris469/data/hans_fsfa
reads=$homedir/split/seqs.fna.gz
output=$homedir/otus_vsearch

rm -rf $output
mkdir $output

which vsearch

cd $output



# dereplicate, sort, and discard reads which appear once
vsearch -derep_fulllength $reads --sizeout \
--relabel derep_ --minuniquesize 2 \
--output seqs.derep.mc2.fna --log seqs.derep.mc2.log


rm -rf chimeras
mkdir chimeras

# chimera checking (denovo) (additional outputs omitted to save time)
vsearch --uchime_denovo seqs.derep.mc2.fna \
--strand plus --sizein --sizeout \
--nonchimeras chimeras/seqs.checked_denovo.fna \
--log chimeras/seqs.checked_denovo.log
#--chimeras chimeras/seqs.chimeras_denovo.fna \
#--uchimealns chimeras/seqs.checked_denovo.aln \
#--uchimeout chimeras/seqs.checked_denovo.uchime

vsearch --uchime_ref chimeras/seqs.checked_denovo.fna \
--db ../rdp_gold.fa --threads 8 \
--nonchimeras chimeras/seqs.checked_denovo.ref.fna \
--log chimeras/seqs.checked_denovo.ref.log


cp chimeras/seqs.checked_denovo.ref.fna .




