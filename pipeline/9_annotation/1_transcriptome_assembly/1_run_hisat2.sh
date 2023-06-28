#!/bin/bash

#SBATCH --job-name=trimgalore
#SBATCH --partition=long
#SBATCH --time=500:00:00
#SBATCH --nodes=1
#SBATCH --mem=340000

module purge
module load HISAT2/2.2.1-gompi-2020b
module load Cufflinks/2.2.1-foss-2020a
module load SAMtools/1.12-GCC-10.2.0

PATH_REF="/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/"
PATH_OUT="/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/rna/hisat2/"
PATH_READS="/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/rna/trim_galore/output/"
PATH_RNA="/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/rna/"

hisat2-build "${PATH_REF}ref_genome_chr.fasta.masked" "${PATH_OUT}ZoBo_chromosome.idx"

hisat2 -k 2 --no-unal --threads 48 --phred33 --dta-cufflinks -x "${PATH_OUT}ZoBo_chromosome.idx" -1 "${PATH_READS}SRR8887131_RNAseq_Illumina_HiSeq_2500_paired_end_sequencing_1_trimmed.fq.gz" -2 "${PATH_READS}SRR8887131_RNAseq_Illumina_HiSeq_2500_paired_end_sequencing_2_trimmed.fq.gz" -S "${PATH_OUT}ZoBo_hisat_chromosome.sam"

# convert to bam and sort
samtools view -b "${PATH_OUT}ZoBo_hisat_chromosome.sam" > "${PATH_RNA}ZoBo_hisat_chromosome.bam"
samtools sort -@ 20 -o "${PATH_RNA}ZoBo_sort_hisat_chromosome.bam" "${PATH_RNA}ZoBo_hisat_chromosome.bam"
