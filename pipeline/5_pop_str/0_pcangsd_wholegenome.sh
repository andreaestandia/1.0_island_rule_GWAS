PATH_PCANGSD="/home/zoo/sjoh4959/sjoh4959/projects/0.0_island_rule/src/others/pcangsd/"
PATH_BEAGLE="/data/Users/Andrea/silvereye/wgs_beagle/gwas_input/"
PATH_OUT="/home/zoo/sjoh4959/sjoh4959/projects/0.0_island_rule/analysis/PCAngsd/out/"
N_THREADS=56

declare -a trait_list=("wing" "tail" "tarsus" "head" "body_pc1" "body_pc2" "bill_pc1" "bill_pc2" "bill_length" "bill_depth" "bill_width")

for trait in "${trait_list[@]}"
do
       
nohup python "${PATH_PCANGSD}pcangsd.py" -beagle "${PATH_BEAGLE}${trait}.beagle.gz" -out "${PATH_OUT}${trait}_control" -threads $N_THREADS &
done
