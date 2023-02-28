# argv <- commandArgs(T)
# INPUT_FOLDER <- argv[1]
# max_MDS<- as.numeric(argv[2])#nb of mds on whcih to work
# sd_lim<- as.numeric(argv[3])#limit for being outlier
# x_between<- as.numeric(argv[4]) #merge window with this number of windows between them
# min_n_window<- as.numeric(argv[5]) #remove cluster with less than this number of window

max_MDS <- 4#nb of mds on whcih to work
sd_lim <- 4#limit for being outlier
x_between <-
  20 #merge window with this number of windows between them
min_n_window <- 5#remove cluster with less than this number of window

#read msd scores
mds_scores <-
  read.table(file.path(reports_path,
                       "localPCA/big_data/chr1-30Z4A1A_localpca.csv"),
             header = T)
head(mds_scores)

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
    scale_color_manual(values = rep(c("#348544", "#69bf5a"), 
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
      "/localPCA/outlier_mds/",
      j,
      "_all_LG_window100_sd_lim",
      sd_lim,
      ".png"
    ),
    height = 12, 
    width = 25, 
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
        "/localPCA/outlier_mds/cluster_mds_pos",
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
        "/localPCA/outlier_mds/cluster_mds_neg",
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
    "/localPCA/outlier_mds/cluster_outlier_allMDS_max",
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
    "/localPCA/outlier_mds/cluster_outlier_allMDS_",
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

