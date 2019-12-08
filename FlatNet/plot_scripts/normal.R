#setwd("C:/Users/oaugusto/Desktop/Plots/CBNet")
setwd("/home/oaugusto/CBNet/PlotsScripts/CBNet")

################################## Libraries ###################################

library(ggplot2)
library(gridExtra)
library(tidyverse)
library(plyr)

# setup
options(scipen = 999)
theme_set(theme_bw())

############################# Reading tables  ##################################

total_work.table <- read.csv("./data/csv_data/normal/total_work.csv")
makespan.table <-read.csv("./data/csv_data/normal/total_time.csv")
clusters.table <-read.csv("./data/csv_data/normal/cluster.csv")
throughput.table <-read.csv("./data/csv_data/normal/throughput.csv")


############################# Define colors  ##################################

#COLORS
cbn_color = "#325387"
cbn1 = "#325387"
cbn2 = "#325387"

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
                                   c("cbnet" = "cbn",
                                     "splaynet" = "sn", 
                                     "displaynet" = "dsn",
                                     "optnet" = "opt",
                                     "simplenet" = "bt"))

total_work.table$abb <- factor(total_work.table$abb, levels = c("opt", "cbn", "sn", "dsn", "bt"))

total_work.table %>% filter(
  operation %in% c("rotation", "routing")) -> operations.table

total_work.table %>% filter(
  operation %in% c("total")) -> total.table

total.table$operation <- revalue(total.table$operation,
                                 c("total" = "rotation"))

# Init Ggplot Base Plot
total_work.plot <- ggplot(operations.table, aes(x = abb, y = mean, fill = operation)) +
  geom_bar(stat = "identity") +
  geom_errorbar(total.table, mapping = aes(x = abb, 
                                           ymin = mean - ((qnorm(0.975)*std)/sqrt(30)), 
                                           ymax = mean + ((qnorm(0.975)*std)/sqrt(30))),
                width=.2,                    # Width of the error bars
                position="identity",
                colour = "#000000") +
  facet_grid(size ~ std_par)


# Modify theme components -------------------------------------------
total_work.plot <- total_work.plot + theme(text = element_text(size = 20),
                                           plot.title = element_blank(),
                                           plot.subtitle = element_blank(),
                                           plot.caption = element_blank(),
                                           axis.title.x = element_blank(),
                                           axis.title.y = element_text(size = 25),
                                           axis.text.x = element_text(size = 12),
                                           axis.text.y = element_text(size = 20),
                                           legend.text = element_text(size = 12),
                                           legend.title = element_blank(),
                                           legend.position = c(0.1, 0.9))

total_work.plot <- total_work.plot + theme(panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank()) +
  labs(y = expression(paste("Work x", 10^{4}))) +
  scale_fill_manual(values = c("#555555","#999999")) +
  scale_y_continuous(breaks = seq(0, 200000, 20000), labels = function(x){paste0(x/10000)})

plot(total_work.plot)

IMG_height = 7
IMG_width = 15

ggsave(filename = "./plots/normal/total_work.pdf", units = "cm",
       plot = total_work.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 2.0)


############################# makespan  ##################################


makespan.table["abb"] <- revalue(makespan.table$project, 
                                 c("cbnet" = "cbn",
                                   "splaynet" = "sn", 
                                   "displaynet" = "dsn"))

makespan.table$abb <- factor(makespan.table$abb, levels = c("cbn", "sn", "dsn"))

makespan.table$size <- as.factor(makespan.table$size)

# Init Ggplot Base Plot
makespan.plot <- ggplot(makespan.table, aes(x = size, y = mean, group = abb, color = abb)) +
  geom_line(size = 1.5) +
  geom_point(aes(shape = abb), size=3, fill="white") +
  geom_errorbar(aes(ymin = mean - ((qnorm(0.975)*std)/sqrt(30)), 
                    ymax = mean + ((qnorm(0.975)*std)/sqrt(30)) ), 
                width=.2,
                position="identity") +
  facet_grid(. ~ std_par)

