setwd("/home/zoo/sjoh4959/sjoh4959/projects/0.0_island_rule")
source("./src/0.0_island_rule_source.R")
mart = useEnsembl('ENSEMBL_MART_ENSEMBL')
#listDatasets(mart)

#Get zebrafinch gene list from ensembl biomarts
ensembl <-
  useEnsembl(biomart = "ensembl", dataset = "tguttata_gene_ensembl",
                  host="uswest.ensembl.org")

library(data.table)

LRTs <-
fread("/home/zoo/sjoh4959/sjoh4959/projects/0.0_island_rule/analysis/GWAS_angsd/output/bill_pc1_gwas_wholegenome.lrt0.gz",
header = T,
sep = "\t",
stringsAsFactors = F) %>%
filter(as.numeric(P) > 0) %>%
  #filter(-log10(P)<=15.5)%>%
    mutate(Chromosome = str_replace(Chromosome, "chr", ""))


#LRT <- LRTs %>% filter(Chromosome=="1A")

order_chr <- as.character(seq(from = 5, to = 30))
reference = c(c("1", "1A", "2", "3", "4", "4A"), order_chr, "Z")
ref = factor(as.factor(reference), levels = c(c("1", "1A", "2", "3", "4", "4A"), order_chr, "Z"))
LRTs <- LRTs[order(factor(as.factor(LRTs$Chromosome), levels = ref)),]
LRTs$n <- 1:nrow(LRTs)

t <- 0.001
outlier_SNPs <- LRTs[LRTs$P < quantile(LRTs$P, prob = 0.0001),]
outlier_SNPs

outlier_SNPs$gene_id <- NA
outlier_SNPs$gene_name <- NA
for (ROW in 1:nrow(outlier_SNPs)) {
  print(paste0("Processing SNP ", ROW))
  Genes_within_range <-
      getBM(
        attributes = c(
          'ensembl_gene_id',
          'external_gene_name',
          'chromosome_name',
          'start_position',
          'end_position',
          'gene_biotype'
        ),
        mart = ensembl,
        useCache = FALSE,
        filter = c('chromosome_name', 'start', 'end'),
        values = list(
          outlier_SNPs$Chromosome[ROW],
          outlier_SNPs$Position[ROW],
          outlier_SNPs$Position[ROW]
        )
      )
  if (nrow(Genes_within_range) > 0) {
    Unique_protein_coding <-
        Genes_within_range %>%
        filter(gene_biotype == "protein_coding") %>%
        dplyr::select(external_gene_name, ensembl_gene_id) %>%
        unique()

    if (nrow(Unique_protein_coding) > 0) {
      outlier_SNPs$gene_id[ROW] <- Unique_protein_coding$ensembl_gene_id
      outlier_SNPs$gene_name[ROW] <-
          Unique_protein_coding$external_gene_name
    }
  }
}

max_distance_between_outliers = 25000
min_clustered_outliers = 2

clustered_outlier_SNPs <-
  tibble(
    Chromosome = character(),
    Position = numeric(),
    Major = character(),
    Minor = character(),
    Frequency = numeric(),
    N = integer(),
    P = numeric(),
    high_WT.HE.HO = character(),
    n = integer()
  )

#For each chromosome find outlier clusters if any.
for (CHROM in unique(LRTs$Chromosome)) {
  CHROM_outlier_SNPs <- filter(outlier_SNPs, Chromosome == CHROM)

  current_windows <- CHROM_outlier_SNPs %>%
    mutate(
      ahead_Position = Position - lag(Position),
      behind_Position = abs(Position - lead(Position))
    ) %>%
    mutate(min_dist = pmin(ahead_Position, behind_Position, na.rm = T)) %>%
    filter(min_dist < max_distance_between_outliers) %>%
    dplyr::select(-ahead_Position, - behind_Position, - min_dist)
  windows <- current_windows %>% pull(n)

  if (nrow(current_windows) > 2) {
    clustered_outlier_SNPs <-
      rbind(clustered_outlier_SNPs, current_windows, fill = T)
  }

  rm(CHROM_outlier_SNPs, current_windows)
}


clustered_outlier_SNPs$GeneID_Gene_Name <-
  paste0(clustered_outlier_SNPs$gene_id,
         ": ",
         clustered_outlier_SNPs$gene_name)
gene_names <- clustered_outlier_SNPs %>%
dplyr::select(Position, gene_name)

LRTs <- LRTs %>% left_join(gene_names, by = "Position")
gene_names <- clustered_outlier_SNPs %>%
dplyr::select(n, gene_name, P)

axisdf <-
  LRTs %>% group_by(Chromosome) %>% summarize(center = (max(n) + min(n)) / 2)
LRTs %>%
  mutate(log_10 = -log10(P)) %>%
  filter(log_10 != "Inf") %>%
ggplot(aes(
    x = n,
    y = log_10,
    color = as.factor(Chromosome)
  )) +


# Show all points
geom_point(size = 0.75) +
  scale_color_manual(values = rep(c("#242565", "#46557E"), 26)) +  scale_x_continuous(
    label = axisdf$Chromosome,
    breaks = axisdf$center,
    expand = c(0.01, 0.01)
  ) +
  labs(x = "Chromosome") +
  theme_classic() +
  theme(legend.position = "none", panel.border = element_blank())

  pick <- function(condition){
  function(d) d %>% filter_(condition)
}
magma_pal <- c(viridis::magma(n = length(unique(LRTs$Chromosome))))

