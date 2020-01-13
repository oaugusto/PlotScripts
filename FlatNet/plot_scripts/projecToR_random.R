setwd("/home/oaugusto/CBNet/PlotsScripts")

################################## Libraries ###################################

library(ggplot2)
library(gridExtra)
library(tidyverse)
library(plyr)

# setup
options(scipen = 999)
theme_set(theme_bw())

############################# Reading tables  ##################################

dataset <- "random"

f1 <- paste("./csv_data/flatnet/projector/", dataset, "/total_work.csv", sep = "")
f2 <- paste("./csv_data/flatnet/projector/", dataset, "/total_time.csv", sep = "")
f3 <- paste("./csv_data/flatnet/projector/", dataset, "/cluster.csv", sep = "")
f4 <- paste("./csv_data/flatnet/projector/", dataset, "/throughput.csv", sep = "")
f5 <- paste("./csv_data/flatnet/projector/", dataset,"/work_cdf.csv", sep = "")

total_work.table <- read.csv(f1)
makespan.table <-read.csv(f2)
clusters.table <-read.csv(f3)
throughput.table <-read.csv(f4)
work_cdf.table <- read.csv(f5)

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
                                     "flatnet" = "FlatNet",
                                     "splaynet" = "sn", 
                                     "displaynet" = "dsn",
                                     "optnet" = "opt",
                                     "simplenet" = "bt"))

total_work.table$abb <- factor(total_work.table$abb, levels = c("opt", "ftng", "FlatNet", 
                                                                "sn", "dsn", "bt"))

total_work.table %>% filter(
  size %in% c(128, 1024)) -> total_work.table

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
                                           axis.title.y = element_text(size = 20),
                                           axis.text.x = element_text(size = 15, 
                                                                      angle = -20,
                                                                      vjust = 0.5),
                                           axis.text.y = element_text(size = 15),
                                           legend.text = element_text(size = 14),
                                           legend.title = element_blank(),
                                           legend.position = "none", #c(0.055, 0.725),
                                           panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank())

total_work.plot <- total_work.plot +
  labs(y = expression(paste("Trabalho total x", 10^{4}))) +
  scale_fill_manual(values = c(opt_color, ftng_color, fn_color, sn_color, dsn_color, bt_color)) +
  scale_y_continuous(labels = function(x){paste0(x/10000)}) 

plot(total_work.plot)

IMG_height = 2.5
IMG_width = 4

f <- paste("./FlatNet/plots/projector/", dataset, "/total_work_1.pdf", sep = "")

ggsave(filename = f, units = "cm",
       plot = total_work.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 4.0)


############################# work cdf ##################################


work_cdf.table["abb"] <- revalue(work_cdf.table$project, 
                                 c("flattening" = "ftng",
                                   "flatnet" = "FlatNet",
                                   "splaynet" = "sn", 
                                   "displaynet" = "dsn",
                                   "optnet" = "opt",
                                   "simplenet" = "bt"))

work_cdf.table$abb <- factor(work_cdf.table$abb, levels = c("opt", "ftng", "FlatNet", 
                                                            "sn", "dsn", "bt"))

work_cdf.table %>% filter(
  size %in% c(128, 1024)) -> work_cdf.table

# Init Ggplot Base Plot
work_cdf.plot <- ggplot(work_cdf.table, aes(x = value, colour = abb)) +
  stat_ecdf(aes(linetype = abb), geom = "step", size = 1.2) +
  facet_grid(. ~ size) +
  geom_hline(yintercept = 1, linetype="dashed") 


# Modify theme components -------------------------------------------
work_cdf.plot <- work_cdf.plot + theme(text = element_text(size = 20),
                                       plot.title = element_blank(),
                                       plot.subtitle = element_blank(),
                                       plot.caption = element_blank(),
                                       axis.title.x = element_text(size = 20),
                                       axis.title.y = element_text(size = 20),
                                       axis.text.x = element_text(size = 15),
                                       axis.text.y = element_text(size = 15),
                                       legend.title = element_blank(),
                                       legend.text = element_text(size = 14),
                                       legend.position = c(0.7, 0.6))

work_cdf.plot <- work_cdf.plot + theme(panel.grid.minor = element_blank(),
                                       panel.grid.major = element_blank()) +
  labs(x = "Trabalho por requisição", y = "CDF de Requisições") +
  scale_color_manual(values = c(opt_color, ftng_color, fn_color, sn_color, dsn_color, bt_color)) +
  coord_cartesian(xlim = c(0, 20))

plot(work_cdf.plot)

IMG_height = 2.5
IMG_width = 4

f <- paste("./FlatNet/plots/projector/", dataset, "/work_cdf.pdf", sep = "")

