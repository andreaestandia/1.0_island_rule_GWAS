##NEED TO EDIT
export AUGUSTUS_CONFIG_PATH="/data/zool-zost/sjoh4959/projects/0.0_island_rule/src/others/Augustus/config/"
#
augustus --strand=both --singlestrand=true \
--hintsfile=/zosterops_hints_RM_E.gff3 \
--extrinsicCfgFile=extrinsic.M.RM.E.cfg \
--alternatives-from-evidence=true \
--gff3=on \
--uniqueGeneId=true \
--softmasking=1 \
--species=BUSCO_Zlat_busco_augustus_aves \
${1}/Dhydei_genome.fa.masked > ../output/Dhydei_augustus_${1}.gff
#
echo = `date` job $JOB_NAME done
#
