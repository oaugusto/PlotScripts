setwd("C:/Users/oaugu/Desktop/PlotScripts/CBNet")
#setwd("/home/oaugusto/Master/PlotsScripts/CBNet")

################################## Libraries ###################################

library(ggplot2)
library(gridExtra)
library(tidyverse)
library(plyr)
library(grid)
library(ggrepel)
library(dplyr)

# setup
options(scipen = 999)
theme_set(theme_bw())

############################# Reading tables  ##################################

total_work.table <- read.csv("./csv_data/projector/total_work.csv")
makespan.table <- read.csv("./csv_data/projector/total_time.csv")
clusters.table <- read.csv("./csv_data/projector/cluster.csv")
throughput.table <- read.csv("./csv_data/projector/throughput.csv")

############################# Define colors  ##################################

#COLORS
#cbn_color = "#325387"
cbn_color = "#000000"
cbn1 = "#325387"
cbn2 = "#325387"

#scbn_color = "#6C5B7B"
scbn_color = "#ffffff"
scbn1 = "#6C5B7B"
scbn2 = "#6C5B7B"

#sn_color = "#021C02"
sn_color = "#A8A7A7"
sn1 = "#1A361A"
sn2 = "#021C02"

#dsn_color = "#B53131"
dsn_color = "#2A363B"
dsn1 = "#CF4F4F"
dsn2 = "#B53131"

opt_color = "#87C8E6"
opt1 = "#BEDCEB"
opt2 = "#87C8E6"

bt_color = "#555555"
bt1 = "#555555"
bt2 = "#555555"

############################# Define imgs paremeters ######################

scale_imgs <- 1

IMG_height = 15
IMG_width = 40

text_size <- 30
x_title_size <- 25
y_title_size <- 25
x_text_size <- 18
y_text_size <- 18

num_sim <- 10

############################# total work ##################################

total_work.table["abb"] <- revalue(total_work.table$project, 
                                   c("cbnet" = "CBN",
                                     "seqopticalnet2048" = "SOP48",
                                     "opticalnet2048" = "OP48",
                                     "optnet" = "OPT",
                                     "simplenet" = "BT"))

total_work.table$abb <- factor(total_work.table$abb, levels = c("OPT", "SOP48","OP48", "CBN", "BT"))

total_work.table["operation"] <- revalue(total_work.table$operation, c("rotation" = "Rotation",
                                                                       "routing" = "Routing"))

#total_work.table %>% filter(
#  size %in% c(1024)) -> total_work.table

total_work.table %>% filter(
  operation %in% c("Rotation", "Routing")) -> operations.table

total_work.table %>% filter(
  operation %in% c("total")) -> total.table

total.table$operation <- revalue(total.table$operation,
                                 c("total" = "Rotation"))

# Init Ggplot Base Plot
total_work.plot <- ggplot(operations.table, aes(x = abb, y = mean, fill = operation)) +#, col = abb)) +
  geom_bar(position = "stack", stat = "identity", alpha = 0.8) +
  geom_errorbar(total.table, mapping = aes(x = abb, 
                                           ymin = mean - ((qnorm(0.975)*std)/sqrt(num_sim)), 
                                           ymax = mean + ((qnorm(0.975)*std)/sqrt(num_sim))),
                width=.2,                    # Width of the error bars
                position="identity",
                colour = "#000000") +
facet_grid(. ~ size)#, scales = 'free', space = 'free', nrow = 2)


# Modify theme components -------------------------------------------
total_work.plot <- total_work.plot + theme(text = element_text(size = text_size),
                                           plot.title = element_blank(),
                                           plot.subtitle = element_blank(),
                                           plot.caption = element_blank(),
                                           axis.title.x = element_blank(),
                                           axis.title.y = element_text(size = y_title_size),
                                           axis.text.x = element_text(size = x_text_size, color = "black"),
                                           axis.text.y = element_text(size = y_text_size, color = "black"),
                                           #legend.text = element_text(size = text_size),
                                           legend.title = element_blank(),
                                           legend.position = c(0.15, 0.9))

total_work.plot <- total_work.plot + theme(panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank()) +
  labs(y = expression(paste("Work x", 10^{4}))) +
  scale_color_manual(values = c(opt_color, scbn_color, cbn_color, sn_color, dsn_color, bt_color)) +
  scale_fill_manual(values = c("#2A363B","#A8A7A7")) +
  scale_y_continuous(lim = c(0, 150000), breaks = seq(0, 200000, 20000), labels = function(x){paste0(x/10000)}) #+
#guides(color = FALSE)

