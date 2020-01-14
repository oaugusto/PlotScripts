setwd("C:/Users/oaugusto/Desktop/PlotScripts/ToN-bursty")
#setwd("/home/oaugusto/Desktop/ToN")

################################## Libraries ###################################

library(ggplot2)
library(gridExtra)
library(tidyverse)
library(plyr)

# setup
options(scipen = 999)
theme_set(theme_bw())

############################# Reading tables  ##################################

total_work.table <- read.csv("./csv_data/normal/total_work.csv")
makespan.table <-read.csv("./csv_data/normal/total_time.csv")
clusters.table <-read.csv("./csv_data/normal/cluster.csv")
throughput.table <-read.csv("./csv_data/normal/throughput.csv")
work_cdf.table <- read.csv("./csv_data/normal/work_cdf.csv")


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
                                   c("splaynet" = "SplayNet", 
                                     "displaynet" = "DiSplayNet",
                                     "optnet" = "StaticOPT",
                                     "simplenet" = "Balanced Tree"))

total_work.table$abb <- factor(total_work.table$abb, levels = c("StaticOPT", "SplayNet", "DiSplayNet", "Balanced Tree"))

total_work.table$std_par <- as.factor(total_work.table$std_par)

total_work.table %>% filter(
  size %in% c(1024)) -> total_work.table

# Init Ggplot Base Plot
total_work.plot <- ggplot(total_work.table, aes(x = std_par, y = mean, color = abb)) +
  geom_boxplot(position = "identity", size = 0.5) +
  geom_errorbar(total_work.table, mapping = aes(x = std_par, 
                                                ymin = mean - ((qnorm(0.975)*std)/sqrt(30)), 
                                                ymax = mean + ((qnorm(0.975)*std)/sqrt(30))),
                width=.2,                    # Width of the error bars
                position="identity",
                colour = "#000000")


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
                                           legend.title = element_blank(),
                                           legend.position = c(0.25, 0.75))

total_work.plot <- total_work.plot + theme(panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank()) +
  labs(y = expression(paste("Work x", 10^{4}))) +
  scale_color_manual(values = c(opt_color, sn_color, dsn_color, bt_color)) +
  scale_y_continuous(breaks = seq(0, 200000, 20000), labels = function(x){paste0(x/10000)})

plot(total_work.plot)

IMG_height = 15
IMG_width = 15

ggsave(filename = "./plots/normal/total_work.pdf", units = "cm",
       plot = total_work.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 1.0)

############################# cdf work  ##################################


work_cdf.table["abb"] <- revalue(work_cdf.table$project, 
                                 c("splaynet" = "SplayNet", 
                                   "displaynet" = "DiSplayNet",
                                   "optnet" = "StaticOPT",
                                   "simplenet" = "Balanced Tree"))

work_cdf.table$abb <- factor(work_cdf.table$abb, levels = c("StaticOPT", "SplayNet", "DiSplayNet", "Balanced Tree"))


work_cdf.table %>% filter(
  std %in% c(1.6)) -> work_cdf.table

work_cdf.table %>% filter(
  size %in% c(1024)) -> work_cdf.table

# Init Ggplot Base Plot
work_cdf.plot <- ggplot(work_cdf.table, aes(x = value, colour = abb)) +
  stat_ecdf(aes(linetype = abb), geom = "step", size = 1.0) +
  geom_hline(yintercept = 1, linetype="dashed")


# Modify theme components -------------------------------------------
work_cdf.plot <- work_cdf.plot + theme(text = element_text(size = 20),
                                       plot.title = element_blank(),
                                       plot.subtitle = element_blank(),
                                       plot.caption = element_blank(),
                                       axis.title.x = element_text(size = 25),
                                       axis.title.y = element_text(size = 25),
                                       axis.text.x = element_text(size = 20),
                                       axis.text.y = element_text(size = 20),
                                       legend.title = element_blank(),
                                       legend.position = c(0.22, 0.65))

work_cdf.plot <- work_cdf.plot + theme(panel.grid.minor = element_blank(),
                                       panel.grid.major = element_blank()) +
  labs(x = "Steps per request", y = "CDF of Requests") +
  scale_color_manual(values = c(opt_color, sn_color, dsn_color, bt_color)) +
  coord_cartesian(xlim = c(0, 20))

plot(work_cdf.plot)

IMG_height = 15
IMG_width = 15

ggsave(filename = "./plots/normal/work_cdf.pdf", units = "cm",
       plot =work_cdf.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 1.0)


############################# makespan  ##################################


makespan.table["abb"] <- revalue(makespan.table$project, 
                                 c("splaynet" = "SplayNet", 
                                   "displaynet" = "DiSplayNet"))

makespan.table$abb <- factor(makespan.table$abb, levels = c("SplayNet", "DiSplayNet"))

makespan.table$std_par <- as.factor(makespan.table$std_par)

makespan.table %>% filter(
  size %in% c(1024)) -> makespan.table

