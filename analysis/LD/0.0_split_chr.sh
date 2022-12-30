#!/bin/bash

#SBATCH --nodes=1
#SBATCH --job-name=split_chr
#SBATCH --partition=long

PATH_INPUT="/data/zool-zost/Novogene/EstimateGLs_ImputePhaseGenotypes_ZlateralisOnly_April2022/"
PATH_OUT="/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/LD/output/"

for i in $(seq 9)
do
  	tmp=$(echo "chr${i}.beagle")
        chromosome_list+=( $tmp )
done

chromosome_list+=("chr1A.beagle" "chr4A.beagle" "chrZ.beagle")


for chromosome in "${chromosome_list[@]}"
do
    zcat "${PATH_INPUT}${chromosome}.gz" | tail -n +2 > "${PATH_OUT}tmp"
    split -l 150000 --numeric-suffixes "${PATH_OUT}tmp" "${PATH_OUT}${chromosome}_"
    rm "${PATH_OUT}tmp"
    mv *"${PATH_OUT}${chromosome}_0"* "${PATH_OUT}subsets"
    mv *"${PATH_OUT}{chromosome}_1"* "${PATH_OUT}subsets"

done