# Modify theme components -------------------------------------------
makespan.plot <- makespan.plot + theme(text = element_text(size = 20),
                                       plot.title = element_blank(),
                                       plot.subtitle = element_blank(),
                                       plot.caption = element_blank(),
                                       axis.title.x = element_text(size = 25),
                                       axis.title.y = element_text(size = 25),
                                       axis.text.x = element_text(size = 20),
                                       axis.text.y = element_text(size = 20),
                                       legend.text = element_text(size = 16),
                                       legend.title = element_blank(),
                                       legend.position = c(0.1, 0.85))

makespan.plot <- makespan.plot + theme(panel.grid.minor = element_blank(),
                                       panel.grid.major = element_blank()) +
  labs(x = "#Nodes", y = expression(paste("#Rounds x ", 10^{4}))) +
  scale_color_manual(values = c(cbn_color, sn_color, dsn_color)) +
  scale_y_continuous(labels = function(x){paste0(x/10000)})

plot(makespan.plot)

IMG_height = 7
IMG_width = 15

ggsave(filename = "./plots/normal/makespan.pdf", units = "cm",
       plot = makespan.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 2.0)


############################# throughput  ##################################


throughput.table["abb"] <- revalue(throughput.table$project, 
                                   c("cbnet" = "cbn",
                                     "splaynet" = "sn", 
                                     "displaynet" = "dsn"))

throughput.table$abb <- factor(throughput.table$abb, levels = c("cbn", "sn", "dsn"))

# Init Ggplot Base Plot
throughput.plot <- ggplot(throughput.table, aes(x = value, fill = abb)) +
  geom_density(aes(y = ..count..), alpha = 0.5) +
  facet_grid(size ~ std)

# Modify theme components -------------------------------------------
throughput.plot <- throughput.plot + theme(text = element_text(size = 20),
                                           plot.title = element_blank(),
                                           plot.subtitle = element_blank(),
                                           plot.caption = element_blank(),
                                           axis.title.x = element_text(size = 25),
                                           axis.title.y = element_text(size = 20),
                                           axis.text.x = element_text(size = 20),
                                           axis.text.y = element_text(size = 20),
                                           legend.text = element_text(size = 12),
                                           legend.title = element_blank(),
                                           legend.position = c(0.15, 0.8))

throughput.plot <- throughput.plot + theme(panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank()) +
  labs(x = expression(paste("Time (rounds)", 10^3)), y = "Requests completed (per round)") +
  scale_fill_manual(values = c(cbn_color, sn_color, dsn_color)) +
  scale_x_continuous(labels = function(x){paste0(x/1000)})

plot(throughput.plot)

IMG_height = 7
IMG_width = 15

ggsave(filename = "./plots/normal/throughput.pdf", units = "cm",
       plot = throughput.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 2.0)


############################# cluster ##################################


clusters.table["abb"] <- revalue(clusters.table$project, 
                                 c("cbnet" = "cbn",
                                   "splaynet" = "sn", 
                                   "displaynet" = "dsn"))

clusters.table$abb <- factor(clusters.table$abb, levels = c("cbn", "sn", "dsn"))

# Init Ggplot Base Plot
clusters.plot <- ggplot(clusters.table, aes(x = value, fill = abb)) +
  geom_histogram(aes(y = ..count..), position = "dodge", binwidth = 1) +
  # Add mean line
  geom_vline(aes(xintercept=mean(value)), linetype="dashed") +
  facet_grid( size ~ std)

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
                                       legend.position = c(0.15, 0.82),
                                       panel.grid.minor = element_blank(),
                                       panel.grid.major = element_blank())

clusters.plot <- clusters.plot + 
  labs(x = "#Clusters", y = expression(paste("#Rounds x", 10^4))) +
  scale_fill_manual(values = c(cbn_color, sn_color, dsn_color)) +
  scale_y_continuous(breaks = seq(0, 400000, 10000), labels = function(x){paste0(x/10000)})

plot(clusters.plot)

IMG_height = 7
IMG_width = 15

ggsave(filename = "./plots/normal/clusters.pdf", units = "cm",
       plot = clusters.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 2.0)
