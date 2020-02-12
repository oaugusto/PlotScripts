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

scale_imgs <- 1.1

############################# Reading tables  ##################################

total_work.table <- read.csv("./csv_data/skewed/total_work.csv")
makespan.table <- read.csv("./csv_data/skewed/total_time.csv")
clusters.table <- read.csv("./csv_data/skewed/cluster.csv")
throughput.table <- read.csv("./csv_data/skewed/throughput.csv")

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

total_work.table["abb"] <- revalue(total_work.table$project, 
                                   c("cbnet" = "CBN",
                                     "seqcbnet" = "SCBN",
                                     "splaynet" = "SN", 
                                     "displaynet" = "DSN",
                                     "optnet" = "OPT",
                                     "simplenet" = "BT"))

total_work.table$abb <- factor(total_work.table$abb, levels = c("OPT", "SCBN", "CBN", "SN", "DSN", "BT"))

total_work.table["operation"] <- revalue(total_work.table$operation, c("rotation" = "Rotation",
                                                                       "routing" = "Routing"))
total_work.table %>% filter(
  size %in% c(1024)) -> total_work.table

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
                colour = "#000000") #+
#facet_grid(. ~ size)#, scales = 'free', space = 'free', nrow = 2)


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
                                           legend.position = c(0.15, 0.9))

total_work.plot <- total_work.plot + theme(panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank()) +
  labs(y = expression(paste("Work x", 10^{4}))) +
  scale_color_manual(values = c(opt_color, scbn_color, cbn_color, sn_color, dsn_color, bt_color)) +
  scale_fill_manual(values = c("#2A363B","#A8A7A7")) +
  scale_y_continuous(breaks = seq(0, 200000, 20000), labels = function(x){paste0(x/10000)}) #+
#guides(color = FALSE)

#ann_text <- data.frame(mean = 150000,lab = "Text",
#                       cyl = factor(128,levels = c("128","256","512", "1024")))

#total_work.plot <- total_work.plot +  geom_text(data = ann_text,label = "Text")

# Create a text
#grob <- grobTree(textGrob("OPT: StaticOPT\nCBN: CBNet\nSN: SplayNet\nDSN: DiSplayNet\nBT: Balanced Tree", 
#                          x=0.65,  y=0.8, hjust=0,
#                          gp=gpar(col="black", fontsize=14),
#                          draw = c(TRUE, FALSE, FALSE, FALSE)))

#total_work.plot <- total_work.plot + annotation_custom(grob)

plot(total_work.plot)

ggsave(filename = "./plots/skewed/total_work.png", units = "cm",
       plot = total_work.plot, device = "png",  width = IMG_width, height = IMG_height, scale = scale_imgs)


############################# makespan 1 ##################################


makespan.table["abb"] <- revalue(makespan.table$project, 
                                 c("cbnet" = "CBN",
                                   "seqcbnet" = "SCBN",
                                   "splaynet" = "SN", 
                                   "displaynet" = "DSN"))

makespan.table$abb <- factor(makespan.table$abb, levels = c("CBN", "SCBN", "DSN", "SN"))

makespan.table$size <- as.factor(makespan.table$size)

# Init Ggplot Base Plot
makespan.plot <- ggplot(makespan.table, aes(x = abb, y = mean, fill = abb)) +
  geom_bar(stat = "identity", position=position_dodge(), alpha = 0.8) +
  geom_errorbar(aes(ymin = mean - ((qnorm(0.975)*std)/sqrt(num_sim)), 
                    ymax = mean + ((qnorm(0.975)*std)/sqrt(num_sim)) ), 
                width=.2) +
  facet_grid(. ~ size)

# Modify theme components -------------------------------------------
makespan.plot <- makespan.plot + theme(text = element_text(size = 25),
                                       plot.title = element_blank(),
                                       plot.subtitle = element_blank(),
                                       plot.caption = element_blank(),
                                       axis.title.x = element_blank(),
                                       axis.title.y = element_text(size = 25),
                                       axis.text.x = element_text(size = 20),
                                       axis.text.y = element_text(size = 20),
                                       legend.text = element_text(size = 20),
                                       legend.title = element_blank(),
                                       legend.position = c(0.05, 0.83))

makespan.plot <- makespan.plot + theme(panel.grid.minor = element_blank(),
                                       panel.grid.major = element_blank()) +
  labs(x = "n", y = expression(paste("#Rounds x ", 10^{4}))) +
  scale_color_manual(values = c(cbn_color, scbn_color, dsn_color, sn_color)) +
  scale_fill_manual(values = c(cbn_color, scbn_color, dsn_color, sn_color)) +
  scale_y_continuous(limits = c(0, 90000), breaks = seq(0, 90000, 10000), labels = function(x){paste0(x/10000)}) +
  guides(color = guide_legend(override.aes = list(size = 5)))

