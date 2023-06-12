# argv <- commandArgs(T)
# INPUT_FOLDER <- argv[1]
# max_MDS<- as.numeric(argv[2])#nb of mds on whcih to work
# sd_lim<- as.numeric(argv[3])#limit for being outlier
# x_between<- as.numeric(argv[4]) #merge window with this number of windows between them
# min_n_window<- as.numeric(argv[5]) #remove cluster with less than this number of window

max_MDS <- 2#nb of mds on whcih to work
sd_lim <- 4#limit for being outlier
x_between <-
  10 #merge window with this number of windows between them
min_n_window <- 5#remove cluster with less than this number of window

#read msd scores
mds_scores <-
  read.csv(file.path(reports_path,
                       "localPCA/unpruned/big_data/bigdata.csv"),
             header = T) 

MDS_CLUSTER_ALL <- matrix(ncol = 10)
colnames(MDS_CLUSTER_ALL) <-
  c(
    "LG",
    "start",
    "stop",
    "x",
    "window_start",
    "window_stop",
    "n_windows",
    "mds",
    "mds_num",
    "cluster"
  )

order_chr <- as.character(seq(from = 5, to = 30))
reference = c(c("1", "1A", "2", "3", "4", "4A"), order_chr, "Z")
ref = factor(as.factor(reference), levels = c(c("1", "1A", "2", "3", "4", "4A"), order_chr, "Z"))
mds_scores <- mds_scores[order(factor(as.factor(mds_scores$LG), levels = ref)),]
mds_scores$n <- 1:nrow(mds_scores)

axisdf <-
  mds_scores %>%
  group_by(LG) %>%
  summarize(center = (max(n) + min(n)) / 2)

