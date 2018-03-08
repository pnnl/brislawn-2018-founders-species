#!/bin/bash

#===============================================#
# Join all demultiplexed fastq files
# 2016-07-12
#===============================================#

# Setting up folders
homedir=/people/bris469/data/hans_fsfa18S
input=$homedir/join
output=$homedir/filter
split=$homedir/split
rm -rf $output
rm -rf $split
mkdir $output
mkdir $split


# Print read names
cd $input
ls -S *fastq* > $output/readnames.txt
echo "head of readnames.txt:"
head $output/readnames.txt

parallel --jobs 4 '
#  echo {}
  outputname="$(echo {1} | cut -d_ -f1)"
#  echo $outputname
# The relabel command is used here to add qiime labels to the fasta headers.
  vsearch --fastq_filter {1} \
    --fastaout {2}/${outputname}_filtered.fasta \
    --fastq_maxee 0.1 \
    --relabel ${outputname}_
' :::: $output/readnames.txt ::: $output

echo Copying and compressing
cat $output/*fasta | pigz -c > $split/seqs.fna.gz

echo Samples names: 
echo
ls $output | cut -d_ -f1
echo

echo Removing intermediate files
rm -rf $output
