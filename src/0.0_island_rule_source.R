# 0.0_island_rule_source.R
#
# This script provides the source code necessary to 
# check whether recorders are affecting egg laying 
# and make plots to this effect
# 
# Copyright (c) Andrea Estandia, 2020, except where indicated
# Date Created: 2020-11-16
# --------------------------------------------------------------------------
# REQUIRES
# --------------------------------------------------------------------------

suppressPackageStartupMessages({
  library(tidyverse)
  library(dplyr)
  library(xlsx)
  library(ggpubr)
  library(patchwork)
  library(ggannotate)
  library(bookdown)
  library(sysfonts)
  library(kableExtra)
  library(ggplot2)
  library(stringr)
  #library(biomaRt)
  #library(units)
  library(rnaturalearth)
  library(ggrepel)
  library(data.table)
  library(lostruct)
})

text_size=12
# --------------------------------------------------------------------------
# PATHS
# --------------------------------------------------------------------------

data_path <- file.path(getwd(), "data")
figures_path <- file.path(getwd(), "reports", "plots")
reports_path <- file.path(getwd(), "reports")
subset_pheno_path <- file.path(getwd(), "data", "phenotypes", "subset")
subset_ind_path <- file.path(getwd(), "data", "wgs", "lists")

if (!dir.exists(data_path)) {
  dir.create(data_path, recursive = TRUE)
}

if (!dir.exists(figures_path)) {
  dir.create(figures_path, recursive = TRUE)
}

# --------------------------------------------------------------------------
# FUNCTIONS
# --------------------------------------------------------------------------

firstup <- function(x) {
  substr(x, 1, 1) <- toupper(substr(x, 1, 1))
  x
}

'%!in%' <- function(x,y)!('%in%'(x,y))

# --------------------------------------------------------------------------
# COLOURS
# --------------------------------------------------------------------------

background_colour = "#ededed"

magma_pal <-
  c(
    "#a3307eff",#heron
    "#0000044F",#wa
    "#5a167eff",#queensland
    "#e95562ff",#mel
    "#7d2482FF",#LATERALIS
    "#f97c5dff",#mel
    "#fea873ff",#mel
    "#120D32FF",#sa
    "#c83e73ff",#lhi
    "#fcfdbfff",#mel
    "#FED395FF",#mel
    "#331068ff"#nsw
  )