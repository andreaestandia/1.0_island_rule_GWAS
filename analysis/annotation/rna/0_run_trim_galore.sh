#!/bin/bash

#SBATCH --nodes=1
#SBATCH --mem=64000
#SBATCH --job-name=trimgalore
#SBATCH --partition=long

module purge
module load Trim_Galore/0.6.5-GCCcore-8.3.0-Java-11-Python-3.7.4

PATH_INPUT="/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/rna/input/"
PATH_OUTPUT="/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/rna/trim_galore/output/"
N_THREADS=5

trim_galore --paired --retain_unpaired -o $PATH_OUTPUT --cores $N_THREADS "${PATH_INPUT}SRR8887131_RNAseq_Illumina_HiSeq_2500_paired_end_sequencing_1.fastq.gz" "${PATH_INPUT}SRR8887131_RNAseq_Illumina_HiSeq_2500_paired_end_sequencing_2.fastq.gz"
