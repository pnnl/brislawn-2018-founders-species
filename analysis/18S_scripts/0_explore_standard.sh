#!/bin/bash


#===============================================#
# Explore diatom standards
# 2016-09-16
#===============================================#


# Setting up folders
homedir=/people/bris469/data/hans_fsfa18S
input=$homedir/standards
output=$homedir/output

cd $input

# Get quality into
vsearch --fastq_stats diatom-standard_R1.fastq.gz --log R1.log
vsearch --fastq_stats diatom-standard_R2.fastq.gz --log R2.log

# Join
vsearch --fastq_mergepairs diatom-standard_R1.fastq.gz \
--reverse diatom-standard_R2.fastq.gz --fastqout merged.fastq
#    137569  Pairs
#      4566  Merged (3.3%)
#    133003  Not merged (96.7%)

# My god these tank quickly! No wonder they don't join...
# Let's try clipping before joining.
vsearch --fastq_filter diatom-standard_R1.fastq.gz --fastqout R1_trim.fastq --fastq_trunclen 170
vsearch --fastq_filter diatom-standard_R2.fastq.gz --fastqout R2_trim.fastq --fastq_trunclen 170
pigz -f *fastq

# Join with fastq_allowmergestagger
vsearch --fastq_mergepairs R1_trim.fastq.gz --reverse R2_trim.fastq.gz \
--fastqout trim_merged.fastq --fastq_allowmergestagger
#    137569  Pairs
#    128904  Merged (93.7%)
#      8665  Not merged (6.3%)

# Get quality of the merged file
vsearch --fastq_stats trim_merged.fastq --log trim_merged.log


# Play with pairing, now that we know what the amplicon should look like.
vsearch --fastq_mergepairs R1_trim.fastq.gz --reverse R2_trim.fastq.gz \
--fastqout trim_merged2.fastq --fastq_allowmergestagger \
--fastq_minovlen 80 --fastq_maxdiffs 10
#    137569  Pairs
#    131727  Merged (95.8%)
#      5842  Not merged (4.2%)

vsearch --fastq_stats trim_merged2.fastq --log trim_merged2.log

# Apply a filter which does not require reads to be the same length
vsearch --fastq_filter trim_merged2.fastq --fastaout trim_merged2_filtered.fasta \
--fastq_maxee 0.1
#119340 sequences kept (of which 0 truncated), 12387 sequences discarded.

# Pretty good method. This keeps 86% of all reads, at a very high quality.
# (We may have to experiment with then ends if random bases remain
# on the ends which foul derep and clustering.)



