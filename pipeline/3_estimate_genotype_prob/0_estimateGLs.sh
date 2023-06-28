#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=350G
#SBATCH --time=3-00:00:00 
#SBATCH --array=3-3:1
#SBATCH --job-name=ANGSD_GLs
#SBATCH --partition=long
#SBATCH --output=ANGSD_GLs_350GB_%A_%a.log
#SBATCH --error=ANGSD_GLs_350GB_%A_%a.error

#########################################################################################################
# CONDUCT GENOTYPE LIKELIHOOD ESTIMATION WITH ANGSD v.0.925
#########################################################################################################

#Load angsd module
ml angsd/0.925-foss-2018b

# Set path to reference assembly and list of bam files (bam.list)
# Note: bam files need to be indexed (using samtools index) 
REF=/data/zool-zost/Ref_Genome/Ref_Genome_PseudoChroms/Zlat_2_Tgut_pseudochromosomes.shortChromNames.fasta.gz
BAMs=bam.list

# Use slurm array task ID to get long chromosome name
CHROM=$(cat chrom.list | head -n $SLURM_ARRAY_TASK_ID | tail -n 1)

# Estimate genotype likelihoods and output SNPs using ANGSD
angsd -b $BAMs -ref $REF \
-uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -baq 1 -minMapQ 20 -minQ 20 \
-GL 1 -doMajorMinor 1 -doMaf 1 -doPost 2 -doGlf 2 \
-minMaf 0.05 -SNP_pval 1e-6 -skipTriallelic \
-r $CHROM -out ${CHROM}
