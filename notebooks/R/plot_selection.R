```R
library("RcppCNPy")
library("ggplot2")
library("tidyverse")
selection <- npyLoad("wholegenome_pca_selection.selection.npy")
pvals.pc1 <- pchisq(selection[,1], 1, lower.tail=F)
pvals.pc2 <- pchisq(selection[,2], 1, lower.tail=F)
pvals.pc3 <- pchisq(selection[,3], 1, lower.tail=F)

pvals <- as.data.frame(cbind(pvals.pc1, pvals.pc2, pvals.pc3))

pos<-read.table("/data/Users/Andrea/silvereye/wgs_beagle/raw/pos",colC=c("factor","integer"),sep="_")

names(pos)<-c("chr","pos")
df <- cbind(pos, pvals)
#df <- df %>% rename("pvalue"="2")

order_chr <- as.character(seq(from = 5, to = 30))
reference = c(c("1", "1A", "2", "3", "4", "4A"), order_chr, "Z")
ref = factor(as.factor(reference), levels = c(c("1", "1A", "2", "3", "4", "4A"), order_chr, "Z"))
df <- df[order(factor(as.factor(df$chr), levels = ref)),]
df$n <- 1:nrow(df)

axisdf <-
  df %>% group_by(chr) %>% summarize(center = (max(n) + min(n)) / 2)

bonf = -log10(0.001 / nrow(df))

png(
  file = "scan_selection_p3.png",
  height = 12, width = 75, units="cm",res = 300
)

scan_selection <-
  df %>%
  #filter(chr=="chr1A")%>%
  #slice(which(row_number() %% 50 == 1)) %>%
  ggplot(aes(
    x = n,
    y = -log10(pvals.pc3),
    color = chr
  )) +
# Show all points
geom_point(size=2.5) +
scale_color_manual(values = rep(c("#2b2b2b","#858585"), 17)) +
scale_x_continuous(
    label = axisdf$chr,
    breaks = axisdf$center,
    expand = c(0.01, 0.01)
  ) +
  geom_hline(
    yintercept = bonf,
    linetype = "dashed",
    colour = "grey37"
  ) +
# custom X axis: -->
  # scale_y_continuous(limits = c(0,0.31), expand = c(0.01, 0.01) ) +     # remove space between plot area and x axis -->
  labs(x = "Chromosome") +
    theme_classic() +
    theme(
      legend.position = "none", 
      panel.border = element_blank()
    )
  
print(scan_selection)
dev.off()
```



