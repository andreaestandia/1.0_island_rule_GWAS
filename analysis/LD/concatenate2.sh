#!/bin/bash

#SBATCH --nodes=1
#SBATCH --mem=64000
#SBATCH --job-name=LD_pruning
#SBATCH --partition=long

declare -a chromosome_list=()
#Populate the array chromosome_list with strings pasted to numbers
#for i in $(seq 30)
#do
#  	tmp=$(echo "chr${i}")
#        chromosome_list+=( $tmp )
#done

#Add to array those chromosomes with a name that does not follow the pattern above (i.e. chrZ, chr1A...)
#chromosome_list+=("chr18" "chr19" "chr20" "chr21" "chr22" "chr23" "chr24" "chr25" "chr26" "chr27" "chr28" "chr29" "chr30")
chromosome_list+=("chr6" "chr7")

#Select independent sites
for chromosome in "${chromosome_list[@]}"
do
  	cat "${chromosome}_pruned2.ld" | tr ':' '\t' | cut -f2 > sites2keep
        zcat "/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/LD/input/${chromosome}.gz" | grep "^${chromosome}_" | tr '_' '\t' > tmp
        grep -w -F -f sites2keep tmp > tmp2
        #Concatenate first and second columns with "_"
        cat tmp2 | cut -f1,2 | tr '\t' '_' > first_col
        paste first_col tmp2 | cut -f2,3 --complement > tmp3
        #Add header
        cat "/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/header" tmp3 > "${chromosome}_pruned2.beagle"
        #clean
	rm sites2keep first_col tmp tmp2 tmp3
done
