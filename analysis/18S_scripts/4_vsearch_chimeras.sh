#!/bin/bash

#===============================================#
# Using vsearch, dereplicate and check for 
# chimeras
#===============================================#

# Setting up folders
homedir=/people/bris469/data/hans_fsfa18S
reads=$homedir/split/seqs.fna.gz
output=$homedir/otus_vsearch

rm -rf $output
mkdir $output

cd $output

# dereplicate, sort, and discard reads which appear once
vsearch --derep_fulllength $reads --sizeout \
--relabel derep_ --minuniquesize 2 \
--output seqs.derep.mc2.fna --log seqs.derep.mc2.log


# Manually took a look at that derep file to see if anything funny was going on!
# MSA looked OK. High abundances and no overhang.
# Most reads end with this highly-conserved motif: AAGTCGTAACAAGGT

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

# Supper, supper low chimeric levels.

cp chimeras/seqs.checked_denovo.fna .




