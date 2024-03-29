setwd("C:/Users/oaugu/Desktop/PlotScripts/ToN")
#setwd("/home/oaugusto/CBNet/PlotsScripts/ToN")

################################## Libraries ###################################

library(ggplot2)
library(gridExtra)
library(tidyverse)
library(plyr)

# setup
options(scipen = 999)
theme_set(theme_bw())

############################# Reading tables  ##################################

total_work.table <- read.csv("./csv_data/hpc/total_work.csv")
#makespan.table <-read.csv("./csv_data/hpc/total_time.csv")
#clusters.table <-read.csv("./csv_data/hpc/cluster.csv")
throughput.table <-read.csv("./csv_data/hpc/throughput.csv")
#work_cdf.table <- read.csv("./csv_data/hpc/work_cdf.csv")
#work_boxplot.table <- read.csv("./csv_data/hpc/work_boxplot.csv")

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

num_sim <- 10

############################# Define imgs paremeters ######################

scale_imgs <- 1

IMG_height = 15
IMG_width = 40

text_size <- 30
x_title_size <- 25
y_title_size <- 25
x_text_size <- 25
y_text_size <- 25

############################# total work ##################################

total_work.table["abb"] <- revalue(total_work.table$project, 
                                                  c("splaynet" = "SN", 
                                                    "displaynet" = "DSN",
                                                    "optnet" = "OPT",
                                                    "simplenet" = "BT"))

total_work.table$abb <- factor(total_work.table$abb, levels = c("OPT", "SN", "DSN", "BT"))

# Init Ggplot Base Plot
total_work.plot <- ggplot(total_work.table, aes(x = abb, y = work)) +
  geom_bar(stat="identity")


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
                                           legend.position = "none")

total_work.plot <- total_work.plot + theme(panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank()) +
  labs(y = expression(paste("Work x", 10^{6})), x = "n") +
  scale_color_manual(values = c(opt_color, sn_color, dsn_color, bt_color)) +
  scale_fill_manual(values = c("#2A363B","#A8A7A7")) +
  scale_y_continuous(limits = c(0, 16000000), breaks = seq(0, 16000000, 2000000), labels = function(x){paste0(x/1000000)}) +
  guides(color = guide_legend(override.aes = list(size = 5)))

plot(total_work.plot)

IMG_height = 15
IMG_width = 15

ggsave(filename = "./plots/hpc/total_work.pdf", units = "cm",
       plot = total_work.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 1.0)

############################# cdf work  ##################################


#work_cdf.table["abb"] <- revalue(work_cdf.table$project, 
#                                 c("splaynet" = "SplayNet", 
#                                   "displaynet" = "DiSplayNet",
#                                   "optnet" = "StaticOPT",
#                                   "simplenet" = "Balanced Tree"))

#work_cdf.table$abb <- factor(work_cdf.table$abb, levels = c("StaticOPT", "SplayNet", "DiSplayNet", "Balanced Tree"))


#work_cdf.table %>% filter(
#  size %in% c(1024)) -> work_cdf.table

#work_cdf.table %>% filter(
#  x %in% c(0.4)) -> work_cdf.table

#work_cdf.table %>% filter(
#  y %in% c(1)) -> work_cdf.table

# Init Ggplot Base Plot
#work_cdf.plot <- ggplot(work_cdf.table, aes(x = value, colour = abb)) +
#  stat_ecdf(aes(linetype = abb), geom = "step", size = 1.2) +
#  geom_hline(yintercept = 1, linetype="dashed") #+
  #facet_grid(y ~ x, as.table = FALSE, labeller = function(variable, value) {
  #  if (variable=='x') {
  #    return(paste("x:",value))
  #  } else {
  #    return(paste("y:",value))
  #  }
  #})


# Modify theme components -------------------------------------------
#work_cdf.plot <- work_cdf.plot + theme(text = element_text(size = 20),
#                                       plot.title = element_blank(),
#                                       plot.subtitle = element_blank(),
#                                       plot.caption = element_blank(),
#                                       axis.title.x = element_text(size = 25),
#                                       axis.title.y = element_text(size = 25),
#                                       axis.text.x = element_text(size = 20),
#                                       axis.text.y = element_text(size = 20),
#                                       legend.text = element_text(size = 20),
#                                       legend.title = element_blank(),
#                                       legend.position = c(0.25, 0.8))

