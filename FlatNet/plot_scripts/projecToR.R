#setwd("C:/Users/oaugusto/Desktop/Plots/FlatNet")
setwd("/home/oaugusto/CBNet/PlotsScripts/csv_data/flatnet")

################################## Libraries ###################################

library(ggplot2)
library(gridExtra)
library(tidyverse)
library(plyr)

# setup
options(scipen = 999)
theme_set(theme_bw())

############################# Reading tables  ##################################

total_work.table <- read.csv("./projector/tor/total_work.csv")
makespan.table <-read.csv("./projector/tor/total_time.csv")
clusters.table <-read.csv("./projector/tor/cluster.csv")
throughput.table <-read.csv("./projector/tor/throughput.csv")

#total_work.table <- read.csv("./projector/newTor/total_work.csv")
#makespan.table <-read.csv("./projector/newTor/total_time.csv")
#clusters.table <-read.csv("./projector/newTor/cluster.csv")
#throughput.table <-read.csv("./projector/newTor/throughput.csv")

#total_work.table <- read.csv("./projector/random/total_work.csv")
#makespan.table <-read.csv("./projector/random/total_time.csv")
#clusters.table <-read.csv("./projector/random/cluster.csv")
#throughput.table <-read.csv("./projector/random/throughput.csv")

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


# Init Ggplot Base Plot
total_work.plot <- ggplot(total_work.table, aes(x = abb, y = mean, fill = abb)) +
  geom_bar(position = "stack", stat = "identity") +
  geom_errorbar(total_work.table, mapping = aes(x = abb, 
                                            ymin = mean - ((qnorm(0.975)*std)/sqrt(30)), 
                                            ymax = mean + ((qnorm(0.975)*std)/sqrt(30))),
                                            width=.2,                    # Width of the error bars
                                            position="identity",
                                            colour = "#000000") +
  facet_grid(. ~ size)


# Modify theme components -------------------------------------------
total_work.plot <- total_work.plot + theme(text = element_text(size = 20),
                                           plot.title = element_blank(),
                                           plot.subtitle = element_blank(),
                                           plot.caption = element_blank(),
                                           axis.title.x = element_blank(),
                                           axis.title.y = element_text(size = 25),
                                           axis.text.x = element_text(size = 15),
                                           axis.text.y = element_text(size = 20),
                                           legend.text = element_text(size = 16),
                                           legend.title = element_blank(),
                                           legend.position = c(0.055, 0.725),
                                           panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank())

total_work.plot <- total_work.plot +
  labs(y = expression(paste("Work x", 10^{4}))) +
  scale_fill_manual(values = c(opt_color, ftng_color, fn_color, sn_color, dsn_color, bt_color)) +
  scale_y_continuous(breaks = seq(0, 60000, 10000), labels = function(x){paste0(x/10000)})

plot(total_work.plot)

IMG_height = 2.5
IMG_width = 7

ggsave(filename = "./plots/projecToR/total_work.pdf", units = "cm",
       plot = total_work.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 4.0)


############################# makespan  ##################################


makespan.table["abb"] <- revalue(makespan.table$project, 
                                 c("flattening" = "ftng",
                                   "flatnet" = "fn",
                                   "splaynet" = "sn", 
                                   "displaynet" = "dsn"))

makespan.table$abb <- factor(makespan.table$abb, levels = c("ftng", "fn", "sn", "dsn"))

makespan.table$size <- as.factor(makespan.table$size)

# Init Ggplot Base Plot
makespan.plot <- ggplot(makespan.table, aes(x = size, y = mean, group = abb, color = abb)) +
  geom_line(size = 1.5) +
  geom_point(aes(shape = abb), size=3, fill="white") +
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
                                       axis.text.y = element_text(size = 15),
                                       legend.title = element_blank(),
                                       legend.position = c(0.22, 0.82))

makespan.plot <- makespan.plot + theme(panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank()) +
  labs(x = "#Nodes", y = expression(paste("#Rounds x ", 10^{4}))) +
  scale_color_manual(values = c(ftng_color, fn_color, sn_color, dsn_color)) +
  scale_y_continuous(labels = function(x){paste0(x/10000)})

plot(makespan.plot)

IMG_height = 3
IMG_width = 3

ggsave(filename = "./plots/projecToR/makespan.pdf", units = "cm",
       plot = makespan.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 4.0)


############################# throughput  ##################################


throughput.table["abb"] <- revalue(throughput.table$project, 
                                   c("flattening" = "ftng",
                                     "flatnet" = "fn",
                                     "splaynet" = "sn", 
                                     "displaynet" = "dsn"))

throughput.table$abb <- factor(throughput.table$abb, levels = c("ftng", "fn","sn", "dsn"))


#throughput.table %>% filter(
#  abb %in% c("ftng", "fn")) -> throughput.table

# Init Ggplot Base Plot
throughput.plot <- ggplot(throughput.table, aes(x = value, fill = abb)) +
  geom_density(aes(y = ..count..), alpha = 0.5) +
  facet_grid(. ~ size)

# Modify theme components -------------------------------------------
throughput.plot <- throughput.plot + theme(text = element_text(size = 20),
                                           plot.title = element_blank(),
                                           plot.subtitle = element_blank(),
                                           plot.caption = element_blank(),
                                           axis.title.x = element_text(size = 18),
                                           axis.title.y = element_text(size = 15),
                                           axis.text.x = element_text(size = 20),
                                           axis.text.y = element_text(size = 20),
                                           legend.title = element_blank(),
                                           legend.position = c(0.15, 0.75))

throughput.plot <- throughput.plot + theme(panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank()) +
  labs(x = expression(paste("Time (rounds)", 10^3)), y = "Requests completed (per round)") +
  scale_fill_manual(values = c(ftng_color, fn_color, sn_color, dsn_color)) +
  scale_x_continuous(labels = function(x){paste0(x/1000)})

plot(throughput.plot)

IMG_height = 2.5
IMG_width = 7

ggsave(filename = "./plots/projecToR/throughput2.pdf", units = "cm",
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
  facet_grid( abb ~ size) #+
  # Add mean line
  #geom_vline(aes(xintercept=mean(value)), linetype="dashed") 

# Modify theme components -------------------------------------------
clusters.plot <- clusters.plot + theme(text = element_text(size = 20),
                                       plot.title = element_blank(),
                                       plot.subtitle = element_blank(),
                                       plot.caption = element_blank(),
                                       axis.title.x = element_text(size = 20),
                                       axis.title.y = element_text(size = 20),
                                       axis.text.x = element_text(size = 15),
                                       axis.text.y = element_text(size = 15),
                                       legend.title = element_blank(),
                                       legend.position = "top",#c(0.15, 0.85),
                                       panel.grid.minor = element_blank(),
                                       panel.grid.major = element_blank())

clusters.plot <- clusters.plot + 
  labs(x = "#Clusters", y = expression(paste("#Rounds x", 10^3))) +
  scale_fill_manual(values = c(ftng_color, fn_color, sn_color, dsn_color)) +
  coord_cartesian(xlim = c(0, 25)) +
  scale_y_sqrt(labels = function(x){paste0(x/1000)})
#breaks = seq(0, 16000, 1000), 

plot(clusters.plot)

IMG_height = 7
IMG_width = 7

ggsave(filename = "./plots/projecToR/clusters2.pdf", units = "cm",
       plot = clusters.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 4.0)
