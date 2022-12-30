PATH_ANGSD="/home/zoo/sjoh4959/sjoh4959/programs/angsd/angsd"
PATH_GENOME="/data/Users/Andrea/silvereye/wgs_beagle/gwas_input/"
PATH_PHENOTYPES="/home/zoo/sjoh4959/sjoh4959/projects/0.0_island_rule/data/phenotypes/"
PATH_FAI="/data/Users/Andrea/silvereye/ref_genome/wholegenome.fai"
PATH_OUT="/data/Users/Andrea/silvereye/wgs_beagle/gwas_input/"
PATH_COV="/home/zoo/sjoh4959/sjoh4959/projects/0.0_island_rule/analysis/PCAngsd/out/"
N_THREADS=56

#declare -a trait_list=("wing" "tail" "tarsus" "head" "weight" "body_pc1" "body_pc2" "bill_pc1" "bill_pc2")
declare -a trait_list=("bill_length_pos")

for trait in "${trait_list[@]}"
do
	nohup $PATH_ANGSD -doMaf 4 -beagle "${PATH_GENOME}${trait}.beagle.gz" -doAsso 4 -yQuant "${PATH_PHENOTYPES}${trait}.tsv" -out "${PATH_OUT}${trait}_gwas_wholegenome_eigen2" -fai $PATH_FAI -cov "${PATH_COV}${trait}_chr1A_pca_2" -Pvalue 1 &
done