ggsave(filename = f, units = "cm",
       plot =work_cdf.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 4.0)

total_and_cdf.plot <- grid.arrange(total_work.plot, work_cdf.plot, nrow = 1)

IMG_height = 2.5
IMG_width = 8

f2 <- paste("./FlatNet/plots/projector/", dataset, "/total_work_and_cdf.pdf", sep = "")

ggsave(filename = f2, units = "cm",
       plot =total_and_cdf.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 4.0)


############################# makespan 1 ##################################


makespan.table["abb"] <- revalue(makespan.table$project, 
                                 c("flattening" = "ftng",
                                   "flatnet" = "FlatNet",
                                   "splaynet" = "sn", 
                                   "displaynet" = "dsn"))

makespan.table$abb <- factor(makespan.table$abb, levels = c("ftng", "FlatNet", "sn", "dsn"))


makespan.table %>% filter(
  size %in% c(128, 1024)) -> makespan.table


# Init Ggplot Base Plot
makespan.plot <- ggplot(makespan.table, aes(x = abb, y = mean, fill = abb)) +
  geom_bar(position = "stack", stat = "identity") +
  geom_errorbar(makespan.table, mapping = aes(x = abb, 
                                              ymin = mean - ((qnorm(0.975)*std)/sqrt(30)), 
                                              ymax = mean + ((qnorm(0.975)*std)/sqrt(30))),
                width=.2,                    # Width of the error bars
                position="identity",
                colour = "#000000") +
  facet_grid(. ~ size)

# Modify theme components -------------------------------------------
makespan.plot <- makespan.plot + theme(text = element_text(size = 20),
                                       plot.title = element_blank(),
                                       plot.subtitle = element_blank(),
                                       plot.caption = element_blank(),
                                       axis.title.x = element_blank(),#element_text(size = 20),
                                       axis.title.y = element_text(size = 20),
                                       axis.ticks.x = element_blank(),
                                       axis.text.x = element_text(size = 15, 
                                                                  angle = -20,
                                                                  vjust = 0.5),
                                       axis.text.y = element_text(size = 15),
                                       legend.title = element_blank(),
                                       legend.position = "none")#c(0.8, 0.4))

makespan.plot <- makespan.plot + theme(panel.grid.minor = element_blank(),
                                       panel.grid.major = element_blank()) +
  labs(x = "Project", y = expression(paste("#Rounds x ", 10^{4}))) +
  scale_fill_manual(values = c(ftng_color, fn_color, sn_color, dsn_color)) +
  scale_y_continuous(breaks = seq(0, 100000, 20000), labels = function(x){paste0(x/10000)})

plot(makespan.plot)

IMG_height = 2.5
IMG_width = 4

f <- paste("./FlatNet/plots/projector/", dataset, "/makespan1.pdf", sep = "")

ggsave(filename = f, units = "cm",
       plot = makespan.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 4.0)


############################# makespan 2 ##################################


makespan.table["abb"] <- revalue(makespan.table$project, 
                                 c("flattening" = "ftng",
                                   "flatnet" = "fn",
                                   "splaynet" = "sn", 
                                   "displaynet" = "dsn"))

makespan.table$abb <- factor(makespan.table$abb, levels = c("ftng", "fn", "sn", "dsn"))

makespan.table$size <- as.factor(makespan.table$size)

makespan.table %>% filter(
  abb %in% c("ftng", "fn")) -> makespan.table

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
                                       axis.title.x = element_text(size = 20),
                                       axis.title.y = element_text(size = 20),
                                       axis.text.x = element_text(size = 15),
                                       axis.text.y = element_text(size = 15),
                                       legend.title = element_blank(),
                                       legend.position = c(0.2, 0.8))

makespan.plot <- makespan.plot + theme(panel.grid.minor = element_blank(),
                                       panel.grid.major = element_blank()) +
  labs(x = "#Nodes", y = expression(paste("#Rounds x ", 10^{4}))) +
  scale_color_manual(values = c(ftng_color, fn_color, sn_color, dsn_color)) +
  scale_y_continuous(labels = function(x){paste0(x/10000)})

plot(makespan.plot)

IMG_height = 2.5
IMG_width = 5

f <- paste("./FlatNet/plots/projector/", dataset, "/makespan2.pdf", sep = "")

ggsave(filename = f, units = "cm",
       plot = makespan.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 4.0)


############################# throughput 1  ##################################


throughput.table["abb"] <- revalue(throughput.table$project, 
                                   c("flattening" = "ftng",
                                     "flatnet" = "FlatNet",
                                     "splaynet" = "sn", 
                                     "displaynet" = "dsn"))