# Create a text
#grob <- grobTree(textGrob("OPT: StaticOPT\nCBN: CBNet\nAD: CBNetAdapt\nSN: SplayNet\nDSN: DiSplayNet\nBT: Balanced Tree", x=0.35,  y=0.75, hjust=0,
#                          gp=gpar(col="black", fontsize= 24)))

#total_work.plot <- total_work.plot +  annotation_custom(grob)

plot(total_work.plot)

ggsave(filename = "./plots/projecToR/total_work_grid.png", units = "cm",
       plot = total_work.plot, device = "png",  width = IMG_width, height = IMG_height, scale = scale_imgs)


############################# throughput  ##################################


throughput.table["abb"] <- revalue(throughput.table$project, 
                                   c("cbnet" = "CBN",
                                     "cbnetAdapt" = "AD",
                                     "seqcbnet" = "SCBN",
                                     "splaynet" = "SN", 
                                     "displaynet" = "DSN"))

throughput.table$abb <- factor(throughput.table$abb, levels = c("CBN", "AD","DSN", "SN", "SCBN"))


throughput.table %>% filter(
  size %in% c(128)) -> throughput.table

#labels <- throughput.table %>% 
#  dplyr::group_by(abb) %>% 
#  dplyr::summarise(xPos = max(value),
#                   yPos = max((density(value))$y))

# Init Ggplot Base Plot
throughput.plot <- ggplot(throughput.table, aes(x = value, fill = abb)) +
  geom_density(aes(y = ..count..), alpha = 0.67) #+
#geom_label_repel(data = labels, aes(x = xPos, y = yPos, label = abb))

# Modify theme components -------------------------------------------
throughput.plot <- throughput.plot + theme(text = element_text(size = text_size),
                                           plot.title = element_blank(),
                                           plot.subtitle = element_blank(),
                                           plot.caption = element_blank(),
                                           axis.title.x = element_text(size = x_title_size),
                                           axis.title.y = element_text(size = y_title_size),
                                           axis.text.x = element_text(size = x_text_size, color = "black"),
                                           axis.text.y = element_text(size = y_text_size, color = "black"),
                                           #legend.text = element_text(size = text_size),
                                           legend.title = element_blank(),
                                           legend.position = c(0.82, 0.77)) #+
#facet_grid(. ~ size)

throughput.plot <- throughput.plot + theme(panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank()) +
  labs(x = expression(paste("Time (rounds) x", 10^4)), y = "Requests completed/round") +
  scale_fill_manual(values = c(cbn_color, bt_color, dsn_color, sn_color, scbn_color)) +
  scale_y_continuous(lim = c(0, 0.8), breaks = seq(0, 5, 0.1)) +
  scale_x_continuous(labels = function(x){paste0(x/10000)})

plot(throughput.plot)

ggsave(filename = "./plots/projecToR/throughput.png", units = "cm",
       plot = throughput.plot, device = "png",  width = IMG_width, height = IMG_height, scale = scale_imgs)


############################# cluster ##################################


clusters.table["abb"] <- revalue(clusters.table$project, 
                                 c("cbnet" = "CBN",
                                   "seqcbnet" = "SCBN",
                                   "splaynet" = "SN", 
                                   "displaynet" = "DSN"))

clusters.table$abb <- factor(clusters.table$abb, levels = c("SCBN", "CBN", "SN", "DSN"))

clusters.table %>% filter(
  size %in% c(128)) -> clusters.table

clusters.table %>% filter(
  abb %in% c("CBN", "DSN")) -> clusters.table

# Init Ggplot Base Plot
#cluster_cdf.plot <- ggplot(clusters.table, aes(x = value, colour = abb)) +
#  stat_ecdf(aes(linetype = abb), geom = "step", size = 1.2) +
#  geom_hline(yintercept = 1, linetype="dashed") 


# Modify theme components -------------------------------------------
#cluster_cdf.plot <- cluster_cdf.plot + theme(text = element_text(size = 25),
#                                       plot.title = element_blank(),
#                                       plot.subtitle = element_blank(),
#                                       plot.caption = element_blank(),
#                                       axis.title.x = element_text(size = x_title_size),
#                                       axis.title.y = element_text(size = y_title_size),
#                                       axis.text.x = element_text(size = 20, color = "black"),
#                                       axis.text.y = element_text(size = 20, color = "black"),
#                                       legend.title = element_blank(),
#                                       legend.position = c(0.375, 0.4))

#cluster_cdf.plot <- cluster_cdf.plot + theme(panel.grid.minor = element_blank(),
#                                       panel.grid.major = element_blank()) +
#  labs(x = "#Clusters", y = "CDF of Clusters") +
#  scale_color_manual(values = c("#2A363B","#A8A7A7")) +
#  scale_x_continuous(breaks = seq(0, 10, 1)) +
#  coord_cartesian(xlim = c(0, 10))
#coord_cartesian(xlim = c(0, 10))

