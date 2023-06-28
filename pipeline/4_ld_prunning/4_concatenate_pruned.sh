#!/bin/bash

#SBATCH --nodes=1
#SBATCH --mem=64000
#SBATCH --job-name=LD_pruning
#SBATCH --partition=long

#This script works if you provide a list of chromosome in an array in the following way: chromosome_list+=("chr1A" "chrZ" "chr1") not with seq at least if a single chromosome is missing

PATH_LD_RESULTS="/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/LD/output/pruned_sites/"
PATH_INPUT_FILE="/data/zool-zost/Novogene/EstimateGLs_ImputePhaseGenotypes_ZlateralisOnly_April2022/"
PATH_OUTPUT="/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/LD/output/pruned_sites/"
PATH_DATA="/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/"
PATH_HEADER="/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/"

declare -a chromosome_list=()
#Populate the array chromosome_list with strings pasted to numbers
for i in $(seq 30)
do
  	tmp=$(echo "chr${i}")
        chromosome_list+=( $tmp )
done

#Add to array those chromosomes with a name that does not follow the pattern above (i.e. chrZ, chr1A...)
chromosome_list+=("chr1A" "chr4A" "chrZ")

#Select independent sites
for chromosome in "${chromosome_list[@]}"
do
	cat "${PATH_LD_RESULTS}${chromosome}_pruned.ld" | tr ':' '\t' | cut -f2 > sites2keep
	zcat "${PATH_INPUT_FILE}${chromosome}.beagle.gz" | grep "^${chromosome}_" | tr '_' '\t' > tmp
	grep -w -F -f sites2keep tmp > tmp2
	#Concatenate first and second columns with "_"
	cat tmp2 | cut -f1,2 | tr '\t' '_' > first_col
	paste first_col tmp2 | cut -f2,3 --complement > tmp3
	#Add header
	cat "${PATH_DATA}header" tmp3 > "${PATH_OUTPUT}${chromosome}_pruned.beagle"
	#clean
	rm sites2keep first_col tmp tmp2 tmp3
done

#Concatenate pruned chromosomes into pruned a single whole genome file
cd ${PATH_OUTPUT}

cat chr16_pruned.beagle | head -n 1 > wholegenome_pruned.beagle

#Sort list of files in natural order
readarray -d '' entries < <(printf '%s\0' *pruned.beagle | sort -zV)

#Concatenate the files
for entry in "${entries[@]}" 
do 
	cat $entry | tail -n +2 -q >> wholegenome_pruned.beagle
done
