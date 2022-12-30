#!/bin/bash

#SBATCH --job-name=trinity
#SBATCH --partition=long
#SBATCH --time=500:00:00
#SBATCH --nodes=1
#SBATCH --mem=200G

module purge
#module load HISAT2/2.2.1-gompi-2020b
module load Cufflinks/2.2.1-foss-2020a
module load SAMtools/1.12-GCC-10.2.0
module load BCFtools/1.11-GCC-10.2.0
module load Jellyfish/2.3.0-GCC-8.3.0
module load gompi/2020b
module load Salmon/1.4.0-gompi-2020b
module load Bowtie2/2.4.1-GCC-9.3.0

PATH_TRINITY="/data/zool-zost/sjoh4959/projects/0.0_island_rule/src/others/trinityrnaseq-v2.13.2/"
PATH_REF="/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/"
PATH_INPUT="/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/rna/"
PATH_OUT="/data/zool-zost/sjoh4959/projects/0.0_island_rule/data/rna/trinity_chr/"

#samtools mpileup -Bx -uf "${PATH_REF}ref_genome_chr.fasta.masked" "${PATH_RNA}ZoBo_sort_hisat_chromosome.bam" | bcftools call -c | vcfutils.pl vcf2fq > "${PATH_RNA}ZoBo_transcriptome.fastq"
"${PATH_TRINITY}Trinity" --genome_guided_bam "${PATH_INPUT}ZoBo_sort_hisat_chromosome.bam" --genome_guided_max_intron 100000 --output "${PATH_OUT}" --max_memory 300G --CPU 20 --no_salmon > "${PATH_OUT}trinity_chr.log.out"
