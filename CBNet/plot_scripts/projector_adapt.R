setwd("C:/Users/oaugu/Desktop/PlotScripts/CBNet")
#setwd("/home/oaugusto/Master/PlotsScripts/CBNet")

################################## Libraries ###################################

library(ggplot2)
library(gridExtra)
library(tidyverse)
library(plyr)

# setup
options(scipen = 999)
theme_set(theme_bw())

############################# Reading tables  ##################################

total_work.table <- read.csv("./csv_data/projector_adapt/total_work.csv")
makespan.table <- read.csv("./csv_data/projector_adapt/total_time.csv")
#clusters.table <- read.csv("./csv_data/projector_adapt/cluster.csv")
#throughput.table <- read.csv("./csv_data/projector_adapt/throughput.csv")


############################# Define colors  ##################################

#COLORS
#cbn_color = "#325387"
cbn_color = "#000000"
cbn1 = "#325387"
cbn2 = "#325387"

#scbn_color = "#6C5B7B"
scbn_color = "#ffffff"
scbn1 = "#6C5B7B"
scbn2 = "#6C5B7B"

#sn_color = "#021C02"
sn_color = "#A8A7A7"
sn1 = "#1A361A"
sn2 = "#021C02"

#dsn_color = "#B53131"
dsn_color = "#2A363B"
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
IMG_width = 40

text_size <- 30
x_title_size <- 20
y_title_size <- 20
x_text_size <- 20
y_text_size <- 20

############################# total work ##################################

total_work.table["abb"] <- revalue(total_work.table$project, 
                                   c("cbnet" = "CBN",
                                     "cbnetAdapt30" = "AD1",
                                     "cbnetAdapt100" = "AD2",
                                     "cbnetAdapt500" = "AD3",
                                     "cbnetAdapt1000" = "AD4",
                                     "displaynet" = "DSN",
                                     "optnet" = "OPT",
                                     "simplenet" = "BT"))

total_work.table$abb <- factor(total_work.table$abb, levels = c("OPT", "CBN", "AD1", "AD2", "AD3", "AD4", "DSN", "BT"))

total_work.table["operation"] <- revalue(total_work.table$operation, c("rotation" = "Rotation",
                                                                       "routing" = "Routing"))

#total_work.table["dataset"] <- revalue(total_work.table$dataset, 
#                                   c("1" = "1",
#                                     "2" = "2",
#                                     "4" = "4"))

#total_work.table %>% filter(
#  dataset %in% c("Mocfe", "Nekbone", "Multigrid")) -> total_work.table


total_work.table %>% filter(
  operation %in% c("Rotation", "Routing")) -> operations.table

# Init Ggplot Base Plot
total_work.plot <- ggplot(operations.table, aes(x = abb, y = value, fill = operation)) +#, col = abb)) +
  geom_bar(position = "stack", stat = "identity", alpha = 0.8) +
  facet_grid(. ~ dataset)#, scales = 'free', space = 'free', nrow = 2)


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
                                           legend.position = c(0.075, 0.895))

total_work.plot <- total_work.plot + theme(panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank()) +
  labs(y = expression(paste("Work x", 10^{6}))) +
  scale_color_manual(values = c(opt_color, scbn_color, cbn_color, sn_color, dsn_color, bt_color)) +
  scale_fill_manual(values = c("#2A363B","#A8A7A7")) +
  scale_y_continuous(lim = c(0, 10000000), breaks = seq(0, 20000000, 2000000), labels = function(x){paste0(x/1000000)}) 

plot(total_work.plot)

ggsave(filename = "./plots/projector_adapt/total_work.png", units = "cm",
       plot = total_work.plot, device = "png",  width = IMG_width, height = IMG_height, scale = scale_imgs)

############################# Rotations ##################################

total_work.table["abb"] <- revalue(total_work.table$project, 
                                   c("cbnet" = "CBN",
                                     "cbnetAdapt30" = "AD1",
                                     "cbnetAdapt100" = "AD2",
                                     "cbnetAdapt500" = "AD3",
                                     "cbnetAdapt1000" = "AD4",
                                     "displaynet" = "DSN",
                                     "optnet" = "OPT",
                                     "simplenet" = "BT"))

