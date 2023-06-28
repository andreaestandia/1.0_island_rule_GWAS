PATH_GFF="/media/sjoh4959/My\ Passport/Andrea/projects/1.0_island_rule_GWAS/reports/annotation/xml/"
PATH_OUT="/media/sjoh4959/My\ Passport/Andrea/projects/1.0_island_rule_GWAS/reports/GWAS/outliers/annotation/"

declare -a trait_list=("wing" "tail" "tarsus" "head" "body_pc1" "body_pc2" "bill_pc1" "bill_pc2") 

for trait in "${trait_list[@]}"
do
	python get_annotation_gff.py "${PATH_GFF}positions4annotation__${trait}.csv" "${PATH_GFF}zosterops_augustus_all.gff" "${PATH_OUT}annotation_${trait}.gff"
	python format_annotation.py "${PATH_OUT}annotation_${trait}.gff" "${PATH_OUT}annotation_${trait}_formatted.gff"
done
