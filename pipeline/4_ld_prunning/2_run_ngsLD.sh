#!/bin/bash

#SBATCH --nodes=1
#SBATCH --mem=64000
#SBATCH --time=900:00:00
#SBATCH --job-name=ngsLD
#SBATCH --partition=long
#SBATCH --output=ld_%A_%a.out
#SBATCH --error=ld_%A_%a.err
#SBATCH --array=1
#SBATCH --mail-user=andrea.estandia@zoo.ox.ac.uk
#SBATCH --mail-type=ALL

module purge
module load ngsLD/2020

PATH_INPUT="/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/LD/input/"
PATH_OUTPUT="/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/LD/output/"
N_IND=377
N_THREADS=40
MAX_KB_DIST=0
MAX_SNP_DIST=0

declare -a chromosome_list=()

#Populate the array chromosome_list with strings pasted to numbers
for i in $(seq 30)
do
        tmp=$(echo "chr${i}")
        chromosome_list+=( $tmp )
done

chromosome_list+=("chrZ" "chr1A" "chr4A")

for chromosome in "${chromosome_list[@]}"
do
	N_SITES=$(cat "${PATH_INPUT}${chromosome}.beagle_${SLURM_ARRAY_TASK_ID}.gz_pos" | wc -l)
	#N_SITES=$((tmp-1))
	ngsLD --geno "${PATH_INPUT}${chromosome}.beagle_${SLURM_ARRAY_TASK_ID}.gz" --probs --n_ind  $N_IND  --n_sites $N_SITES --out "${PATH_OUTPUT}${chromosome}_0${SLURM_ARRAY_TASK_ID}.ld" --n_threads $N_THREADS --max_kb_dist 10 --extend_out --pos "${PATH_INPUT}${chromosome}.beagle_${SLURM_ARRAY_TASK_ID}.gz_pos"
done
