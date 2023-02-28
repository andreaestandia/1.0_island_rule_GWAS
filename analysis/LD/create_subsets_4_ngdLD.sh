PATH_INPUT="/data/Users/Andrea/silvereye/wgs_beagle/LD/input/"
PATH_GENOME="/data/Users/Andrea/silvereye/wgs_beagle/raw/"
PATH_HEADER="/data/Users/Andrea/silvereye/wgs_beagle/raw/"
declare -a chromosome_list=()
#Populate the array chromosome_list with strings pasted to numbers
for i in $(seq 30)
do
	tmp=$(echo "chr${i}")
	chromosome_list+=( $tmp )
done

#Subset the main file by chromosome and zip
for chromosome in "${chromosome_list[@]}"
do
        nohup cat "${PATH_GENOME}wholegenome.beagle" | grep "${chromosome}_" > "${PATH_INPUT}${chromosome}" &
done

#Add header to file
for chromosome in "${chromosome_list[@]}"
do
	nohup cat "${PATH_GENOME}header" "${PATH_INPUT}${chromosome}" | gzip > "${PATH_INPUT}${chromosome}.gz" &
done
