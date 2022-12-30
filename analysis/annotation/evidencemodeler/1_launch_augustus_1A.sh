#!/bin/bash

#SBATCH --nodes=1
#SBATCH --mem=64000
#SBATCH --time=900:00:00
#SBATCH --job-name=augustus_1A
#SBATCH --partition=long
#SBATCH --mail-type=ALL
#SBATCH --mail-user=andrea.estandia@zoo.ox.ac.uk

module load AUGUSTUS/3.3.3-foss-2019b

PATH_INPUT="/data/zool-zost/sjoh4959/projects/0.0_island_rule/slurm/evidencemodeler/"

export AUGUSTUS_CONFIG_PATH="/data/zool-zost/sjoh4959/projects/0.0_island_rule/src/others/Augustus/config/"
#
augustus --strand=both --singlestrand=true \
--hintsfile="${PATH_INPUT}chromosome1A/zosterops_hints_RM_E.gff3" \
--extrinsicCfgFile=extrinsic_RME.cfg \
--alternatives-from-evidence=true \
--gff3=on \
--uniqueGeneId=true \
--softmasking=1 \
--species=BUSCO_Zlat_busco_augustus_aves \
"${PATH_INPUT}chromosome1A/ref_genome_chr.fasta.masked" > "output/zosterops_augustus_chromosome1A.gff"
#
#echo = `date` job $JOB_NAME done
#
