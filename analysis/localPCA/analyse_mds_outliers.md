```bash
CHOSEN_FILE="/data/Users/Andrea/silvereye/projects_data/0.0_island_rule/analysis/localPCA/outlier_mds/cluster_outlier_allMDS_max4_merge20_filter4_sdLim4.pos"


num_pca=$(wc -l "$CHOSEN_FILE" | cut -d " " -f 1)

path_beagle_all="/data/Users/Andrea/silvereye/wgs_beagle/raw/"
path_beagle_subset="/data/Users/Andrea/silvereye/projects_data/0.0_island_rule/analysis/localPCA/outlier_mds/"
PATH_PCANGSD="/home/zoo/sjoh4959/sjoh4959/projects/0.0_island_rule/src/others/pcangsd/"


for i in $(seq $num_pca)
	do
	start=$(cat "$CHOSEN_FILE" | head -"$i" | tail -1 | cut -f 1)
	stop=$(cat "$CHOSEN_FILE" | head -"$i" | tail -1 | cut -f 2)

	echo "splitting beagle $start $stop"
	#Search from start to stop with awk including both lines. Note that start and stop are declared variables so we need to declare the pattern with -v pat="$start" and -v pat2="$stop" and then call it within awk as $0 ~ pat or $0 ~ pat2
	awk -v pat="$start" -v pat2="$stop" '$0 ~ pat{flag=1} $0 ~ pat2{flag=0} flag' ${path_beagle_all}/wholegenome_pruned.beagle > tmp
	
	cat "${path_beagle_all}/header" tmp > "${path_beagle_subset}${start}-${stop}.beagle" 
	gzip "${path_beagle_subset}${start}-${stop}.beagle"

	echo "pcangsd"
	python "${PATH_PCANGSD}pcangsd.py" -threads 20 -beagle "${path_beagle_subset}${start}-${stop}.beagle.gz" -o "${path_beagle_subset}${start}-${stop}"
	
done

```