for (j in 1:max_MDS)
{
  #on which mds do we work?
  print(paste("working on mds", j))
  mds_col <- 6 + j
  mds_vector <- mds_scores[, mds_col]
  
  #calculate limit
  mds_mean <- mean(mds_vector)
  mds_sd <- sd(mds_vector)
  #plot
  plot_mds <- mds_scores %>%
    ggplot(aes(x = n, y = mds_vector, color = LG)) +
    geom_point() +
    scale_x_continuous(
      label = axisdf$LG,
      breaks = axisdf$center,
      expand = c(0.01, 0.01)
    ) +
    #scale_color_manual(values = rep(c("#8fc7c0", "#2a9d8f"), blue
    scale_color_manual(values = rep(c("#eddd9a", "#d19f28"),
                                    length(unique(mds_scores$LG)))) +
    labs(x = "\nChromosome", title = paste0("MDS", j)) +
    geom_hline(yintercept = mds_mean + sd_lim * mds_sd, linetype = "dashed") +
    geom_hline(yintercept = mds_mean - sd_lim * mds_sd, linetype = "dashed") +
    theme_classic() +
    theme(
      text = element_text(size = 12),
      legend.position = "none",
      panel.border = element_blank()
    )
  
  ggsave(
    plot = plot_mds,
    filename = paste0(
      reports_path,
      "/localPCA/unpruned/outliers/",
      j,
      "_all_LG_window100_sd_lim",
      sd_lim,
      "min_n_window_",
      min_n_window,
      ".png"
    ),
    height = 8, 
    width = 27, 
    units="cm"
  )
  

  
    #keep outliers on the positive side
  mds_outliers <-
    mds_scores[mds_vector >= (mds_mean + sd_lim * mds_sd), c(2, 5, 6, mds_col)]
  mds_outliers$window <- as.numeric(row.names(mds_outliers))
  mds_outliers
  
  #make outliers into clusters
  if (dim(mds_outliers)[1] > 0)
  {
    #initialisation
    c = 1
    mds_outliers_cluster <- mds_outliers[1, ]
    colnames(mds_outliers_cluster) <-
      c("LG", "start", "stop", "x", "window_start")
    mds_outliers_cluster$window_stop <- mds_outliers$window[1]
    mds_outliers_cluster$n_windows <- 1
    mds_outliers_cluster$mds <- paste0("positive", j)
    mds_outliers_cluster$mds_num <- j
    mds_outliers_cluster$cluster <- c
    
    head(mds_outliers_cluster)
    
    for (i in 2:dim(mds_outliers)[1])
    {
      #if the next outlier window is adjacent, replace the stop value
      if (mds_outliers$window[i] <= mds_outliers$window[i - 1] + 1 + x_between)
      {
        mds_outliers_cluster$window_stop[c] <- mds_outliers$window[i]
        mds_outliers_cluster$stop[c] <- mds_outliers$stop[i]
        mds_outliers_cluster$n_windows[c] <-
          mds_outliers_cluster$n_windows[c] + 1
      }
      if (mds_outliers$window[i] > mds_outliers$window[i - 1] + 1 + x_between)
      {
        c = mds_outliers_cluster$cluster[c] + 1
        mds_new_cluster <- mds_outliers[i, ]
        colnames(mds_new_cluster) <-
          c("LG", "start", "stop", "x", "window_start")
        mds_new_cluster$window_stop <- mds_outliers$window[i]
        mds_new_cluster$n_windows <- 1
        mds_new_cluster$mds <- paste0("positive", j)
        mds_new_cluster$mds_num <- j
        mds_new_cluster$cluster <- c
        mds_outliers_cluster <-
          rbind(mds_outliers_cluster, mds_new_cluster)
      }
    }
    mds_outliers_cluster <-
      mds_outliers_cluster[which(is.na(mds_outliers_cluster$n_windows) == F), ]
    mds_outliers_cluster_FILTER <-
      mds_outliers_cluster[mds_outliers_cluster$n_windows >= min_n_window, ]
    
    
    #write a simplified file with just the position to do pca on each cluster of outlier
    mds_outliers_cluster_FILTER_POS <-
      cbind(
        paste(
          mds_outliers_cluster_FILTER$LG,
          mds_outliers_cluster_FILTER$start,
          sep = "_"
        ),
        paste(
          mds_outliers_cluster_FILTER$LG,
          mds_outliers_cluster_FILTER$stop,
          sep = "_"
        )
      )
    
    colnames(mds_outliers_cluster_FILTER_POS) <-
      c("CHR_start", "CHR_stop")
    write.table(
      mds_outliers_cluster_FILTER_POS,
      paste0(
        reports_path,
        "/localPCA/unpruned/outliers/mds_pos",
        j,
        "_merge",
        x_between,
        "_filter",
        min_n_window,
        "_sdLim",
        sd_lim,
        ".pos"
      ),
      row.names = F,
      col.names = F,
      quote = F,
      sep = "\t"
    )
  } else{
    mds_outliers_cluster <- matrix(ncol = 10)
    colnames(mds_outliers_cluster) <-
      c(
        "LG",
        "start",
        "stop",
        "x",
        "window_start",
        "window_stop",
        "n_windows",
        "mds",
        "mds_num",
        "cluster"
      )
  }
  #save in the biggest matrix
  MDS_CLUSTER_ALL <- rbind(MDS_CLUSTER_ALL, mds_outliers_cluster)
  
  #keep outliers on the negative side
  mds_outliers <-
    mds_scores[mds_vector <= (mds_mean - sd_lim * mds_sd), c(2, 5, 6, mds_col)]
  mds_outliers$window <- as.numeric(row.names(mds_outliers))
  mds_outliers
  
  #make outliers into clusters
  if (dim(mds_outliers)[1] > 0)
  {
    #initialisation
    c = 1
    mds_outliers_cluster <- mds_outliers[1, ]
    colnames(mds_outliers_cluster) <-
      c("LG", "start", "stop", "x", "window_start")
    mds_outliers_cluster$window_stop <- mds_outliers$window[1]
    mds_outliers_cluster$n_windows <- 1
    mds_outliers_cluster$mds <- paste0("negative", j)
    mds_outliers_cluster$mds_num <- -j
    mds_outliers_cluster$cluster <- c
    
    head(mds_outliers_cluster)
    
    for (i in 2:dim(mds_outliers)[1])
    {
      #if the next outlier window is adjacent, replace the stop value
      if (mds_outliers$window[i] <= mds_outliers$window[i - 1] + 1 + x_between)
      {
        mds_outliers_cluster$window_stop[c] <- mds_outliers$window[i]
        mds_outliers_cluster$stop[c] <- mds_outliers$stop[i]
        mds_outliers_cluster$n_windows[c] <-
          mds_outliers_cluster$n_windows[c] + 1
      }
      if (mds_outliers$window[i] > mds_outliers$window[i - 1] + 1 + x_between)
      {
        c = mds_outliers_cluster$cluster[c] + 1
        mds_new_cluster <- mds_outliers[i, ]
        colnames(mds_new_cluster) <-
          c("LG", "start", "stop", "x", "window_start")
        mds_new_cluster$window_stop <- mds_outliers$window[i]
        mds_new_cluster$n_windows <- 1
        mds_new_cluster$mds <- paste0("negative", j)
        mds_new_cluster$mds_num <- -j
        mds_new_cluster$cluster <- c
        mds_outliers_cluster <-
          rbind(mds_outliers_cluster, mds_new_cluster)
      }
    }
    mds_outliers_cluster <-
      mds_outliers_cluster[which(is.na(mds_outliers_cluster$n_windows) == F), ]
    mds_outliers_cluster_FILTER <-
      mds_outliers_cluster[mds_outliers_cluster$n_windows >= min_n_window, ]
    
    
    #write a simplified file with just the position to do pca on each cluster of outlier
    mds_outliers_cluster_FILTER_POS <-
      cbind(
        paste(
          mds_outliers_cluster_FILTER$LG,
          mds_outliers_cluster_FILTER$start,
          sep = "_"
        ),
        paste(
          mds_outliers_cluster_FILTER$LG,
          mds_outliers_cluster_FILTER$stop,
          sep = "_"
        )
      )
    
    colnames(mds_outliers_cluster_FILTER_POS) <-
      c("CHR_start", "CHR_stop")
    write.table(
      mds_outliers_cluster_FILTER_POS,
      paste0(
        reports_path,
        "/localPCA/unpruned/outliers/mds_neg",
        j,
        "_merge",
        x_between,
        "_filter",
        min_n_window,
        "_sdLim",
        sd_lim,
        ".pos"
      ),
      row.names = F,
      col.names = F,
      quote = F,
      sep = "\t"
    )
  } else{
    mds_outliers_cluster <- matrix(ncol = 10)
    colnames(mds_outliers_cluster) <-
      c(
        "LG",
        "start",
        "stop",
        "x",
        "window_start",
        "window_stop",
        "n_windows",
        "mds",
        "mds_num",
        "cluster"
      )
  }
  #save in the biggest matrix
  MDS_CLUSTER_ALL <- rbind(MDS_CLUSTER_ALL, mds_outliers_cluster)
  
}

