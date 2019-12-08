#setwd("C:/Users/oaugusto/Desktop/Plots/FlatNet")
setwd("/home/oaugusto/CBNet/PlotsScripts/FlatNet")

################################## Libraries ###################################

library(ggplot2)
library(gridExtra)
library(tidyverse)
library(plyr)

# setup
options(scipen = 999)
theme_set(theme_bw())

############################# Reading tables  ##################################

total_work.table <- read.csv("./csv_data/facebook_pfab/total_work.csv")
makespan.table <-read.csv("./csv_data/facebook_pfab/total_time.csv")
clusters.table <-read.csv("./csv_data/facebook_pfab/cluster.csv")
throughput.table <-read.csv("./csv_data/facebook_pfab/throughput.csv")


############################# Define colors  ##################################

#COLORS
ftng_color = "#ab8418"
ftng1 = "#ab8418"
ftng2 = "#ab8418"

fn_color = "#325387"
fn1 = "#325387"
fn2 = "#325387"

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
                                   c("flattening" = "ftng",
                                     "flatnet" = "fn",
                                     "splaynet" = "sn", 
                                     "displaynet" = "dsn",
                                     "optnet" = "opt",
                                     "simplenet" = "bt"))

total_work.table$abb <- factor(total_work.table$abb, levels = c("opt", "ftng", "fn", "sn", "dsn", "bt"))


total_work.table %>% filter(
  operation %in% c("rotation", "routing")) -> operations.table

total_work.table %>% filter(
  operation %in% c("total")) -> total.table


# Init Ggplot Base Plot
total_work.plot <- ggplot(operations.table, aes(x = abb, y = value, fill = operation)) +
  geom_bar(position = "stack", stat = "identity") +
  facet_grid(. ~ dataset)


# Modify theme components -------------------------------------------
total_work.plot <- total_work.plot + theme(text = element_text(size = 20),
                                           plot.title = element_blank(),
                                           plot.subtitle = element_blank(),
                                           plot.caption = element_blank(),
                                           axis.title.x = element_blank(),
                                           axis.title.y = element_text(size = 25),
                                           axis.text.x = element_text(size = 15),
                                           axis.text.y = element_text(size = 20),
                                           legend.text = element_text(size = 14),
                                           legend.title = element_blank(),
                                           legend.position = c(0.85, 0.8))

total_work.plot <- total_work.plot + theme(panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank()) +
  labs(y = expression(paste("Work x", 10^{6}))) +
  scale_fill_manual(values = c("#555555","#999999")) +
  scale_y_continuous(breaks = seq(0, 15000000, 2500000), labels = function(x){paste0(x/1000000)})

plot(total_work.plot)

IMG_height = 2.5
IMG_width = 7

ggsave(filename = "./plots/facebook_pfab/total_work.pdf", units = "cm",
       plot = total_work.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 4.0)


############################# makespan  ##################################


makespan.table["abb"] <- revalue(makespan.table$project, 
                                 c("flattening" = "ftng",
                                   "flatnet" = "fn",
                                   "splaynet" = "sn", 
                                   "displaynet" = "dsn"))

makespan.table$abb <- factor(makespan.table$abb, levels = c("ftng", "fn", "sn", "dsn"))

# Init Ggplot Base Plot
makespan.plot <- ggplot(makespan.table, aes(x = abb, y = value, color = abb)) +
  geom_boxplot(size = 1.5) +
  facet_grid(. ~ dataset)

# Modify theme components -------------------------------------------
makespan.plot <- makespan.plot + theme(text = element_text(size = 20),
                                       plot.title = element_blank(),
                                       plot.subtitle = element_blank(),
                                       plot.caption = element_blank(),
                                       axis.title.x = element_blank(),
                                       axis.title.y = element_text(size = 25),
                                       axis.text.x = element_text(size = 20),
                                       axis.text.y = element_text(size = 20),
                                       legend.title = element_blank(),
                                       legend.position = c(0.85, 0.75))

makespan.plot <- makespan.plot + theme(panel.grid.minor = element_blank(),
                                       panel.grid.major = element_blank()) +
  labs(y = expression(paste("#Rounds x ", 10^{5}))) +
  scale_color_manual(values = c(ftng_color, fn_color, sn_color, dsn_color)) +
  scale_y_continuous(labels = function(x){paste0(x/100000)})

plot(makespan.plot)

IMG_height = 2.5
IMG_width = 7

ggsave(filename = "./plots/facebook_pfab/makespan.pdf", units = "cm",
       plot = makespan.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 4.0)


############################# throughput  ##################################


throughput.table["abb"] <- revalue(throughput.table$project, 
                                   c("flattening" = "ftng",
                                     "flatnet" = "fn",
                                     "splaynet" = "sn", 
                                     "displaynet" = "dsn"))

throughput.table$abb <- factor(throughput.table$abb, levels = c("ftng", "fn", "sn", "dsn"))

# Init Ggplot Base Plot
throughput.plot <- ggplot(throughput.table, aes(x = value, fill = abb)) +
  geom_density(aes(y = ..count..), alpha = 0.5) +
  facet_grid(. ~ dataset)

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
                                           legend.position = c(0.2, 0.75))

throughput.plot <- throughput.plot + theme(panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank()) +
  labs(x = expression(paste("Time (rounds)", 10^6)), y = "Requests completed (per round)") +
  scale_fill_manual(values = c(ftng_color, fn_color, sn_color, dsn_color)) +
  scale_x_continuous(labels = function(x){paste0(x/1000000)})

plot(throughput.plot)

IMG_height = 2.5
IMG_width = 7

ggsave(filename = "./plots/facebook_pfab/throughput.pdf", units = "cm",
       plot = throughput.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 4.0)


############################# cluster ##################################


clusters.table["abb"] <- revalue(clusters.table$project, 
                                 c("flattening" = "ftng",
                                   "flatnet" = "fn",
                                   "splaynet" = "sn", 
                                   "displaynet" = "dsn"))

clusters.table$abb <- factor(clusters.table$abb, levels = c("ftng", "fn", "sn", "dsn"))

# Init Ggplot Base Plot
clusters.plot <- ggplot(clusters.table, aes(x = value, fill = abb)) +
  geom_histogram(aes(y = ..count..), position = "dodge", binwidth = 1) +
  # Add mean line
  geom_vline(aes(xintercept=mean(value)), linetype="dashed") +
  facet_grid(. ~ dataset)

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
                                       legend.position = c(0.8, 0.8),
                                       panel.grid.minor = element_blank(),
                                       panel.grid.major = element_blank())

clusters.plot <- clusters.plot + 
  labs(x = "#Clusters", y = expression(paste("#Rounds x", 10^4))) +
  scale_fill_manual(values = c(ftng_color, fn_color, sn_color, dsn_color)) +
  scale_y_continuous(labels = function(x){paste0(x/10000)})

plot(clusters.plot)

IMG_height = 7
IMG_width = 15

ggsave(filename = "./plots/facebook_pfab/clusters.pdf", units = "cm",
       plot = clusters.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 2.0)
