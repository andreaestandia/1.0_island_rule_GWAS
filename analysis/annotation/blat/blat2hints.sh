#!/bin/bash

#SBATCH --nodes=1
#SBATCH --mem=64000
#SBATCH --job-name=blat2hints
#SBATCH --partition=long

module load AUGUSTUS/3.4.0-foss-2020b

cat zosterops_blat.psl | sort -n -k 16,16 | sort -s -k 14,14 > zosterops_blat_sorted.psl
blat2hints.pl --in=zosterops_blat_sorted.psl --out=zosterops_blat_hints.out