MDS_CLUSTER_ALL$cluster_size <-
  MDS_CLUSTER_ALL$stop - MDS_CLUSTER_ALL$start
MDS_CLUSTER_ALL <-
  MDS_CLUSTER_ALL[which(is.na(MDS_CLUSTER_ALL$n_windows) == F), ]
MDS_CLUSTER_ALL_FILTER <-
  MDS_CLUSTER_ALL[MDS_CLUSTER_ALL$n_windows >= min_n_window, ]


#write a simplified file with just the position to do pca on each cluster of outlier
MDS_CLUSTER_ALL_FILTER_POS <-
  cbind(
    paste(
      MDS_CLUSTER_ALL_FILTER$LG,
      MDS_CLUSTER_ALL_FILTER$start,
      sep = "_"
    ),
    paste(MDS_CLUSTER_ALL_FILTER$LG, MDS_CLUSTER_ALL_FILTER$stop, sep =
            "_")
  )

colnames(MDS_CLUSTER_ALL_FILTER_POS) <- c("CHR_start", "CHR_stop")

write.table(
  MDS_CLUSTER_ALL_FILTER_POS,
  paste0(
    reports_path,
    "/localPCA/unpruned/outliers/cluster_outlier_allMDS_max",
    max_MDS,
    "_merge",
    x_between,
    "_filter",
    min_n_window,
    "_sdLim",
    sd_lim,
    ".pos"
  ),
  row.names = F,
  col.names = F,
  quote = F,
  sep = "\t"
)

