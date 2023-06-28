#!/bin/sh

for start in `seq -f "%.0f" 100 100 774600`
	do 
	echo '#!/bin/bash

#SBATCH --nodes=1
#SBATCH --mem=64000
#SBATCH --time=900:00:00
#SBATCH --job-name=blast_'${start}'.log
#SBATCH --partition=long
#SBATCH --output=blast_'${start}'.log

module load BLAST+/2.10.1-iimpi-2020a

PATH_INPUT="/data/zool-zost/sjoh4959/projects/0.0_island_rule/slurm/evidencemodeler/output/split_fasta/"
PATH_OUT="/data/zool-zost/sjoh4959/projects/0.0_island_rule/slurm/blastx/output/"

blastx -query "${PATH_INPUT}zosterops_augustus_CDS_all_'${start}'.fasta" -db nr -outfmt 5 -max_target_seqs 10 -evalue 1e-4 -out "${PATH_OUT}zosterops_augustus_CDS_all_'${start}'.xml" -remote -entrez_query "Aves [Organism]"
#' &> "blast_zosterops_augustus_all_$start.job"
done

#mv "blast_zosterops_augustus_all_$start.job" job_files