#work_cdf.plot <- work_cdf.plot + theme(panel.grid.minor = element_blank(),
#                                           panel.grid.major = element_blank()) +
#  labs(x = "Number of steps", y = "CDF of Requests") +
#  scale_color_manual(values = c(opt_color, sn_color, dsn_color, bt_color)) +
#  coord_cartesian(xlim = c(0, 20))

#plot(work_cdf.plot)

#IMG_height = 15
#IMG_width = 15

#ggsave(filename = "./plots/bursty/work_cdf.pdf", units = "cm",
#       plot =work_cdf.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 1.0)


############################# makespan  ##################################


#makespan.table["abb"] <- revalue(makespan.table$project, 
#                                 c("splaynet" = "SplayNet", 
#                                   "displaynet" = "DiSplayNet"))

#makespan.table$abb <- factor(makespan.table$abb, levels = c("SplayNet", "DiSplayNet"))

#makespan.table$size <- as.factor(makespan.table$size)

#makespan.table %>% filter(
#  x %in% c(0.4)) -> makespan.table

#makespan.table %>% filter(
#  y %in% c(1)) -> makespan.table

# Init Ggplot Base Plot
#makespan.plot <- ggplot(makespan.table, aes(x = size, y = mean, color = abb, fill = abb)) +
#  geom_point(size = 0, shape = 22) +
#  geom_boxplot(position = "identity", size = 1.25, show.legend = FALSE) +
#  geom_errorbar(aes(ymin = mean - ((qnorm(0.975)*std)/sqrt(num_sim)), 
#                    ymax = mean + ((qnorm(0.975)*std)/sqrt(num_sim)) ), 
#                width=.2,
#                position="identity") #+
  #facet_grid(y ~ x, as.table = FALSE, labeller = function(variable, value) {
  #  if (variable=='x') {
  #    return(paste("x:",value))
  #  } else {
  #    return(paste("y:",value))
  #  }
  #})

# Modify theme components -------------------------------------------
#makespan.plot <- makespan.plot + theme(text = element_text(size = 20),
#                                       plot.title = element_blank(),
#                                       plot.subtitle = element_blank(),
#                                       plot.caption = element_blank(),
#                                       axis.title.x = element_text(size = 25),
#                                       axis.title.y = element_text(size = 25),
#                                       axis.text.x = element_text(size = 20),
#                                       axis.text.y = element_text(size = 20),
#                                       legend.text = element_text(size = 20),
#                                       legend.title = element_blank(),
#                                       legend.position = c(0.25, 0.85)) #before
                                       #legend.position = c(0.1, 0.95))

#makespan.plot <- makespan.plot + theme(panel.grid.minor = element_blank(),
#                                           panel.grid.major = element_blank()) +
#  labs(x = "n", y = expression(paste("#Rounds x ", 10^{3}))) +
#  scale_color_manual(values = c(sn_color, dsn_color)) +
#  scale_fill_manual(values = c(sn_color, dsn_color)) +
#  scale_y_continuous(limits = c(0, 80000), breaks = seq(0, 80000, 10000), labels = function(x){paste0(x/1000)}) +
#  guides(color = guide_legend(override.aes = list(size = 5)))

#plot(makespan.plot)

#IMG_height = 15
#IMG_width = 15

#ggsave(filename = "./plots/bursty/makespan.pdf", units = "cm",
#       plot = makespan.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 1.0)


############################# throughput  ##################################


throughput.table["abb"] <- revalue(throughput.table$project, 
                                   c("splaynet" = "SN", 
                                     "displaynet" = "DSN"))

throughput.table$abb <- factor(throughput.table$abb, levels = c("SN", "DSN"))

# Init Ggplot Base Plot
throughput.plot <- ggplot(throughput.table, aes(x = value, fill = abb)) +
  geom_density(aes(y = ..count..), alpha = 0.67) 

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
                                           legend.position = c(0.8, 0.75))

throughput.plot <- throughput.plot + theme(panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank()) +
  labs(x = expression(paste("Time (rounds) x", 10^6)), y = "Requests completed/round") +
  scale_fill_manual(values = c("#C5C4C4", "#969899")) +
  scale_y_continuous(lim = c(0, 0.8), breaks = seq(0, 7, 0.1)) +
  scale_x_continuous(lim = c(0, 7000000), breaks = seq(0, 7000000, 1000000), labels = function(x){paste0(x/1000000)})