#write the output file
write.table(
  cbind(MDS_CLUSTER_ALL_FILTER_POS, MDS_CLUSTER_ALL_FILTER),
  paste0(
    reports_path,
    "/localPCA/unpruned/outliers/cluster_outlier_allMDS_",
    max_MDS,
    "_merge",
    x_between,
    "_filter",
    min_n_window,
    "_sdLim",
    sd_lim,
    ".txt"
  ),
  row.names = F,
  quote = F,
  sep = "\t"
)


##Plot MDS1 vs MDS2 by chr

plotlist <- list()
#myplot <- patchwork::wrap_plots(mylist, nrow=1)
for (i in unique(mds_scores$LG)){
  
  plot_tmp <- mds_scores %>%
    filter(LG==i) %>% 
    ggplot(aes(x=X2, y=PC1))+
    geom_point(col="#cc7716")+
    scale_x_continuous(
      label = axisdf$LG,
      breaks = axisdf$center,
      expand = c(0.01, 0.01)
    ) +
    labs(x = "MDS2", y="MDS1", title=as.character(i)) +
    geom_hline(yintercept=sd(mds_scores$PC1)*4, linetype="dashed")+
    geom_hline(yintercept=-sd(mds_scores$PC1)*4, linetype="dashed")+
    geom_vline(xintercept=sd(mds_scores$X2)*4, linetype="dashed")+
    geom_vline(xintercept=-sd(mds_scores$X2)*4, linetype="dashed")+
    theme_classic() +
    theme(
      text = element_text(size=12, family="ubuntu"),
      legend.position = "none", 
      panel.border = element_blank())+
    gghighlight::gghighlight(PC1>sd(mds_scores$PC1)*4 | 
                               PC1 < -sd(mds_scores$PC1)*4 |
                               X2 < -sd(mds_scores$X2)*4 |
                               X2 < -sd(mds_scores$X2)*4
                               )
  plotlist[[i]] <- plot_tmp
}

plot_mds1mds2 <- 
  patchwork::wrap_plots(plotlist,
                        nrow = 6,
                        ncol = 6)

ggsave(
  plot = plot_mds1mds2,
  filename = paste0(
    reports_path,
    "/localPCA/unpruned/outliers/plots_mds/MDS1_MDS2_5window_min.png"
  ),
  height = 25,
  width = 25,
  units="cm"
)


plotlist <- list()
for (i in unique(mds_scores$LG)){
  
  plot_tmp <- mds_scores %>%
    filter(LG==i) %>% 
    ggplot(aes(x=X3, y=X4))+
    geom_point(col="#cc7716")+
    scale_x_continuous(
      label = axisdf$LG,
      breaks = axisdf$center,
      expand = c(0.01, 0.01)
    ) +
    labs(x = "MDS3", y="MDS4", title=as.character(i)) +
    geom_hline(yintercept=sd(mds_scores$X4)*4, linetype="dashed")+
    geom_hline(yintercept=-sd(mds_scores$X4)*4, linetype="dashed")+
    geom_vline(xintercept=sd(mds_scores$X3)*4, linetype="dashed")+
    geom_vline(xintercept=-sd(mds_scores$X3)*4, linetype="dashed")+
    theme_classic() +
    theme(
      text = element_text(size=12, family="ubuntu"),
      legend.position = "none", 
      panel.border = element_blank())+
    gghighlight::gghighlight(X3>sd(mds_scores$X3)*4 | 
                               X3 < -sd(mds_scores$X3)*4 |
                               X4 > sd(mds_scores$X4)*4 |
                               X4 < -sd(mds_scores$X4)*4
    )
  plotlist[[i]] <- plot_tmp
}

plot_mds2mds3 <- 
  patchwork::wrap_plots(plotlist,
                        nrow = 6,
                        ncol = 6)

ggsave(
  plot = plot_mds2mds3,
  filename = paste0(
    reports_path,
    "/localPCA/unpruned/outliers/plots_mds/MDS3_MDS4_5window_min.png"
  ),
  height = 25,
  width = 25,
  units="cm"
)