total_work.table$abb <- factor(total_work.table$abb, levels = c("OPT", "CBN", "AD1", "AD2", "AD3", "AD4", "DSN", "BT"))

total_work.table["operation"] <- revalue(total_work.table$operation, c("rotation" = "Rotation",
                                                                       "routing" = "Routing"))

total_work.table %>% filter(
  abb %in% c("CBN", "AD1", "AD2", "AD3", "AD4")) -> total_work.table


total_work.table %>% filter(
  operation %in% c("Rotation")) -> total_work.table

# Init Ggplot Base Plot
total_work.plot <- ggplot(total_work.table, aes(x = abb, y = value)) +
  geom_bar(stat = "identity", position=position_dodge(), alpha = 0.8) +
  facet_grid(. ~ dataset)#, scales = 'free', space = 'free', nrow = 2)


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
                                           legend.title = element_blank())

total_work.plot <- total_work.plot + theme(panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank()) +
  labs(y = expression(paste("Rotations x", 10^{3}))) +
  scale_color_manual(values = c(opt_color, scbn_color, cbn_color, sn_color, dsn_color, bt_color)) +
  scale_fill_manual(values = c("#2A363B")) +
  scale_y_continuous(lim = c(0, 10000), breaks = seq(0, 10000, 2000), labels = function(x){paste0(x/1000)}) 

plot(total_work.plot)

ggsave(filename = "./plots/projector_adapt/total_rot.png", units = "cm",
       plot = total_work.plot, device = "png",  width = IMG_width, height = IMG_height, scale = scale_imgs)



############################# throughput  ##################################


throughput.table["abb"] <- revalue(throughput.table$project, 
                                   c("cbnet" = "CBN",
                                     "cbnetAdapt30" = "AD1",
                                     "cbnetAdapt100" = "AD2",
                                     "cbnetAdapt500" = "AD3",
                                     "cbnetAdapt1000" = "AD4",
                                     "displaynet" = "DSN"))

throughput.table$abb <- factor(throughput.table$abb, levels = c("CBN","DSN","AD1","AD2","AD3","AD4"))


#throughput.table["dataset"] <- revalue(throughput.table$dataset)

#throughput.table %>% filter(
#  dataset %in% c("Mocfe", "Nekbone", "Multigrid")) -> throughput.table


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
                                           legend.position = c(0.25, 0.86)) +
  facet_grid(. ~ dataset)

throughput.plot <- throughput.plot + theme(panel.grid.minor = element_blank(),
                                           panel.grid.major = element_blank()) +
  labs(x = expression(paste("Time (rounds) x", 10^6)), y = "Requests completed/round") +
  scale_fill_manual(values = c(cbn_color, dsn_color, sn_color, scbn_color, opt_color, bt_color)) +
  scale_y_continuous(lim = c(0, 0.8), breaks = seq(0, 5, 0.1)) +
  scale_x_continuous(labels = function(x){paste0(x/1000000)})

plot(throughput.plot)

ggsave(filename = "./plots/projector_adapt/throughput.png", units = "cm",
       plot = throughput.plot, device = "png",  width = IMG_width, height = IMG_height, scale = scale_imgs)


############################# cluster ##################################


clusters.table["abb"] <- revalue(clusters.table$project, 
                                 c("cbnet" = "CBN",
                                   "cbnetAdapt30" = "AD1",
                                   "cbnetAdapt100" = "AD2",
                                   "cbnetAdapt500" = "AD3",
                                   "cbnetAdapt1000" = "AD4",
                                   "displaynet" = "DSN")))

clusters.table$abb <- factor(clusters.table$abb, levels = c("CBN","DSN", "SN", "SCBN"))


clusters.table["dataset"] <- revalue(clusters.table$dataset, 
                                       c("cesar_mocfe" = "Mocfe",
                                         "cesar_nekbone" = "Nekbone",
                                         "cns_nospec" = "Nospec", 
                                         "multigrid" = "Multigrid"))

clusters.table %>% filter(
  dataset %in% c("Mocfe", "Nekbone", "Multigrid")) -> clusters.table