# Init Ggplot Base Plot
makespan.plot <- ggplot(makespan.table, aes(x = std_par, y = mean, color = abb)) +
  geom_boxplot(position = "identity", size = 0.5) +
  geom_errorbar(aes(ymin = mean - ((qnorm(0.975)*std)/sqrt(30)), 
                    ymax = mean + ((qnorm(0.975)*std)/sqrt(30)) ), 
                width=.2,
                position="identity")

# Modify theme components -------------------------------------------
makespan.plot <- makespan.plot + theme(text = element_text(size = 20),
                                       plot.title = element_blank(),
                                       plot.subtitle = element_blank(),
                                       plot.caption = element_blank(),
                                       axis.title.x = element_text(size = 25),
                                       axis.title.y = element_text(size = 25),
                                       axis.text.x = element_text(size = 20),
                                       axis.text.y = element_text(size = 20),
                                       legend.title = element_blank(),
                                       legend.position = c(0.8, 0.2))

makespan.plot <- makespan.plot + theme(panel.grid.minor = element_blank(),
                                       panel.grid.major = element_blank()) +
  labs(x = "#Nodes", y = expression(paste("#Rounds x ", 10^{4}))) +
  scale_color_manual(values = c(sn_color, dsn_color)) +
  scale_y_continuous(labels = function(x){paste0(x/10000)})

plot(makespan.plot)

IMG_height = 15
IMG_width = 15

ggsave(filename = "./plots/normal/makespan.pdf", units = "cm",
       plot = makespan.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 1.0)


############################# throughput  ##################################


throughput.table["abb"] <- revalue(throughput.table$project, 
                                   c("splaynet" = "SplayNet", 
                                     "displaynet" = "DiSplayNet"))

throughput.table$abb <- factor(throughput.table$abb, levels = c("SplayNet", "DiSplayNet"))

throughput.table %>% filter(
  std %in% c(1.6)) -> throughput.table

throughput.table %>% filter(
  size %in% c(1024)) -> throughput.table

# Init Ggplot Base Plot
throughput.plot <- ggplot(throughput.table, aes(x = value, fill = abb)) +
  geom_density(aes(y = ..count..), alpha = 0.5) 

# Modify theme components -------------------------------------------
throughput.plot <- throughput.plot + theme(text = element_text(size = 20),
                                           plot.title = element_blank(),
                                           plot.subtitle = element_blank(),
                                           plot.caption = element_blank(),
                                           axis.title.x = element_text(size = 25),
                                           axis.title.y = element_text(size = 20),
                                           axis.text.x = element_text(size = 20),
                                           axis.text.y = element_text(size = 20),
                                           legend.text = element_text(size = 14),
                                           legend.title = element_blank(),
                                           legend.position = c(0.3, 0.3))

throughput.plot <- throughput.plot + theme(panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank()) +
  labs(x = expression(paste("Time (rounds)", 10^3)), y = "Requests completed (per round)") +
  scale_fill_manual(values = c(sn_color, dsn_color)) +
  scale_x_continuous(labels = function(x){paste0(x/1000)})

plot(throughput.plot)

IMG_height = 15
IMG_width = 15

ggsave(filename = "./plots/normal/throughput.pdf", units = "cm",
       plot = throughput.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 1.0)


############################# cluster ##################################


clusters.table["abb"] <- revalue(clusters.table$project, 
                                 c("splaynet" = "sn", 
                                   "displaynet" = "dsn"))

clusters.table$abb <- factor(clusters.table$abb, levels = c("sn", "dsn"))

clusters.table %>% filter(
  std %in% c(1.6)) -> clusters.table

clusters.table %>% filter(
  size %in% c(1024)) -> clusters.table

clusters.table %>% filter(
  abb %in% c("dsn")) -> clusters.table

# Init Ggplot Base Plot
clusters.plot <- ggplot(clusters.table, aes(x = value, fill = abb)) +
  geom_histogram(aes(y = ..count..), position = "dodge", binwidth = 1) +
  # Add mean line
  geom_vline(aes(xintercept=mean(value)), linetype="dashed")

# Modify theme components -------------------------------------------
clusters.plot <- clusters.plot + theme(text = element_text(size = 20),
                                       plot.title = element_blank(),
                                       plot.subtitle = element_blank(),
                                       plot.caption = element_blank(),
                                       axis.title.x = element_text(size = 25),
                                       axis.title.y = element_text(size = 20),
                                       axis.text.x = element_text(size = 20),
                                       axis.text.y = element_text(size = 12),
                                       legend.text = element_text(size = 12),
                                       legend.title = element_blank(),
                                       legend.position = c(0.1, 0.9),
                                       panel.grid.minor = element_blank(),
                                       panel.grid.major = element_blank())

clusters.plot <- clusters.plot + 
  labs(x = "#Clusters", y = expression(paste("#Rounds x", 10^4))) +
  scale_fill_manual(values = c(sn_color, dsn_color)) +
  scale_y_continuous(breaks = seq(0, 400000, 10000), labels = function(x){paste0(x/10000)})

plot(clusters.plot)

IMG_height = 15
IMG_width = 15

ggsave(filename = "./plots/normal/clusters.pdf", units = "cm",
       plot = clusters.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 1.0)
