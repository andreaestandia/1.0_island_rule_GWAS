#!/bin/bash

#SBATCH --nodes=1
#SBATCH --mem=64000
#SBATCH --job-name=LD_pruning
#SBATCH --partition=long

gzip wholegenome_pruned2.beagle
