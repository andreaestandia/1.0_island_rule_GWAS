#!/bin/bash

#SBATCH --nodes=1
#SBATCH --mem=64000
#SBATCH --time=900:00:00
#SBATCH --job-name=augustus_%A_%a
#SBATCH --partition=long
#SBATCH --output=aug_%A_%a.out
#SBATCH --error=aug_%A_%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=andrea.estandia@zoo.ox.ac.uk

module load AUGUSTUS/3.3.3-foss-2019b
module load BEDTools/2.29.2-GCC-9.3.0
module load BLAST+/2.10.1-iimpi-2020a

PATH_INPUT="/data/zool-zost/sjoh4959/projects/0.0_island_rule/slurm/evidencemodeler/output/"
PATH_REF="/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/ref_genome_chr.fasta.masked"
PATH_EVM="/data/zool-zost/sjoh4959/projects/0.0_island_rule/src/others/EVidenceModeler-1.1.1/EvmUtils/misc/augustus_GFF3_to_EVM_GFF3.pl"

$PATH_EVM "${PATH_INPUT}zosterops_augustus_chromosomeZ.gff" > "${PATH_INPUT}zosterops_augustus_chromosomeZ.gff3"
grep "CDS" "${PATH_INPUT}zosterops_augustus_chromosomeZ.gff3" > "${PATH_INPUT}zosterops_augustus_chromosomeZ_CDS.gff3"
bedtools getfasta -fi $PATH_REF -bed "${PATH_INPUT}zosterops_augustus_chromosomeZ_CDS.gff3" -fo "${PATH_INPUT}zosterops_augustus_chromosomeZ_CDS.fasta"
#makeblastdb -in "${PATH_INPUT}zosterops_augustus_chromosome16_CDS.fasta" -input_type fasta -dbtype nucl -title chr16db -parse_seqids -out "/data/zool-zost/sjoh4959/projects/0.0_island_rule/slurm/evidencemodeler/db/chr16db"
#blastx -query "${PATH_INPUT}zosterops_augustus_chromosome16_CDS.fasta" -db nr -outfmt 5 -max_target_seqs 10 -evalue 1e-4 -out "${PATH_INPUT}zosterops_augustus_chromosome16_CDS.xml"
