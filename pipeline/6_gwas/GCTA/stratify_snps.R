args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]

lds_seg <- read.table(input_file, header = TRUE, colClasses = c("character", rep("numeric", 8)))
quartiles <- summary(lds_seg$ldscore_SNP)

lb1 <- which(lds_seg$ldscore_SNP <= quartiles[2])
lb2 <- which(lds_seg$ldscore_SNP > quartiles[2] & lds_seg$ldscore_SNP <= quartiles[3])
lb3 <- which(lds_seg$ldscore_SNP > quartiles[3] & lds_seg$ldscore_SNP <= quartiles[5])
lb4 <- which(lds_seg$ldscore_SNP > quartiles[5])

lb1_snp <- lds_seg$SNP[lb1]
lb2_snp <- lds_seg$SNP[lb2]
lb3_snp <- lds_seg$SNP[lb3]
lb4_snp <- lds_seg$SNP[lb4]

write.table(lb1_snp, paste0("snp_group1_", gsub(".score.ld", "", input_file), ".txt"), row.names = FALSE, quote = FALSE, col.names = FALSE)
write.table(lb2_snp, paste0("snp_group2_", gsub(".score.ld", "", input_file), ".txt"), row.names = FALSE, quote = FALSE, col.names = FALSE)
write.table(lb3_snp, paste0("snp_group3_", gsub(".score.ld", "", input_file), ".txt"), row.names = FALSE, quote = FALSE, col.names = FALSE)
write.table(lb4_snp, paste0("snp_group4_", gsub(".score.ld", "", input_file), ".txt"), row.names = FALSE, quote = FALSE, col.names = FALSE)