throughput.table$abb <- factor(throughput.table$abb, levels = c("ftng", "FlatNet","sn", "dsn"))


throughput.table %>% filter(
  size %in% c(128, 1024)) -> throughput.table


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
                                           axis.text.x = element_text(size = 15),
                                           axis.text.y = element_text(size = 15),
                                           legend.title = element_blank(),
                                           legend.position = c(0.3, 0.75))

throughput.plot <- throughput.plot + theme(panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank()) +
  labs(x = expression(paste("Tempo (rounds) x", 10^3)), y = "Throughput") +
  scale_fill_manual(values = c(ftng_color, fn_color, sn_color, dsn_color)) +
  scale_x_continuous(labels = function(x){paste0(x/1000)})

plot(throughput.plot)

IMG_height = 2.5
IMG_width = 4

f <- paste("./FlatNet/plots/projector/", dataset, "/throughput1.pdf", sep = "")

ggsave(filename = f , units = "cm",
       plot = throughput.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 4.0)


throughput_and_makespan.plot <- grid.arrange(makespan.plot, throughput.plot, nrow = 1)

IMG_height = 2.5
IMG_width = 8

f2 <- paste("./FlatNet/plots/projector/", dataset, "/throughput_and_makespan.pdf", sep = "")

ggsave(filename = f2, units = "cm",
       plot =throughput_and_makespan.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 4.0)


############################# throughput 2  ##################################


throughput.table["abb"] <- revalue(throughput.table$project, 
                                   c("flattening" = "ftng",
                                     "flatnet" = "fn",
                                     "splaynet" = "sn", 
                                     "displaynet" = "dsn"))

throughput.table$abb <- factor(throughput.table$abb, levels = c("ftng", "fn","sn", "dsn"))


throughput.table %>% filter(
  abb %in% c("ftng", "fn")) -> throughput.table

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
                                           axis.text.x = element_text(size = 15),
                                           axis.text.y = element_text(size = 15),
                                           legend.title = element_blank(),
                                           legend.position = c(0.15, 0.75))

throughput.plot <- throughput.plot + theme(panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank()) +
  labs(x = expression(paste("Tempo (rounds) x", 10^3)), y = "Requisições completadas(por round)") +
  scale_fill_manual(values = c(ftng_color, fn_color, sn_color, dsn_color)) +
  scale_x_continuous(labels = function(x){paste0(x/1000)})

plot(throughput.plot)

IMG_height = 2.5
IMG_width = 7

f <- paste("./FlatNet/plots/projector/", dataset, "/throughput2.pdf", sep = "")

ggsave(filename = f , units = "cm",
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
                                       legend.position = "none",#c(0.15, 0.85),
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

f <- paste("./FlatNet/plots/projector/", dataset, "/clusters1.pdf", sep = "")

ggsave(filename = f, units = "cm",
       plot = clusters.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 4.0)

############################# cluster 2 ##################################


clusters.table["abb"] <- revalue(clusters.table$project, 
                                 c("flattening" = "ftng",
                                   "flatnet" = "FlatNet",
                                   "splaynet" = "sn", 
                                   "displaynet" = "DiSplayNet"))

clusters.table$abb <- factor(clusters.table$abb, levels = c("ftng", "FlatNet", "sn", "DiSplayNet"))

clusters.table %>% filter(
  size %in% c(128, 1024)) -> clusters.table

clusters.table %>% filter(
  abb %in% c("FlatNet", "DiSplayNet")) -> clusters.table

# Init Ggplot Base Plot
clusters.plot <- ggplot(clusters.table, aes(x = value, fill = abb)) +
  geom_histogram(aes(y = ..count..), position = "dodge", binwidth = 1) +
  facet_grid( . ~ size) #+
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
                                       legend.position = c(0.3, 0.85),
                                       panel.grid.minor = element_blank(),
                                       panel.grid.major = element_blank())

clusters.plot <- clusters.plot + 
  labs(x = "#Clusters", y = expression(paste("#Rounds x", 10^3))) +
  scale_fill_manual(values = c(ftng_color, fn_color, sn_color, dsn_color)) +
  coord_cartesian(xlim = c(0, 25)) +
  scale_y_sqrt(breaks = c(0, 1000, 5000, 10000, 20000, 40000, 80000),labels = function(x){paste0(x/1000)})
#breaks = seq(0, 16000, 1000), 

plot(clusters.plot)

IMG_height = 2.5
IMG_width = 8

f <- paste("./FlatNet/plots/projector/", dataset, "/clusters2.pdf", sep = "")

ggsave(filename = f, units = "cm",
       plot = clusters.plot, device = "pdf",  width = IMG_width, height = IMG_height, scale = 4.0)
