PATH_BEAGLE=/data/Users/Andrea/silvereye/wgs_beagle/wgs_by_chr/
PATH_PCANGSD=/home/zoo/sjoh4959/sjoh4959/projects/0.0_island_rule/src/others/pcangsd/
PATH_SCRIPT=~/sjoh4959/projects/0.0_island_rule/src/others/
PATH_OUT=/data/Users/Andrea/silvereye/projects_data/0.0_island_rule/analysis/localPCA/unpruned/

N_THREADS=20
window_size=100

for i in $(seq 30)
do
        tmp=$(echo "chr${i}")
        chromosome_list+=( $tmp )
done

#Add to array those chromosomes with a name that does not follow the pattern above (i.e. chrZ, chr1A...)
chromosome_list+=("chrZ" "chr1A" "chr4A")
for chr in "${chromosome_list[@]}"
do

python "${PATH_SCRIPT}beagle_sliding_window.py" "${PATH_BEAGLE}${chr}.beagle.gz" $window_size "${PATH_OUT}${window_size}/beagle_by_window/"

done

#run pcangsd on each window
#this is the input file for the pca
ls -1 "${PATH_OUT}${window_size}/beagle_by_window/window_${chr}"* | 
    sort -u | 
    while read i
    do
       echo "GL for $i"
INPUT="${PATH_OUT}${window_size}/beagle_by_window/${i}"

echo "analyse covariance matrix on all individuals"
python "${PATH_PCANGSD}pcangsd.py" -threads $N_THREADS -beagle $INPUT -o "${PATH_OUT}${window_size}/cov_by_window/${i}"

done