magma_pal1 <- magma_pal[c(1:24)]
magma_pal2 <- magma_pal[c(1,3,5,7,9,15,17,19, 21)]
magma_pal <- c(magma_pal1, magma_pal2)
png(
  file = file.path(figures_path, "bill_pc2_GWAS_pruned.png"),
  height = 25, width = 50, units="cm",res = 300
)
pdf(
  file = file.path(figures_path, "bill_pc2_GWAS_pruned.pdf"),
  height = 2.5, 
  width = 8, 
  dpi = 100
)

pdf(
  file = file.path(figures_path, "chr15.pdf"),
  height = 4, 
  width = 8
)

pdf(
  file = file.path(figures_path, "bill_pc2_GWAS.pdf"),
  height = 5, width = 16
)

tiff("body_pc1_GWAS.tiff",
  width = 8, 
  height = 2.5, 
  units = "in", 
  res = 100
)


chr15 <- 
LRTs %>%
  #filter(P < 0.0001) %>%
  #filter(P>1.1102e-16) %>%
  #filter(Chromosome == 15) %>%
  ggplot(aes(
    x = n,
    y = -log10(P),
    color = Chromosome
  )) +
# Show all points
geom_point(size=1.5)+
scale_color_manual(values="black")+
scale_x_continuous(
    label = axisdf$Chromosome,
    breaks = axisdf$center,
    expand = c(0.01, 0.01)
  ) +
  # scale_y_continuous(limits = c(0,0.31), expand = c(0.01, 0.01) ) +     # remove space between plot area and x axis -->
  labs(x = "Chromosome") +
    theme_classic() +
    theme(
      legend.position = "none", panel.border = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks = element_blank()
    )+labs(x="", y="")
print(chr15)
dev.off()

bonf = -log10(0.001 / nrow(LRTs))

WholeGenome_bill <-
  LRTs %>%
  #filter(P < 0.1) %>%
  #filter(-log10(P)<15.8) %>%
  #slice(which(row_number() %% 25 == 1))%>%
  #filter(Chromosome!=1)%>%
  ggplot(aes(
    x = n,
    y = -log10(P),
    color = Chromosome
  )) +
# Show all points
geom_point(size=2.5) +
#geom_label_repel(data= LRTs %>% 
#filter(gene_name != "NA") %>%
#  filter(-log10(P) > 13) %>%
#  group_by(gene_name) %>%
#  arrange(P)%>%
#distinct(gene_name,.keep_all=T),
#aes(label=gene_name,
#min.segment.length = 0,max.overlaps=Inf))+
  scale_color_manual(values = rep(c("#6B3360","#D3625D"), 26 )) +
  geom_hline(
    yintercept = bonf,
    linetype = "dashed",
    colour = "grey37"
  ) +
  geom_point(data = clustered_outlier_SNPs, size=2.5) +

# custom X axis: -->
scale_x_continuous(
    label = axisdf$Chromosome,
    breaks = axisdf$center,
    expand = c(0.01, 0.01)
  ) +
  # scale_y_continuous(limits = c(0,0.31), expand = c(0.01, 0.01) ) +     # remove space between plot area and x axis -->
  labs(x = "Chromosome") +
    theme_classic() +
    theme(
      legend.position = "none", 
      panel.border = element_blank()
    )
  
print(WholeGenome_bill)
dev.off()

df_nrow=nrow(LRTs)
exp.pval=(1:df_nrow-0.5)/df_nrow
exp.pval.log=as.data.frame(-log10(exp.pval))
var.pval=LRTs$P[order(LRTs$P)]
var.pval.log=as.data.frame(-log10(var.pval))
N=df_nrow
cupper=-log10(qbeta(0.95,1:N,N-1:N+1))
clower=-log10(qbeta(1-0.95,1:N,N-1:N+1))
df2=cbind(exp.pval.log,var.pval.log,cupper,clower)
colnames(df2)=c("expected","var","cup","clow")
g2 = ggplot(df2) +
  geom_point_rast(aes(x = expected, y = var),
    colour = "black", size = 0.5
  ) +
  geom_abline(slope = 1, intercept = 0, colour = "grey") +
  geom_line(aes(expected, cup), linetype = 2) +
  geom_line(aes(expected, clow), linetype = 2) +
  theme_bw() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  xlab(expression(paste(-log[10], "(expected ", italic(P), " value)"))) +
  ylab(expression(paste(-log[10], "(observed ", italic(P), " value)"))) +
  theme_classic()


pdf(
  file = file.path(figures_path, "body_pc1_GWAS_qq.pdf"),
  height = 5, width = 20
)
both_figs <- 
WholeGenome_bill + 
g2 + 
plot_layout(widths = c(2, 1)) +
  plot_annotation(tag_levels = "a") & theme(plot.tag = element_text(size = 18))
print(both_figs)
dev.off()

write.csv(outlier_SNPs, "/home/zoo/sjoh4959/sjoh4959/projects/0.0_island_rule/reports/outlier_bill_pc1.csv", row.names=F)

outlier_SNPs <-
  read.csv("/home/zoo/sjoh4959/sjoh4959/projects/0.0_island_rule/reports/outlier_bill_PC1.csv", stringsAsFactors = F)

outlier_SNPs %>%
  summarise(non_na_count = sum(!is.na(gene_name)),
            na_count = sum(is.na(gene_name)))
#  non_na_count na_count
#          388      411


test <- LRTs %>%
        dplyr::select(Position, n)

#Sometimes with dplyr::select(-n) sometimes without 
outlier_SNPs <-
  outlier_SNPs %>%
  dplyr::select(-n) %>%
  left_join(test, by = "Position")