#Plot individual chromosomes that have outlier windows

plot_mds <- list()
mds_col <- 6 + j
mds_vector <- mds_scores[, mds_col]
mds_mean <- mean(mds_vector)
mds_sd <- sd(mds_vector)

create_mds_plot <- function(dataset, chr) {
  mds_scores_chr <- dataset %>% 
    filter(LG == chr)
  mds_vector_chr <- mds_scores_chr[, mds_col]
  
  #calculate limit
  #plot
  plot_mds_chr <- mds_scores_chr %>%
    ggplot(aes(x = n, y = mds_vector_chr, color = LG)) +
    geom_point() +
    scale_x_continuous(
      label = axisdf$LG,
      breaks = axisdf$center,
      expand = c(0.01, 0.01)
    ) +
    scale_color_manual(values="#e9c46a") +
    geom_hline(yintercept = mds_mean + sd_lim * mds_sd,
               linetype = "dashed") +
    geom_hline(yintercept = mds_mean - sd_lim * mds_sd,
               linetype = "dashed") +
    theme_classic() +
    theme(
      text = element_text(size = 12),
      legend.position = "none",
      panel.border = element_blank(),
      axis.ticks.x = element_blank(),
      axis.text.x.bottom = element_blank())+
        labs(
          x = paste0("\n",as.character(chr), "\n"),
          y="MDS2")
  return(plot_mds_chr)
}

list_chr <- c("chr27","chr28","chr29", "chr30")
plot_mds_complete <- list()
for (chr in list_chr) {
  plot_mds_complete[[chr]] <- create_mds_plot(mds_scores, as.character(chr))
}
  
outlier_mds_plots <- wrap_plots(plot_mds_complete)

outlier_mds_plots


ggsave(
  plot = outlier_mds_plots,
  filename = paste0(
    reports_path,
    "/localPCA/",
    "unpruned/",
    "outliers/",
    "chr28_28_29_30_mds_plots.pdf"
  ),
  height = 4.5,
  width = 6
)

chr4A_plot <- 
  mds_scores %>% separate(pos, c("start", "finish"), sep="-") %>%
  filter(LG=="chr4A") %>% 
  ggplot(aes(x = n, y = PC1, color = LG)) +
  geom_point() +
  scale_x_continuous(
    label = axisdf$LG,
    breaks = axisdf$center,
    expand = c(0.01, 0.01)
  ) +
  scale_color_manual(values="#2a9d8f") +
  geom_hline(yintercept = mds_mean + sd_lim * mds_sd,
             linetype = "dashed") +
  geom_hline(yintercept = mds_mean - sd_lim * mds_sd,
             linetype = "dashed") +
  theme_classic() +
  theme(
    text = element_text(size = 12),
    legend.position = "none",
    panel.border = element_blank(),
    axis.ticks.x = element_blank(),
    axis.text.x.bottom = element_blank())+
  labs(
    x = paste0("\nchr4A\n"),
    y="MDS1")

mds_plot <- clusters %>% 
  filter(GeneticSex!="NA") %>% 
  distinct(id, .keep_all = T) %>% 
  ggplot(aes(x=PC1, y=PC2, col=as.factor(GeneticSex)))+
  geom_point()+
  theme_minimal() +
  scale_color_manual(values = c("#264653", "#e76f51"))+
  theme(
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(), 
    axis.text.x = element_text(hjust=1, size=text_size),
    axis.text.y = element_text(size = text_size),
    axis.title = element_text(size = text_size),
    legend.position = "right",
    legend.text = element_text(size=11),
    legend.title = element_text())+
  labs(x="\nMDS1", y="MDS2\n")+
  #, 
  #subtitle="Multidimensional Scaling\n")+
  guides(color=guide_legend(title="Cluster"))

neosex<-mds_plot/chr4A_plot

ggsave(
  neosex,
  filename = file.path(reports_path, 
                       "/localPCA/",
                       "unpruned/",
                       "outliers/",
                       paste0("neosex_chr.pdf")),
  device = "pdf",width = 4, height=4.5
)
