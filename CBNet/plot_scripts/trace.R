#setwd("C:/Users/oaugusto/Desktop/Plots/CBNet")
setwd("/home/oaugusto/Master/PlotsScripts/CBNet")

################################## Libraries ###################################

library(ggplot2)
library(gridExtra)
library(tidyverse)
library(plyr)
library(grid)
library(ggrepel)
library(ggforce)
library(RColorBrewer)

# setup
options(scipen = 999)

############################# Reading tables  ##################################

trace.table <- read.csv("./trace_table.csv")

trace.plot <- ggplot(trace.table, aes(x = x, y = y, label = dataset)) +
  geom_point(aes(size = x * y, fill = dataset), alpha =0.95, colour = "black", pch=21)  +
  geom_mark_ellipse(aes(filter = type == 'HPC', label = 'HPC')) +
  geom_mark_ellipse(aes(filter = type == 'PFabric', label = 'PFabric')) +
  geom_label_repel(
    data = subset(trace.table, type == "Bursty"),
    nudge_x = -0.08,
    nudge_y = -0.08,
    segment.size = 0.2,
    direction = "y",
    force = 1,
    size = 6
  ) +
  geom_label_repel(
    data = subset(trace.table, type == "ProjecToR"),
    nudge_x = -0.2 * 0.5,
    nudge_y = -0.08 * 0.5,
    segment.size = 0.2,
    direction = "y",
    force = 1,
    size = 6
  ) +
  geom_label_repel(
    data = subset(trace.table, type == "Skewed"),
    nudge_x = -0.08,
    nudge_y = -0.08,
    segment.size = 0.2,
    direction = "y",
    force = 1,
    size = 6
  ) +
  geom_label_repel(
    data = subset(trace.table, type == "Facebook"),
    nudge_x = -0.1,
    nudge_y = -0.0,
    segment.size = 0.2,
    direction = "y",
    force = 1,
    size = 6
  ) +
  geom_label_repel(
    data = subset(trace.table, type == "SplayTree"),
    nudge_x = -0.08,
    nudge_y = -0.08,
    segment.size = 0.2,
    direction = "y",
    force = 1,
    size = 6
  ) +
  geom_label_repel(
    data = subset(trace.table, type == "HPC"),
    nudge_x = -0.1,
    nudge_y = -0.04,
    segment.size = 0.2,
    direction = "y",
    force = 1,
    size = 6
  ) +
  geom_label_repel(
    data = subset(trace.table, type == "PFabric"),
    nudge_x = 0.2 * 0.5,
    nudge_y = -0.045 * 0.5,
    segment.size = 0.2,
    direction = "y",
    force = 1,
    size = 6
  ) 

trace.plot <- trace.plot +
  labs(y = "Non-temporal complexity", x = "Temporal complexity") +
  scale_y_continuous(limits = c(0.3, 1), breaks = seq(0, 1, 0.1)) +
  scale_x_continuous(limits = c(0.3, 1), breaks = seq(0, 1, 0.1)) +
  scale_size(range = c(1, 40)) +
  coord_fixed(expand = TRUE) +
  guides(size = FALSE, fill = FALSE) +
  scale_fill_hue(l = 40, c = 35) +
  theme(axis.title.x = element_text(size = 25),
        axis.title.y = element_text(size = 25),
        axis.text.x = element_text(size = 20, color = "black"),
        axis.text.y = element_text(size = 20, color = "black"))


plot(trace.plot)

IMG_height = 20
IMG_width = 20

ggsave(filename = "./plots/trace-map.png", units = "cm",
       plot = trace.plot, device = "png",  width = IMG_width, height = IMG_height, scale = 1)

