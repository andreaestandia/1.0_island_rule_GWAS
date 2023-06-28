#!/bin/bash

#SBATCH --nodes=1
#SBATCH --mem=64000
#SBATCH --time=900:00:00
#SBATCH --job-name=augustus_%A_%a
#SBATCH --partition=long
#SBATCH --output=aug_%A_%a.out
#SBATCH --error=aug_%A_%a.err
#SBATCH --array=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
#SBATCH --mail-type=ALL
#SBATCH --mail-user=andrea.estandia@zoo.ox.ac.uk

module load AUGUSTUS/3.3.3-foss-2019b
module load BEDTools/2.29.2-GCC-9.3.0
module load BLAST+/2.10.1-iimpi-2020a

PATH_INPUT="/data/zool-zost/sjoh4959/projects/0.0_island_rule/slurm/evidencemodeler/output/"
PATH_REF="/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/ref_genome_chr.fasta.masked"
PATH_EVM="/data/zool-zost/sjoh4959/projects/0.0_island_rule/src/others/EVidenceModeler-1.1.1/EvmUtils/misc/augustus_GFF3_to_EVM_GFF3.pl"

$PATH_EVM "${PATH_INPUT}zosterops_augustus_chromosome${SLURM_ARRAY_TASK_ID}.gff" > "${PATH_INPUT}zosterops_augustus_chromosome${SLURM_ARRAY_TASK_ID}.gff3"
grep "CDS" "${PATH_INPUT}zosterops_augustus_chromosome${SLURM_ARRAY_TASK_ID}.gff3" > "${PATH_INPUT}zosterops_augustus_chromosome${SLURM_ARRAY_TASK_ID}_CDS.gff3"
bedtools getfasta -fi $PATH_REF -bed "${PATH_INPUT}zosterops_augustus_chromosome${SLURM_ARRAY_TASK_ID}_CDS.gff3" -fo "${PATH_INPUT}zosterops_augustus_chromosome${SLURM_ARRAY_TASK_ID}_CDS.fasta"
