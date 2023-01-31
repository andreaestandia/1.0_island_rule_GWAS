#!/bin/bash

# ----------------------------------------------------------------------
# NOTES:
# ----------------------------------------------------------------------
# This script will generate a vcf-like file that can be passed to
# snpEff. The outputted VCF will contain just the first eight columns: 
# CHROM, POS, ID, REF, ALT, QUAL, FILTER, and INFO
# As snpEff ignores sample genotypes we won't bother trying to include
# these!
#
# Run script like so:
# source convert_beagle_2_snpEffvcf.sh beagle_file out_file
# ----------------------------------------------------------------------

#Set beagle file and out file
BEAGLE_FILE=${1}
OUT_FILE=${2}

#Create directory for temporary files
mkdir temp_files

#Initiate a VCF like file with header lines
echo "##fileformat=VCFv4.1" > $OUT_FILE
echo "#CHROM" "POS" "ID" "REF" "ALT" "QUAL" "FILTER" "INFO" >> $OUT_FILE

#Extract chromosome and position info from beagle file
zcat < $BEAGLE_FILE | tail -n +2 | cut -f 1 | cut -d "_" -f 1 > temp_files/chroms
zcat < $BEAGLE_FILE | tail -n +2 | cut -f 1 | cut -d "_" -f 2 > temp_files/pos

#Extract reference and alternative alleles from beagle file
#Note: angsd outputted beagle files enconde genotypes numerically as follows:
#0=A; 1=C; 2=G; 3=T
zcat < $BEAGLE_FILE | tail -n +2 | cut -f 2 \
| sed s'/0/A/'g | sed s'/1/C/'g | sed s'/2/G/'g | sed s'/3/T/'g | 
> temp_files/ref_geno
zcat < $BEAGLE_FILE | tail -n +2 | cut -f 3 \
| sed s'/0/A/'g | sed s'/1/C/'g | sed s'/2/G/'g | sed s'/3/T/'g | 
> temp_files/alt_geno

#Count number of sites in beagle file and create temp file containg just "." on each line
site_count=$(zcat < ../../data/wgs/raw/wholegenome_pruned.beagle.gz | tail -n +2 | wc -l)
for i in $(seq 1 $site_count)
do
    echo "." >> temp_files/empty
done

#Combine into a VCF
paste temp_files/chroms temp_files/pos temp_files/empty temp_files/ref_geno \
temp_files/alt_geno temp_files/empty temp_files/empty temp_files/empty \
>> $OUT_FILE

#Remove temporary files
rm -r temp_files/

#Print message
echo "conversion complete ... have a happy snpEffing time!!!"

#DONE!
