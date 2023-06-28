PATH_SCRIPT="src/myscripts/"
PATH_GFF="reports/annotation/gff"
PATH_OUT="reports/GWAS/outliers/annotation/"

declare -a trait_list=("wing" "tail" "tarsus" "head" "body_pc1" "body_pc2" "bill_pc1" "bill_pc2") 

for trait in "${trait_list[@]}"
do
	python "${PATH_SCRIPT}get_annotation_gff.py" "${PATH_OUT}positions4annotation__${trait}.csv" "${PATH_GFF}zosterops_augustus_all.gff" "${PATH_OUT}annotation_${trait}.gff"
	python "${PATH_SCRIPT}format_annotation.py" "${PATH_OUT}annotation_${trait}.gff" "${PATH_OUT}annotation_${trait}_formatted.gff"
done
