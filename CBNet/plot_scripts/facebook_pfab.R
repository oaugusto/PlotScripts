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

total_work.table <- read.csv("./csv_data/facebook_pfab/total_work.csv")
makespan.table <- read.csv("./csv_data/facebook_pfab/total_time.csv")
clusters.table <- read.csv("./csv_data/facebook_pfab/cluster.csv")
throughput.table <- read.csv("./csv_data/facebook_pfab/throughput.csv")


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
                                   c("cbnet" = "CBN",
                                     "splaynet" = "SN", 
                                     "displaynet" = "DSN",
                                     "optnet" = "OPT",
                                     "simplenet" = "BT"))

total_work.table$abb <- factor(total_work.table$abb, levels = c("OPT", "CBN", "SN", "DSN", "BT"))

total_work.table["operation"] <- revalue(total_work.table$operation, c("rotation" = "Rotation",
                                                                       "routing" = "Routing"))

total_work.table %>% filter(
  operation %in% c("Rotation", "Routing")) -> operations.table


# Init Ggplot Base Plot
total_work.plot <- ggplot(operations.table, aes(x = abb, y = value, fill = operation)) +#, col = abb)) +
  geom_bar(position = "stack", stat = "identity", alpha = 0.8) +
  facet_grid(. ~ dataset)#, scales = 'free', space = 'free', nrow = 2)


# Modify theme components -------------------------------------------
total_work.plot <- total_work.plot + theme(text = element_text(size = 20),
                                           plot.title = element_blank(),
                                           plot.subtitle = element_blank(),
                                           plot.caption = element_blank(),
                                           axis.title.x = element_blank(),
                                           axis.title.y = element_text(size = 25),
                                           axis.text.x = element_text(size = 20),
                                           axis.text.y = element_text(size = 20),
                                           legend.title = element_blank(),
                                           legend.position = c(0.05, 0.85))

total_work.plot <- total_work.plot + theme(panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank()) +
  labs(y = expression(paste("Work x", 10^{6}))) +
  scale_color_manual(values = c(opt_color, cbn_color, sn_color, dsn_color, bt_color)) +
  scale_fill_manual(values = c("#2A363B","#A8A7A7")) +
  scale_y_continuous(breaks = seq(0, 15000000, 1000000), labels = function(x){paste0(x/1000000)}) #+
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

IMG_height = 15
IMG_width = 40

ggsave(filename = "./plots/facebook_pfab/total_work.pdf", units = "cm",
       plot = total_work.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 1.0)


############################# makespan 1 ##################################


makespan.table["abb"] <- revalue(makespan.table$project, 
                                 c("cbnet" = "CBN",
                                   "splaynet" = "SN", 
                                   "displaynet" = "DSN"))

makespan.table$abb <- factor(makespan.table$abb, levels = c("CBN", "DSN", "SN"))

# Init Ggplot Base Plot
makespan.plot <- ggplot(makespan.table, aes(x = abb, y = value, fill = abb)) +
  geom_bar(stat = "identity", position=position_dodge(), alpha = 0.8) +
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
                                       legend.text = element_text(size = 20),
                                       legend.title = element_blank(),
                                       legend.position = "none")#c(0.05, 0.85))

makespan.plot <- makespan.plot + theme(panel.grid.minor = element_blank(),
                                       panel.grid.major = element_blank()) +
  labs(x = "n", y = expression(paste("#Rounds x ", 10^{6}))) +
  scale_color_manual(values = c(cbn_color, dsn_color, sn_color)) +
  scale_fill_manual(values = c(cbn_color, dsn_color, sn_color)) +
  scale_y_continuous(limits = c(0, 8000000), breaks = seq(0, 8000000, 1000000), labels = function(x){paste0(x/1000000)}) +
  guides(color = guide_legend(override.aes = list(size = 5)))

plot(makespan.plot)

IMG_height = 15
IMG_width = 40

ggsave(filename = "./plots/facebook_pfab/makespan.pdf", units = "cm",
       plot = makespan.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 1.0)


############################# throughput  ##################################


throughput.table["abb"] <- revalue(throughput.table$project, 
                                   c("cbnet" = "CBN",
                                     "splaynet" = "SN", 
                                     "displaynet" = "DSN"))

throughput.table$abb <- factor(throughput.table$abb, levels = c("CBN", "SN", "DSN"))


# Init Ggplot Base Plot
throughput.plot <- ggplot(throughput.table, aes(x = value, fill = abb)) +
  geom_density(aes(y = ..count..), alpha = 0.5) 

# Modify theme components -------------------------------------------
throughput.plot <- throughput.plot + theme(text = element_text(size = 20),
                                           plot.title = element_blank(),
                                           plot.subtitle = element_blank(),
                                           plot.caption = element_blank(),
                                           axis.title.x = element_text(size = 25),
                                           axis.title.y = element_text(size = 25),
                                           axis.text.x = element_text(size = 20),
                                           axis.text.y = element_text(size = 20),
                                           legend.text = element_text(size = 20),
                                           legend.title = element_blank(),
                                           legend.position = c(0.95, 0.8)) +
  facet_grid(. ~ dataset)

throughput.plot <- throughput.plot + theme(panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank()) +
  labs(x = expression(paste("Time (rounds)", 10^3)), y = "Requests completed per round") +
  scale_fill_manual(values = c(cbn_color, sn_color, dsn_color)) +
  scale_x_continuous(labels = function(x){paste0(x/1000)})

plot(throughput.plot)

IMG_height = 15
IMG_width = 40

ggsave(filename = "./plots/facebook_pfab/throughput.pdf", units = "cm",
       plot = throughput.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 1.0)


############################# cluster ##################################


clusters.table["abb"] <- revalue(clusters.table$project, 
                                 c("cbnet" = "CBN",
                                   "splaynet" = "SN", 
                                   "displaynet" = "DSN"))

clusters.table$abb <- factor(clusters.table$abb, levels = c("CBN", "SN", "DSN"))

clusters.table %>% filter(
  abb %in% c("CBN")) -> clusters.table

# Init Ggplot Base Plot
clusters.plot <- ggplot(clusters.table, aes(x = value, fill = abb)) +
  geom_histogram(aes(y = ..count..), position = "dodge", binwidth = 1, alpha = 0.5, col = "#000000") +
  facet_grid(. ~ dataset)
# Add mean line
#geom_vline(aes(xintercept=mean(value)), linetype="dashed")

# Modify theme components -------------------------------------------
clusters.plot <- clusters.plot + theme(text = element_text(size = 20),
                                       plot.title = element_blank(),
                                       plot.subtitle = element_blank(),
                                       plot.caption = element_blank(),
                                       axis.title.x = element_text(size = 25),
                                       axis.title.y = element_text(size = 25),
                                       axis.text.x = element_text(size = 20),
                                       axis.text.y = element_text(size = 20),
                                       legend.title = element_blank(),
                                       legend.position = "none",
                                       panel.grid.minor = element_blank(),
                                       panel.grid.major = element_blank())

clusters.plot <- clusters.plot + 
  labs(x = "#Clusters", y = expression(paste("#Rounds x", 10^3))) +
  scale_fill_manual(values = c(sn_color, dsn_color)) +
  scale_y_continuous(lim = c(0, 900000), breaks = seq(0, 900000, 100000), labels = function(x){paste0(x/100000)}) +
  coord_cartesian(xlim = c(0, 10))

plot(clusters.plot)

IMG_height = 15
IMG_width = 40

ggsave(filename = "./plots/facebook_pfab/clusters.pdf", units = "cm",
       plot = clusters.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 1.0)
