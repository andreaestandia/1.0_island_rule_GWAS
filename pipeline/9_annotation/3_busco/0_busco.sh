PATH_BUSCO="~/sjoh4959/projects/0.0_island_rule/src/others/busco/"
PATH_REF="/data/Users/Andrea/silvereye/ref_genome/"
PATH_OUT="/data/Users/Andrea/silvereye/annotation/aves_busco_database/aves_odb10/"

nohup "${PATH_BUSCO}bin/busco" -i "${PATH_REF}ref_genome_chr.fasta" -l "${PATH_OUT} -m genome --config "${PATH_BUSCO}config/config.ini" -r --cpu 60 &