clusters.table %>% filter(
  abb %in% c("CBN", "DSN")) -> clusters.table

# Init Ggplot Base Plot
clusters.plot <- ggplot(clusters.table, aes(x = value, fill = abb)) +
  geom_histogram(aes(y = ..count..), position = "dodge", binwidth = 1, alpha = 1, col = "#000000") +
  facet_grid(. ~ dataset)
# Add mean line
#geom_vline(aes(xintercept=mean(value)), linetype="dashed")

# Modify theme components -------------------------------------------
clusters.plot <- clusters.plot + theme(text = element_text(size = text_size),
                                       plot.title = element_blank(),
                                       plot.subtitle = element_blank(),
                                       plot.caption = element_blank(),
                                       axis.title.x = element_text(size = x_title_size),
                                       axis.title.y = element_text(size = y_title_size),
                                       axis.text.x = element_text(size = x_text_size, color = "black"),
                                       axis.text.y = element_text(size = y_text_size, color = "black"),
                                       legend.text = element_text(size = text_size),
                                       legend.title = element_blank(),
                                       legend.position = c(0.82, 0.77),
                                       panel.grid.minor = element_blank(),
                                       panel.grid.major = element_blank())

clusters.plot <- clusters.plot + 
  labs(x = "#Clusters", y = expression(paste("#Rounds x", 10^3))) +
  scale_fill_manual(values = c("#2A363B","#A8A7A7")) +
  scale_y_continuous(lim = c(0, 900000), breaks = seq(0, 900000, 100000), labels = function(x){paste0(x/100000)}) +
  scale_x_continuous(breaks = seq(0, 10, 1)) +
  coord_cartesian(xlim = c(0, 10))

plot(clusters.plot)

ggsave(filename = "./plots/projector_adapt/clusters.png", units = "cm",
       plot = clusters.plot, device = "png",  width = IMG_width, height = IMG_height, scale = scale_imgs)

############################# makespan 1 ##################################


makespan.table["abb"] <- revalue(makespan.table$project, 
                                 c("cbnet" = "CBN",
                                   "cbnetAdapt30" = "AD1",
                                   "cbnetAdapt100" = "AD2",
                                   "cbnetAdapt500" = "AD3",
                                   "cbnetAdapt1000" = "AD4",
                                   "displaynet" = "DSN"))

makespan.table$abb <- factor(makespan.table$abb, levels = c("CBN","AD1","AD2","AD3","AD4","DSN"))

# Init Ggplot Base Plot
makespan.plot <- ggplot(makespan.table, aes(x = abb, y = value)) +
  geom_bar(stat = "identity", position=position_dodge(), alpha = 0.8) +
  facet_grid(. ~ dataset)

# Modify theme components -------------------------------------------
makespan.plot <- makespan.plot + theme(text = element_text(size = text_size),
                                       plot.title = element_blank(),
                                       plot.subtitle = element_blank(),
                                       plot.caption = element_blank(),
                                       axis.title.x = element_blank(),
                                       axis.title.y = element_text(size = y_title_size),
                                       axis.text.x = element_text(size = x_text_size),
                                       axis.text.y = element_text(size = y_text_size),
                                       legend.text = element_text(size = text_size),
                                       legend.title = element_blank(),
                                       legend.position = "none")#c(0.05, 0.85))

makespan.plot <- makespan.plot + theme(panel.grid.minor = element_blank(),
                                       panel.grid.major = element_blank()) +
  labs(x = "n", y = expression(paste("#Rounds x ", 10^{5}))) +
  scale_color_manual(values = c(cbn_color, scbn_color, dsn_color, sn_color)) +
  scale_fill_manual(values = c(cbn_color, scbn_color, dsn_color, sn_color)) +
  scale_y_continuous(limits = c(0, 2500000), breaks = seq(0, 2500000, 200000), labels = function(x){paste0(x/100000)}) +
  guides(color = guide_legend(override.aes = list(size = 5)))

plot(makespan.plot)

ggsave(filename = "./plots/projector_adapt/makespan.png", units = "cm",
       plot = makespan.plot, device = "png",  width = IMG_width, height = IMG_height, scale = scale_imgs)

