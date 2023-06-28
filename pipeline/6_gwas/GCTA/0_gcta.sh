for i in $(seq 30)
do
        tmp=$(echo "chr${i}")
        chromosome_list+=( $tmp )
done

#Add to array those chromosomes with a name that does not follow the pattern above (i.e. chrZ, chr1A...)
chromosome_list+=("chrZ" "chr1A" "chr4A")

for chromosome in "${chromosome_list[@]}"
do
gcta --bfile ../$chromosome --ld-score-region 100 --out $chromosome

Rscript stratify_snps.R "${chromosome}.score.ld"

    for i in {1..4}
    do
        gcta --bfile ../$chromosome --extract "snp_group${i}_${chromosome}.txt" --make-grm --out "snp_group${i}_${chromosome}"
        echo "snp_group${i}_${chromosome}" >> "multi_GRMs_${chromosome}.txt"
    done

gcta --reml --mgrm "multi_GRMs_${chromosome}.txt" --pheno ../pheno --out $chromosome

mkdir $chromosome
mv *$chromosome* $chromosome

done

