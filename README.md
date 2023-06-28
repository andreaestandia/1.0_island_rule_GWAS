# **Standing genetic variation and** ***de novo*** **mutations underlie parallel evolution of island bird phenotypes**

This repository contains the code necessary to reproduce all analyses in the folder `pipeline`

You can see the folder structure below

```bash
|── 1_qc
│   └── 0_qc.sh
├── 2_raw2bam
│   └── 0_snp_calling.sh
├── 3_estimate_genotype_prob
│   └── 0_estimateGLs.sh
├── 4_ld_prunning
│   ├── 0_split_chr.sh
│   ├── 1_get_pos.sh
│   ├── 2_run_ngsLD.sh
│   ├── 3_pruneLD.sh
│   └── 4_concatenate_pruned.sh
├── 5_pop_str
│   ├── 0_pcangsd_wholegenome.sh
│   └── 1_plot_wholegenome_pca.Rmd
├── 6_gwas
│   ├── 0_prep_phenotypes_gwas.Rmd
│   ├── 1_gwas_wholegenome.sh
│   ├── 2_process_gwas_outliers.Rmd
│   ├── 3_get_annotation.sh
│   └── GCTA
│       ├── 0_gcta.sh
│       └── stratify_snps.R
├── 8_local_pca
│   ├── 0_cov_by_window_chr.sh
│   ├── 1_mds.Rmd
│   ├── 2_local_pca_select_clusters.Rmd
│   └── 3_plot_inversions.Rmd
├── 9_annotation
│   ├── 1_transcriptome_assembly
│   │   ├── 0_run_trim_galore.sh
│   │   ├── 1_run_hisat2.sh
│   │   └── 2_assembly_trinity.sh
│   ├── 2_repeatmasker
│   │   └── 0_repeatmasker.sh
│   ├── 3_busco
│   │   ├── 0_busco.sh
│   │   └── config.ini
│   ├── 4_blat
│   │   ├── 0_blat.sh
│   │   └── 1_blat2hints.sh
│   ├── 5_augustus_evidencemodeler
│   │   ├── 0_run_EM.sh
│   │   ├── 1_launch_augustus.sh
│   │   ├── 2_process_augustus_output.sh
│   │   └── 3_split_fasta.sh
│   └── 6_blastx
│       ├── 0_create_job_files.sh
│       └── 1_launch_jobs.sh
├── 10_brms
│   ├── model_inversions.Rmd
│   └── model_phenotypes.Rmd
├── 11_miscellaneous
    └── plot_map_pheno_chart.Rmd

```

Raw data, intermediate files and final output will be uploaded to Figshare and a link will be made available soon.

Much of the code developed to do the local PCA was inspired by Claire Merot's work. Check her pipeline here: https://github.com/clairemerot/angsd_pipeline

Feel free to drop me an email (andrea.estandia@biology.ox.ac.uk) if you have any questions.	