plot(makespan.plot)

ggsave(filename = "./plots/skewed/makespan.png", units = "cm",
       plot = makespan.plot, device = "png",  width = IMG_width, height = IMG_height, scale = scale_imgs)


############################# throughput  ##################################


throughput.table["abb"] <- revalue(throughput.table$project, 
                                   c("cbnet" = "CBN",
                                     "seqcbnet" = "SCBN",
                                     "splaynet" = "SN", 
                                     "displaynet" = "DSN"))

throughput.table$abb <- factor(throughput.table$abb, levels = c("SCBN", "CBN", "SN", "DSN"))


throughput.table %>% filter(
  size %in% c(1024)) -> throughput.table

# Init Ggplot Base Plot
throughput.plot <- ggplot(throughput.table, aes(x = value, fill = abb)) +
  geom_density(aes(y = ..count..), alpha = 0.5) 

# Modify theme components -------------------------------------------
throughput.plot <- throughput.plot + theme(text = element_text(size = text_size),
                                           plot.title = element_blank(),
                                           plot.subtitle = element_blank(),
                                           plot.caption = element_blank(),
                                           axis.title.x = element_text(size = x_title_size),
                                           axis.title.y = element_text(size = y_title_size),
                                           axis.text.x = element_text(size = x_text_size),
                                           axis.text.y = element_text(size = y_text_size),
                                           legend.text = element_text(size = text_size),
                                           legend.title = element_blank(),
                                           legend.position = c(0.85, 0.7)) #+
#facet_grid(. ~ size)

throughput.plot <- throughput.plot + theme(panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank()) +
  labs(x = expression(paste("Time (rounds)", 10^4)), y = "Requests completed per round") +
  scale_fill_manual(values = c(scbn_color, cbn_color, sn_color, dsn_color)) +
  scale_y_continuous(breaks = seq(0, 5, 0.1)) +
  scale_x_continuous(labels = function(x){paste0(x/10000)})

plot(throughput.plot)

ggsave(filename = "./plots/skewed/throughput.png", units = "cm",
       plot = throughput.plot, device = "png",  width = IMG_width, height = IMG_height, scale = scale_imgs)


############################# cluster ##################################


clusters.table["abb"] <- revalue(clusters.table$project, 
                                 c("cbnet" = "CBN",
                                   "seqcbnet" = "SCBN",
                                   "splaynet" = "SN", 
                                   "displaynet" = "DSN"))

clusters.table$abb <- factor(clusters.table$abb, levels = c("SCBN", "CBN", "SN", "DSN"))

clusters.table %>% filter(
  size %in% c(1024)) -> clusters.table

clusters.table %>% filter(
  abb %in% c("CBN")) -> clusters.table

# Init Ggplot Base Plot
clusters.plot <- ggplot(clusters.table, aes(x = value, fill = abb)) +
  geom_histogram(aes(y = ..count..), position = "dodge", binwidth = 1, alpha = 0.5, col = "#000000") #+
#facet_grid(. ~ size)
# Add mean line
#geom_vline(aes(xintercept=mean(value)), linetype="dashed")

# Modify theme components -------------------------------------------
clusters.plot <- clusters.plot + theme(text = element_text(size = text_size),
                                       plot.title = element_blank(),
                                       plot.subtitle = element_blank(),
                                       plot.caption = element_blank(),
                                       axis.title.x = element_text(size = x_title_size),
                                       axis.title.y = element_text(size = y_title_size),
                                       axis.text.x = element_text(size = x_text_size),
                                       axis.text.y = element_text(size = y_text_size),
                                       legend.title = element_blank(),
                                       legend.position = "none",
                                       panel.grid.minor = element_blank(),
                                       panel.grid.major = element_blank())

clusters.plot <- clusters.plot + 
  labs(x = "#Clusters", y = expression(paste("#Rounds x", 10^3))) +
  scale_fill_manual(values = c(sn_color, dsn_color)) +
  scale_y_continuous(lim = c(0, 15000), breaks = seq(0, 15000, 2000), labels = function(x){paste0(x/1000)}) #+
#coord_cartesian(xlim = c(0, 10))

plot(clusters.plot)

ggsave(filename = "./plots/skewed/clusters.png", units = "cm",
       plot = clusters.plot, device = "png",  width = IMG_width, height = IMG_height, scale = scale_imgs)