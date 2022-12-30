#!/bin/bash

#SBATCH --nodes=1
#SBATCH --mem=64000
#SBATCH --time=900:00:00
#SBATCH --job-name=augustus_%A_%a
#SBATCH --partition=long
#SBATCH --output=ld_%A_%a.out
#SBATCH --error=ld_%A_%a.err
#SBATCH --array=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
#SBATCH --mail-type=ALL
#SBATCH --mail-user=andrea.estandia@zoo.ox.ac.uk

module load AUGUSTUS/3.3.3-foss-2019b

PATH_INPUT="/data/zool-zost/sjoh4959/projects/0.0_island_rule/slurm/evidencemodeler/"

export AUGUSTUS_CONFIG_PATH="/data/zool-zost/sjoh4959/projects/0.0_island_rule/src/others/Augustus/config/"
#
augustus --strand=both --singlestrand=true \
--hintsfile="${PATH_INPUT}chromosome${SLURM_ARRAY_TASK_ID}/zosterops_hints_RM_E.gff3" \
--extrinsicCfgFile=extrinsic_RME.cfg \
--alternatives-from-evidence=true \
--gff3=on \
--uniqueGeneId=true \
--softmasking=1 \
--species=BUSCO_Zlat_busco_augustus_aves \
"${PATH_INPUT}chromosome${SLURM_ARRAY_TASK_ID}/ref_genome_chr.fasta.masked" > "output/zosterops_augustus_chromosome${SLURM_ARRAY_TASK_ID}.gff"
#
#echo = `date` job $JOB_NAME done
#
