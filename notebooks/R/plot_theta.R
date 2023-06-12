residents <- 
  read_table("/home/zoo/sjoh4959/central_van.thetasWindow.gz.pestPG")

residents <- 
  read_table("/home/zoo/sjoh4959/tanna.thetasWindow.gz.pestPG")

order_chr <- as.character(seq(from = 5, to = 30))
reference = c(c("1", "1A", "2", "3", "4", "4A"), order_chr, "Z")
ref = factor(as.factor(paste0("chr", reference)), levels = c(c("chr1", "chr1A", "chr2", "chr3", "chr4", "chr4A"), paste0("chr",order_chr), "chrZ"))
residents <- residents[order(factor(as.factor(residents$Chr), levels = ref)),]
residents$n <- 1:nrow(residents)

axisresidents <-
  residents %>%
  group_by(Chr) %>%
  summarize(center = (max(n) + min(n)) / 2)


chr29<-
  residents %>%
  filter(Chr=="chr29") %>% 
  ggplot(aes(x = n, y = Tajima, col=Chr)) + 
  scale_x_continuous(
    label = axisresidents$Chr,
    breaks = axisresidents$center,
    expand = c(0.01, 0.01)
  ) +
  geom_point()+
  scale_color_manual(values=rep(c("#356996", "#2f404f"), length(unique(residents$Chr))))+
  labs(x = "\n", y="Tajima's D", title = "Chr29") +
  theme_classic() +
  theme(
    text = element_text(size=12, family="ubuntu"),
    legend.position = "none", 
    panel.border = element_blank())

chr27<-
  residents %>%
  filter(Chr=="chr27") %>% 
  ggplot(aes(x = n, y = Tajima, col=Chr)) + 
  scale_x_continuous(
    label = axisresidents$Chr,
    breaks = axisresidents$center,
    expand = c(0.01, 0.01)
  ) +
  geom_point()+
  scale_color_manual(values=rep(c("#356996", "#2f404f"), length(unique(residents$Chr))))+
  labs(x = "\n", y="Tajima's D", title = "Chr27") +
  theme_classic() +
  theme(
    text = element_text(size=12, family="ubuntu"),
    legend.position = "none", 
    panel.border = element_blank())

chr28<-
  residents %>%
  filter(Chr=="chr28") %>% 
  ggplot(aes(x = n, y = Tajima, col=Chr)) + 
  scale_x_continuous(
    label = axisresidents$Chr,
    breaks = axisresidents$center,
    expand = c(0.01, 0.01)
  ) +
  geom_point()+
  scale_color_manual(values=rep(c("#356996", "#2f404f"), length(unique(residents$Chr))))+
  labs(x = "\n", y="Tajima's D", title = "Chr28") +
  theme_classic() +
  theme(
    text = element_text(size=12, family="ubuntu"),
    legend.position = "none", 
    panel.border = element_blank())

lifou <- chr27/chr28/chr29+plot_annotation(title="Lifou")
central_van <- chr27/chr28/chr29+plot_annotation(title="Central Vanuatu")
tanna <- chr27/chr28/chr29+plot_annotation(title="Tanna")

lifou/central_van/tanna

residents %>%
  filter(Chr=="chr2") %>% 
  # filter(WinCenter>69141024) %>% 
  # filter(WinCenter<69301024) %>% 
  ggplot(aes(x = n, y = Tajima, col=Chr)) + 
  scale_x_continuous(
    label = axisresidents$Chr,
    breaks = axisresidents$center,
    expand = c(0.01, 0.01)
  ) +
  geom_point()+
  scale_color_manual(values=rep(c("#356996", "#2f404f"), length(unique(residents$Chr))))+
  labs(x = "\n", y="Tajima's D", title = "Chr28") +
  theme_classic() +
  theme(
    text = element_text(size=12, family="ubuntu"),
    legend.position = "none", 
    panel.border = element_blank())


residents %>%
  filter(Chr=="chr2") %>% 
  filter(WinCenter>69141024) %>% 
  filter(WinCenter<69301024) %>% 
  ggplot(aes(x = n, y = Tajima, col=Chr)) + 
  scale_x_continuous(
    label = axisresidents$Chr,
    breaks = axisresidents$center,
    expand = c(0.01, 0.01)
  ) +
  geom_point()+
  scale_color_manual(values=rep(c("#356996", "#2f404f"), length(unique(residents$Chr))))+
  labs(x = "\n", y="Tajima's D", title = "") +
  theme_classic() +
  theme(
    text = element_text(size=12, family="ubuntu"),
    legend.position = "none", 
    panel.border = element_blank())
