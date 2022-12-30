outlier <-
  read.table("/home/zoo/sjoh4959/outlier_chr2", header = FALSE, sep="\t") %>%
  rename(sample_name = V1) %>%
  rename(genotype = V2)
pheno <-
  read_tsv("/media/sjoh4959/My Passport1/Andrea/projects/1.0_island_rule_GWAS/data/wgs/lists/body_PC1.tsv",
           col_names = FALSE) %>%
  rename(sample_name = X1) %>%
  rename(tarsus = X2) 

pop_info <- read_csv("/media/sjoh4959/My Passport1/Andrea/projects/1.0_island_rule_GWAS/data/phenotypes/phenotypes+SMC2+AE.csv") %>% 
  rename(x=sample_name) %>% 
  rename(sample_name=id) %>% 
  select(sample_name, pop, region)

df <- outlier %>% 
  left_join(pop_info, by = "sample_name") %>% 
  left_join(pheno, by = "sample_name")

geno <-
  rep(c("AA", "AB", "BB"),
      times = length(df$sample_name) / 3,
      lenght.out = 1)

df <- cbind(df, geno)

df2 <- df %>% group_by(sample_name) %>% top_n(1, genotype)

data_summary <- function(x) {
  m <- mean(x)
  ymin <- m - sd(x)
  ymax <- m + sd(x)
  return(c(y = m, ymin = ymin, ymax = ymax))
}

df2 %>%
  drop_na(tarsus) %>%
  filter(genotype>0.34) %>% 
  ggplot(aes(y = tarsus, x = geno, col = geno)) +
  geom_violin(trim = FALSE) +
  stat_summary(aes(y = tarsus),
               fun.data = data_summary,
               geom = "pointrange",
               shape = 1) +
  geom_jitter(width = 0.05,
              height = 0.05,
              alpha = 0.8,
              size=2) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(hjust=1, size=text_size, family = "ubuntu"),
    axis.text.y = element_text(size = text_size, family="ubuntu"),
    axis.title = element_text(size = text_size, family="ubuntu"),
    legend.title = element_text(family="ubuntu"),
    legend.position = "none",
        panel.grid.major = element_blank()) +
  scale_color_manual(values = c("#21577dff", "#99bac2ff", "#428f99ff")) +
  labs(title = "Chromosome 2 / 69159431\n",
       y = "Body size (PC1)\n", x = "\nGenotype", family="ubuntu")

