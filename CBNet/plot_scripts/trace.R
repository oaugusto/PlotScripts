#setwd("C:/Users/oaugusto/Desktop/Plots/CBNet")
setwd("/home/oaugusto/CBNet/PlotsScripts/CBNet")

################################## Libraries ###################################

library(ggplot2)
library(gridExtra)
library(tidyverse)
library(plyr)
library(grid)
library(ggrepel)
library(RColorBrewer)

# setup
options(scipen = 999)

############################# Reading tables  ##################################

trace.table <- read.csv("./trace_table.csv")

trace.plot <- ggplot(trace.table, aes(x = x, y = y, label = dataset)) +
  geom_point(aes(size = x * y, color = dataset), alpha =0.95)  +
  geom_label_repel(
    data = subset(trace.table, y < 0.7),
    nudge_x = -0.2,
    nudge_y = -0.1,
    segment.size = 0.2,
    direction = "y",
    force = 1,
    size = 3
  ) +
  geom_label_repel(
    data = subset(trace.table, y > 0.7, x > 0.8),
    nudge_x = -0.1,
    nudge_y = -0.1,
    segment.size = 0.2,
    direction = "y",
    force = 1,
    size = 3
  )

trace.plot <- trace.plot +
  labs(y = "Non-temporal complexity", x = "Temporal complexity") +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.1)) +
  scale_x_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.1)) +
  scale_size(range = c(1, 20)) +
  coord_fixed(expand = TRUE) +
  guides(size = FALSE, color = FALSE) +
  scale_color_hue(l = 40, c = 35) +
  theme_light()


plot(trace.plot)

IMG_height = 12
IMG_width = 12

ggsave(filename = "./plots/trace-map.png", units = "cm",
       plot = trace.plot, device = "png",  width = IMG_width, height = IMG_height, scale = 1)

