#!/bin/bash

#SBATCH --nodes=1
#SBATCH --mem=64000
#SBATCH --job-name=blat
#SBATCH --partition=long
#SBATCH --time=900:00:00

module load BLAT/3.5-GCC-9.3.0

PATH_REF="/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/"
PATH_RNA="/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/rna/trinity_chr/"
PATH_OUT="/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/blat/"

blat -t=dna -q=rna "${PATH_REF}ref_genome_chr.fasta.masked" "${PATH_RNA}Trinity-GG.fasta" "${PATH_OUT}zosterops_blat_chr.psl"
