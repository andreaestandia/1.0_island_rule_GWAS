#!/bin/sh

#SBATCH --nodes=1
#SBATCH --mem=64000
#SBATCH --time=900:00:00
#SBATCH --job-name=submit.log
#SBATCH --partition=long
#SBATCH --output=submit.log

PATH_JOB_FILE="/data/zool-zost/sjoh4959/projects/0.0_island_rule/slurm/blastx/job_files/"

for job_file in "${PATH_JOB_FILE}"*job
do
	sbatch $job_file
	sleep 3m
done
