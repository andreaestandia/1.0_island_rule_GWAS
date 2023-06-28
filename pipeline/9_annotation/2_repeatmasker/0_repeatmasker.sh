PATH_RM="~/sjoh4959/projects/0.0_island_rule/src/others/RepeatMasker/"
PATH_REF="/data/Users/Andrea/silvereye/ref_genome/"
PATH_OUT="/data/Users/Andrea/silvereye/annotation/repeatmasker/"

nohup "${PATH_RM}RepeatMasker" "${PATH_REF}ref_genome_chr.fasta" -species chicken -gff -u -html -dir "${PATH_OUT} -xsmall &
