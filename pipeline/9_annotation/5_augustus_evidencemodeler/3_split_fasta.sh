#!/bin/bash

#SBATCH --nodes=1
#SBATCH --mem=64000
#SBATCH --time=900:00:00
#SBATCH --job-name=split
#SBATCH --partition=long
#SBATCH --output=split.out
#SBATCH --error=split.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=andrea.estandia@zoo.ox.ac.uk

module load AUGUSTUS/3.3.3-foss-2019b
module load BEDTools/2.29.2-GCC-9.3.0
module load BLAST+/2.10.1-iimpi-2020a

PATH_INPUT="/data/zool-zost/sjoh4959/projects/0.0_island_rule/slurm/evidencemodeler/output/"  

awk 'BEGIN {n_seq=0;} /^>/ 
{if(n_seq%100==0){file=sprintf("zosterops_augustus_CDS_all_%d.fasta",n_seq);} 
print >> file; n_seq++; next;} { print >> file; }' < "${PATH_INPUT}zosterops_augustus_all.fasta"
