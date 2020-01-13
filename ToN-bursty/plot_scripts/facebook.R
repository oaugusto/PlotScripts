#setwd("C:/Users/oaugusto/Desktop/Plots/ToN")
setwd("/home/oaugusto/CBNet/PlotsScripts/ToN")

################################## Libraries ###################################

library(ggplot2)
library(gridExtra)
library(tidyverse)
library(plyr)

# setup
options(scipen = 999)
theme_set(theme_bw())

############################# Reading tables  ##################################

total_work.table <- read.csv("./csv_data/facebook/total_work.csv")
makespan.table <-read.csv("./csv_data/facebook/total_time.csv")
clusters.table <-read.csv("./csv_data/facebook/cluster.csv")
throughput.table <-read.csv("./csv_data/facebook/throughput.csv")
work_cdf.table <- read.csv("./csv_data/facebook/work_cdf.csv")


############################# Define colors  ##################################

#COLORS
sn_color = "#021C02"
sn1 = "#1A361A"
sn2 = "#021C02"

dsn_color = "#B53131"
dsn1 = "#CF4F4F"
dsn2 = "#B53131"

opt_color = "#87C8E6"
opt1 = "#BEDCEB"
opt2 = "#87C8E6"

bt_color = "#555555"
bt1 = "#555555"
bt2 = "#555555"

############################# total work ##################################

total_work.table["abb"] <- revalue(total_work.table$project, 
                                   c("splaynet" = "sn", 
                                     "displaynet" = "dsn",
                                     "optnet" = "opt",
                                     "simplenet" = "bt"))

total_work.table$abb <- factor(total_work.table$abb, levels = c("opt", "sn", "dsn", "bt"))

# Init Ggplot Base Plot
total_work.plot <- ggplot(total_work.table, aes(x = abb, y = work, fill = abb)) +
  geom_bar(stat = "identity")


# Modify theme components -------------------------------------------
total_work.plot <- total_work.plot + theme(text = element_text(size = 20),
                                           plot.title = element_blank(),
                                           plot.subtitle = element_blank(),
                                           plot.caption = element_blank(),
                                           axis.title.x = element_blank(),
                                           axis.title.y = element_text(size = 25),
                                           axis.text.x = element_blank(),
                                           axis.text.y = element_text(size = 20),
                                           axis.ticks.x = element_blank(),
                                           legend.text = element_text(size = 12),
                                           legend.title = element_blank(),
                                           legend.position = c(0.85, 0.82))

total_work.plot <- total_work.plot + theme(panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank()) +
  labs(y = expression(paste("Work x", 10^{6}))) +
  scale_fill_manual(values = c(opt_color, sn_color, dsn_color, bt_color)) +
  scale_y_continuous(breaks = seq(10000000, 170000000, 2000000), labels = function(x){paste0(x/1000000)})

plot(total_work.plot)

IMG_height = 2.5
IMG_width = 3.0

ggsave(filename = "./plots/facebook/total_work.pdf", units = "cm",
       plot = total_work.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 4.0)

############################# cdf work  ##################################


work_cdf.table["abb"] <- revalue(work_cdf.table$project, 
                                 c("splaynet" = "sn", 
                                   "displaynet" = "dsn",
                                   "optnet" = "opt",
                                   "simplenet" = "bt"))

work_cdf.table$abb <- factor(work_cdf.table$abb, levels = c("opt", "sn", "dsn", "bt"))

# Init Ggplot Base Plot
work_cdf.plot <- ggplot(work_cdf.table, aes(x = value, colour = abb)) +
  stat_ecdf(aes(linetype = abb), geom = "step", size = 1.0) +
  geom_hline(yintercept = 1, linetype="dashed")


# Modify theme components -------------------------------------------
work_cdf.plot <- work_cdf.plot + theme(text = element_text(size = 20),
                                       plot.title = element_blank(),
                                       plot.subtitle = element_blank(),
                                       plot.caption = element_blank(),
                                       axis.title.x = element_text(size = 20),
                                       axis.title.y = element_text(size = 20),
                                       axis.text.x = element_text(size = 18),
                                       axis.text.y = element_text(size = 18),
                                       legend.title = element_blank(),
                                       legend.text = element_text(size = 18),
                                       legend.position = c(0.8, 0.2))

work_cdf.plot <- work_cdf.plot + theme(panel.grid.minor = element_blank(),
                                       panel.grid.major = element_blank()) +
  labs(x = "Steps per request", y = "CDF of Requests") +
  scale_color_manual(values = c(opt_color, sn_color, dsn_color, bt_color)) +
  coord_cartesian(xlim = c(0, 30))

plot(work_cdf.plot)

IMG_height = 2.5
IMG_width = 2.5

ggsave(filename = "./plots/facebook/work_cdf.pdf", units = "cm",
       plot =work_cdf.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 4.0)


############################# makespan  ##################################


