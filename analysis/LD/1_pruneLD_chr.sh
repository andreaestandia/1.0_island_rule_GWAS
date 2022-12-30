#!/bin/bash

#SBATCH --nodes=1
#SBATCH --mem=64000
#SBATCH --time=900:00:00
#SBATCH --job-name=pru1A_1
#SBATCH --partition=long

module purge
module load ngsLD/2020
module load Perl/5.34.0-GCCcore-11.2.0-ARC

PATH_PRUNE="/data/zool-zost/sjoh4959/projects/0.0_island_rule/src/others/ngsLD/scripts/prune_graph.pl"
PATH_INPUT="/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/LD/output/"
PATH_OUT="/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/LD/output/pruned_sites/"
MIN_WEIGHT=0.7
MAX_KB_DIST=5

declare -a chromosome_list=()
#Populate the array chromosome_list with strings pasted to numbers
#for i in $(seq 30)
#do
#        tmp=$(echo "chr${i}")
#        chromosome_list+=( $tmp )
#done

#chromosome_list+=("chrZ" "chr1A" "chr4A")
chromosome_list+=("chr1A_01")

for chromosome in "${chromosome_list[@]}"
do
        perl $PATH_PRUNE --in_file "${PATH_INPUT}${chromosome}.ld" --max_kb_dist $MAX_KB_DIST --min_weight $MIN_WEIGHT --out "${PATH_OUT}${chromosome}_pruned2.ld"
done
