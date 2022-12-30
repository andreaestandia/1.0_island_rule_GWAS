PATH_PCANGSD="/home/zoo/sjoh4959/sjoh4959/projects/0.0_island_rule/src/others/pcangsd/"
PATH_BEAGLE="/data/Users/Andrea/silvereye/wgs_beagle/gwas_input/"
PATH_OUT="/home/zoo/sjoh4959/sjoh4959/projects/0.0_island_rule/analysis/PCAngsd/out/"
N_THREADS=56
#declare -a trait_list=("wing" "tail" "tarsus" "head" "weight" "body_pc1" "body_pc2" "bill_pc1" "bill_pc2" "wing_weight" "tarsus_weight")
declare -a trait_list=("bill_width_pos_chr1A")

for trait in "${trait_list[@]}"
do
       
nohup python "${PATH_PCANGSD}pcangsd.py" -beagle "${PATH_BEAGLE}${trait}.beagle.gz" -admix -dosage_save -out "${PATH_OUT}${trait}_pca_out" -threads $N_THREADS &
done
