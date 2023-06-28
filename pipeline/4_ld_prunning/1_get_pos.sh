#!/bin/bash

#SBATCH --nodes=1
#SBATCH --job-name=get_pos
#SBATCH --partition=medium

cd /data/zool-zost/sjoh4959/projects/0.0_island_rule/data/LD/input/

for i in *gz
do 
	zcat $i | cut -f1 | tr '_' '\t' > "${i}_pos"
done
