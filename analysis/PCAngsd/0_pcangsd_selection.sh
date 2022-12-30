PATH_PCANGSD="/home/zoo/sjoh4959/sjoh4959/projects/0.0_island_rule/src/others/pcangsd/"
PATH_BEAGLE="/data/Users/Andrea/silvereye/wgs_beagle/raw/"
PATH_OUT="/home/zoo/sjoh4959/sjoh4959/projects/0.0_island_rule/analysis/PCAngsd/out/"
N_THREADS=56

declare -a trait_list=("wholegenome_pruned.beagle.gz")

for trait in "${trait_list[@]}"
do

nohup python "${PATH_PCANGSD}pcangsd.py" -beagle "${PATH_BEAGLE}${trait}" -selection -out "${PATH_OUT}${trait}_pca_out" -threads $N_THREADS &
done