makespan.table["abb"] <- revalue(makespan.table$project, 
                                 c("splaynet" = "sn", 
                                   "displaynet" = "dsn"))

makespan.table$abb <- factor(makespan.table$abb, levels = c("sn", "dsn"))

# Init Ggplot Base Plot
makespan.plot <- ggplot(makespan.table, aes(x = abb, y = work, color = abb)) +
  geom_boxplot(size = 1.5) 

# Modify theme components -------------------------------------------
makespan.plot <- makespan.plot + theme(text = element_text(size = 20),
                                       plot.title = element_blank(),
                                       plot.subtitle = element_blank(),
                                       plot.caption = element_blank(),
                                       axis.title.x = element_blank(),
                                       axis.title.y = element_text(size = 20),
                                       axis.text.x = element_text(size = 18),
                                       axis.text.y = element_text(size = 18),
                                       legend.text = element_text(size = 18),
                                       legend.title = element_blank(),
                                       legend.position = c(0.8, 0.8))

makespan.plot <- makespan.plot + theme(panel.grid.minor = element_blank(),
                                       panel.grid.major = element_blank()) +
  labs(y = expression(paste("#Rounds x ", 10^{5}))) +
  scale_color_manual(values = c(sn_color, dsn_color)) +
  #coord_cartesian(ylim = c(2900000, 3400000)) +
  scale_y_continuous(labels = function(x){paste0(x/100000)})

plot(makespan.plot)

IMG_height = 2.5
IMG_width = 2.5

ggsave(filename = "./plots/facebook/makespan.pdf", units = "cm",
       plot = makespan.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 4.0)


############################# throughput  ##################################


throughput.table["abb"] <- revalue(throughput.table$project, 
                                   c("splaynet" = "sn", 
                                     "displaynet" = "dsn"))

throughput.table$abb <- factor(throughput.table$abb, levels = c("sn", "dsn"))

# Init Ggplot Base Plot
throughput.plot <- ggplot(throughput.table, aes(x = value, fill = abb)) +
  geom_density(aes(y = ..count..), alpha = 0.5)

# Modify theme components -------------------------------------------
throughput.plot <- throughput.plot + theme(text = element_text(size = 20),
                                           plot.title = element_blank(),
                                           plot.subtitle = element_blank(),
                                           plot.caption = element_blank(),
                                           axis.title.x = element_text(size = 18),
                                           axis.title.y = element_text(size = 16),
                                           axis.text.x = element_text(size = 18),
                                           axis.text.y = element_text(size = 18),
                                           legend.text = element_text(size = 14),
                                           legend.title = element_blank(),
                                           legend.position = c(0.8, 0.8))

throughput.plot <- throughput.plot + theme(panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank()) +
  labs(x = expression(paste("Time (rounds) x", 10^6)), y = "Requests completed per round") +
  scale_fill_manual(values = c(sn_color, dsn_color)) +
  scale_x_continuous(labels = function(x){paste0(x/1000000)})

plot(throughput.plot)

IMG_height = 2.5
IMG_width = 3.5

ggsave(filename = "./plots/facebook/throughput.pdf", units = "cm",
       plot = throughput.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 4.0)


############################# cluster ##################################


clusters.table["abb"] <- revalue(clusters.table$project, 
                                 c("splaynet" = "sn", 
                                   "displaynet" = "dsn"))

clusters.table$abb <- factor(clusters.table$abb, levels = c("sn", "dsn"))

# Init Ggplot Base Plot
clusters.plot <- ggplot(clusters.table, aes(x = value, fill = abb)) +
  geom_histogram(aes(y = ..count..), position = "dodge", binwidth = 10000) +
  # Add mean line
  geom_vline(aes(xintercept=mean(value)), linetype="dashed") 

# Modify theme components -------------------------------------------
clusters.plot <- clusters.plot + theme(text = element_text(size = 20),
                                       plot.title = element_blank(),
                                       plot.subtitle = element_blank(),
                                       plot.caption = element_blank(),
                                       axis.title.x = element_text(size = 20),
                                       axis.title.y = element_text(size = 20),
                                       axis.text.x = element_text(size = 20),
                                       axis.text.y = element_text(size = 12),
                                       legend.text = element_text(size = 12),
                                       legend.title = element_blank(),
                                       legend.position = c(0.8, 0.8),
                                       panel.grid.minor = element_blank(),
                                       panel.grid.major = element_blank())

clusters.plot <- clusters.plot + 
  labs(x = "#Clusters", y = expression(paste("#Rounds x", 10^4))) +
  scale_fill_manual(values = c(sn_color, dsn_color)) +
  scale_y_continuous(labels = function(x){paste0(x/10000)})

plot(clusters.plot)

IMG_height = 2.5
IMG_width = 2.5

ggsave(filename = "./plots/facebook/clusters.pdf", units = "cm",
       plot = clusters.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 4.0)