plot(throughput.plot)

IMG_height = 15
IMG_width = 15

ggsave(filename = "./plots/hpc/throughput.pdf", units = "cm",
       plot = throughput.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 1.0)


############################# cluster ##################################


clusters.table["abb"] <- revalue(clusters.table$project, 
                                   c("splaynet" = "sn", 
                                     "displaynet" = "dsn"))

clusters.table$abb <- factor(clusters.table$abb, levels = c("sn", "dsn"))

clusters.table %>% filter(
  size %in% c(1024)) -> clusters.table

clusters.table %>% filter(
  x %in% c(0.4)) -> clusters.table

clusters.table %>% filter(
  y %in% c(1)) -> clusters.table

clusters.table %>% filter(
  abb %in% c("dsn")) -> clusters.table

# Init Ggplot Base Plot
clusters.plot <- ggplot(clusters.table, aes(x = value, fill = abb)) +
  geom_histogram(aes(y = ..count..), position = "dodge", binwidth = 1, alpha = 0.5, col = "#000000") +
  # Add mean line
  geom_vline(aes(xintercept=mean(value)), linetype="dashed") #+
  #facet_grid(y ~ x, as.table = FALSE, labeller = function(variable, value) {
  #  if (variable=='x') {
  #    return(paste("x:",value))
  #  } else {
  #    return(paste("y:",value))
  #  }
  #})

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
  scale_y_continuous(lim = c(0, 25000), breaks = seq(0, 25000, 4000), labels = function(x){paste0(x/1000)}) +
  coord_cartesian(xlim = c(0, 15))

plot(clusters.plot)

IMG_height = 15
IMG_width = 15

ggsave(filename = "./plots/bursty/clusters.pdf", units = "cm",
       plot = clusters.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 1.0)

############################# work boxplot ##################################

work_boxplot.table["abb"] <- revalue(work_boxplot.table$project, 
                                   c("bursty" = "oldVersion", 
                                     "bursty_new" = "newVersion"))

work_boxplot.table$abb <- factor(work_boxplot.table$abb, levels = c("oldVersion", "newVersion"))


work_boxplot.table$size <- as.factor(work_boxplot.table$size)

# Init Ggplot Base Plot
work_boxplot.plot <- ggplot(work_boxplot.table, aes(x = size, y = value, col = abb, fill = abb)) +
  geom_point(size = 0, shape = 22, position = position_dodge(1)) +
  geom_boxplot(position = position_dodge(1), size = 1.25, show.legend = FALSE) +
  stat_summary(position = position_dodge(1), fun.y=mean, geom="point", shape=5, size=4) +
  facet_grid(y ~ x, as.table = FALSE, labeller = function(variable, value) {
    if (variable=='x') {
      return(paste("x:",value))
    } else {
      return(paste("y:",value))
    }
  })


# Modify theme components -------------------------------------------
work_boxplot.plot <- work_boxplot.plot + theme(text = element_text(size = 20, color = "#000000"),
                                           plot.title = element_blank(),
                                           plot.subtitle = element_blank(),
                                           plot.caption = element_blank(),
                                           axis.title.x = element_text(size = 25),
                                           axis.title.y = element_text(size = 25),
                                           axis.text.x = element_text(size = 20),
                                           axis.text.y = element_text(size = 20),
                                           legend.text = element_text(size = 20),
                                           legend.title = element_blank(),
                                           #legend.position = c(0.25, 0.85), #
                                           legend.position = c(0.07, 0.95),
                                           legend.background = element_rect(fill = "transparent", colour = "transparent"))

work_boxplot.plot <- work_boxplot.plot + theme(panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank()) +
  labs(y = expression(paste("Work x", 10^{4})), x = "n") +
  scale_color_manual(values = c(opt_color, sn_color, dsn_color, bt_color)) +
  scale_fill_manual(values = c(opt_color, sn_color, dsn_color, bt_color)) +
  scale_y_sqrt() +
  guides(color = guide_legend(override.aes = list(size = 5)))

plot(work_boxplot.plot)

IMG_height = 15
IMG_width = 15

ggsave(filename = "./plots/bursty/work_boxplot.pdf", units = "cm",
       plot = work_boxplot.table, device = "pdf",  width = IMG_width, height = IMG_height, scale = 1.0)

