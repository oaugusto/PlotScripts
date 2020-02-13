#setwd("C:/Users/oaugusto/Desktop/PlotScripts/ToN-bursty")
setwd("/home/oaugusto/Master/PlotsScripts/CBNet")

################################## Libraries ###################################

library(ggplot2)
library(gridExtra)
library(tidyverse)
library(plyr)

# setup
options(scipen = 999)
theme_set(theme_bw())

############################# Reading tables  ##################################

total_work.table.bursty <- read.csv("./csv_data/bursty/total_work.csv")
total_work.table.skewed <- read.csv("./csv_data/skewed/total_work.csv")

############################# Define colors  ##################################

#COLORS
cbn_color = "#325387"
cbn1 = "#325387"
cbn2 = "#325387"

scbn_color = "#6C5B7B"
scbn1 = "#6C5B7B"
scbn2 = "#6C5B7B"

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

############################# Define imgs paremeters ######################

scale_imgs <- 1

IMG_height = 15
IMG_width = 20

text_size <- 30
x_title_size <- 25
y_title_size <- 25
x_text_size <- 25
y_text_size <- 25

num_sim <- 10

############################# total work ##################################

total_work.table.bursty$mean[total_work.table.bursty$operation == "rotation"] <- total_work.table.bursty$mean[total_work.table.bursty$operation == "rotation"] * 10

total_work.table.bursty["abb"] <- revalue(total_work.table.bursty$project, 
                                   c("cbnet" = "CBN",
                                     "seqcbnet" = "SCBN",
                                     "splaynet" = "SN", 
                                     "displaynet" = "DSN",
                                     "optnet" = "OPT",
                                     "simplenet" = "BT"))

total_work.table.bursty$abb <- factor(total_work.table.bursty$abb, levels = c("OPT", "SCBN", "CBN", "SN", "DSN", "BT"))

total_work.table.bursty["operation"] <- revalue(total_work.table.bursty$operation, c("rotation" = "Rotation",
                                                                       "routing" = "Routing"))
total_work.table.bursty %>% filter(
  size %in% c(1024)) -> total_work.table.bursty

total_work.table.bursty %>% filter(
  operation %in% c("Rotation", "Routing")) -> operations.table.bursty

total_work.table.bursty %>% filter(
  operation %in% c("total")) -> total.table.bursty

total.table.bursty$operation <- revalue(total.table.bursty$operation,
                                 c("total" = "Rotation"))

# Init Ggplot Base Plot
total_work.plot <- ggplot(operations.table.bursty, aes(x = abb, y = mean, fill = operation)) +#, col = abb)) +
  geom_bar(position = "stack", stat = "identity", alpha = 0.8)


# Modify theme components -------------------------------------------
total_work.plot <- total_work.plot + theme(text = element_text(size = text_size),
                                           plot.title = element_blank(),
                                           plot.subtitle = element_blank(),
                                           plot.caption = element_blank(),
                                           axis.title.x = element_blank(),
                                           axis.title.y = element_text(size = y_title_size),
                                           axis.text.x = element_text(size = x_text_size),
                                           axis.text.y = element_text(size = y_text_size),
                                           legend.title = element_blank(),
                                           legend.position = c(0.2, 0.9))

total_work.plot <- total_work.plot + theme(panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank()) +
  labs(y = expression(paste("Work x", 10^{4}))) +
  scale_color_manual(values = c(opt_color, scbn_color, cbn_color, sn_color, dsn_color, bt_color)) +
  scale_fill_manual(values = c("#2A363B","#A8A7A7")) +
  scale_y_continuous(lim = c(0, 800000), breaks = seq(0, 800000, 100000), labels = function(x){paste0(x/10000)}) 

plot(total_work.plot)

ggsave(filename = "./plots/bursty/new_work.png", units = "cm",
       plot = total_work.plot, device = "png",  width = IMG_width, height = IMG_height, scale = scale_imgs)

############################# total work ##################################

total_work.table.skewed$mean[total_work.table.skewed$operation == "rotation"] <- total_work.table.skewed$mean[total_work.table.skewed$operation == "rotation"] * 10

total_work.table.skewed["abb"] <- revalue(total_work.table.skewed$project, 
                                          c("cbnet" = "CBN",
                                            "seqcbnet" = "SCBN",
                                            "splaynet" = "SN", 
                                            "displaynet" = "DSN",
                                            "optnet" = "OPT",
                                            "simplenet" = "BT"))

total_work.table.skewed$abb <- factor(total_work.table.skewed$abb, levels = c("OPT", "SCBN", "CBN", "SN", "DSN", "BT"))

total_work.table.skewed["operation"] <- revalue(total_work.table.skewed$operation, c("rotation" = "Rotation",
                                                                                     "routing" = "Routing"))
total_work.table.skewed %>% filter(
  size %in% c(1024)) -> total_work.table.skewed

total_work.table.skewed %>% filter(
  operation %in% c("Rotation", "Routing")) -> operations.table.skewed

total_work.table.skewed %>% filter(
  operation %in% c("total")) -> total.table.skewed

total.table.skewed$operation <- revalue(total.table.skewed$operation,
                                        c("total" = "Rotation"))

# Init Ggplot Base Plot
total_work.plot <- ggplot(operations.table.skewed, aes(x = abb, y = mean, fill = operation)) +#, col = abb)) +
  geom_bar(position = "stack", stat = "identity", alpha = 0.8)


# Modify theme components -------------------------------------------
total_work.plot <- total_work.plot + theme(text = element_text(size = text_size),
                                           plot.title = element_blank(),
                                           plot.subtitle = element_blank(),
                                           plot.caption = element_blank(),
                                           axis.title.x = element_blank(),
                                           axis.title.y = element_text(size = y_title_size),
                                           axis.text.x = element_text(size = x_text_size),
                                           axis.text.y = element_text(size = y_text_size),
                                           legend.title = element_blank(),
                                           legend.position = c(0.2, 0.9))

total_work.plot <- total_work.plot + theme(panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank()) +
  labs(y = expression(paste("Work x", 10^{4}))) +
  scale_color_manual(values = c(opt_color, scbn_color, cbn_color, sn_color, dsn_color, bt_color)) +
  scale_fill_manual(values = c("#2A363B","#A8A7A7")) +
  scale_y_continuous(lim = c(0, 1200000), breaks = seq(0, 1200000, 100000), labels = function(x){paste0(x/10000)}) 

plot(total_work.plot)

ggsave(filename = "./plots/skewed/new_work.png", units = "cm",
       plot = total_work.plot, device = "png",  width = IMG_width, height = IMG_height, scale = scale_imgs)
