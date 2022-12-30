#!/bin/bash

#SBATCH --nodes=1
#SBATCH --mem=64000
#SBATCH --job-name=EM
#SBATCH --partition=long

PATH_EM="/data/zool-zost/sjoh4959/projects/0.0_island_rule/src/others/EVidenceModeler-1.1.1/EvmUtils/"
PATH_REF_MASKED="/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/"
PATH_HINTS="/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/blat/"
PATH_PART="/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/evidencemodeler/"


perl "${PATH_EM}partition_EVM_inputs.pl" \
     --genome "${PATH_REF_MASKED}ref_genome_chr.fasta.masked" \
     --gene_predictions "${PATH_HINTS}zosterops_hints_RM_E.gff3" \
     --segmentSize 1000000 --overlapSize 300000 \
     --partition_listing "${PATH_PART}partitions_list.out"