#plot(cluster_cdf.plot)

#ggsave(filename = "./plots/projecToR/clusters.png", units = "cm",
#       plot = cluster_cdf.plot, device = "png",  width = IMG_width, height = IMG_height, scale = scale_imgs)

# Init Ggplot Base Plot
clusters.plot <- ggplot(clusters.table, aes(x = value, fill = abb)) +
  geom_histogram(aes(y = ..count..), position = "dodge", binwidth = 1, alpha = 1, col = "#000000") #+
#facet_grid(. ~ size)
# Add mean line
#geom_vline(aes(xintercept=mean(value)), linetype="dashed")

# Modify theme components -------------------------------------------
clusters.plot <- clusters.plot + theme(text = element_text(size = 25),
                                       plot.title = element_blank(),
                                       plot.subtitle = element_blank(),
                                       plot.caption = element_blank(),
                                       axis.title.x = element_text(size = 25),
                                       axis.title.y = element_text(size = 25),
                                       axis.text.x = element_text(size = 20, color = "black"),
                                       axis.text.y = element_text(size = 20, color = "black"),
                                       legend.text = element_text(size = text_size),
                                       legend.title = element_blank(),
                                       legend.position = c(0.82, 0.77),
                                       panel.grid.minor = element_blank(),
                                       panel.grid.major = element_blank())

clusters.plot <- clusters.plot + 
  labs(x = "#Clusters", y = expression(paste("#Rounds x", 10^3))) +
  scale_fill_manual(values = c("#2A363B","#A8A7A7")) +
  scale_y_sqrt(lim = c(0, 62000), breaks = seq(0, 60000, 10000), labels = function(x){paste0(x/1000)}) +
  scale_x_continuous(breaks = seq(0, 10, 1)) +
  coord_cartesian(xlim = c(0, 10))

plot(clusters.plot)

ggsave(filename = "./plots/projecToR/clusters.png", units = "cm",
       plot = clusters.plot, device = "png",  width = IMG_width, height = IMG_height, scale = scale_imgs)

############################# makespan 1 ##################################


#makespan.table["abb"] <- revalue(makespan.table$project, 
#                                 c("cbnet" = "CBN",
#                                   "seqcbnet" = "SCBN",
#                                   "splaynet" = "SN", 
#                                   "displaynet" = "DSN"))

#makespan.table$abb <- factor(makespan.table$abb, levels = c("CBN", "SCBN", "DSN", "SN"))

#makespan.table$size <- as.factor(makespan.table$size)

# Init Ggplot Base Plot
#makespan.plot <- ggplot(makespan.table, aes(x = abb, y = mean, fill = abb)) +
#  geom_bar(stat = "identity", position=position_dodge(), alpha = 0.8) +
#  geom_errorbar(aes(ymin = mean - ((qnorm(0.975)*std)/sqrt(num_sim)), 
#                    ymax = mean + ((qnorm(0.975)*std)/sqrt(num_sim)) ), 
#                width=.2) +
#  facet_grid(. ~ size)

# Modify theme components -------------------------------------------
#makespan.plot <- makespan.plot + theme(text = element_text(size = text_size),
#                                       plot.title = element_blank(),
#                                       plot.subtitle = element_blank(),
#                                       plot.caption = element_blank(),
#                                       axis.title.x = element_blank(),
#                                       axis.title.y = element_text(size = y_title_size),
#                                       axis.text.x = element_text(size = x_text_size),
#                                       axis.text.y = element_text(size = y_text_size),
#                                       legend.text = element_text(size = text_size),
#                                       legend.title = element_blank(),
#                                       legend.position = "none")#c(0.05, 0.83))

#makespan.plot <- makespan.plot + theme(panel.grid.minor = element_blank(),
#                                       panel.grid.major = element_blank()) +
#  labs(x = "n", y = expression(paste("#Rounds x ", 10^{4}))) +
#  scale_color_manual(values = c(cbn_color, scbn_color, dsn_color, sn_color)) +
#  scale_fill_manual(values = c(cbn_color, scbn_color, dsn_color, sn_color)) +
#  scale_y_continuous(limits = c(0, 80000), breaks = seq(0, 80000, 10000), labels = function(x){paste0(x/10000)}) +
#  guides(color = guide_legend(override.aes = list(size = 5)))

#plot(makespan.plot)

#ggsave(filename = "./plots/projecToR/makespan.png", units = "cm",
#       plot = makespan.plot, device = "png",  width = IMG_width, height = IMG_height, scale = scale_imgs)
