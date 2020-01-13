setwd("~/CBNet/DataGenerator/output/projector")

library(tidyverse)

# setup
options(scipen = 999)
theme_set(theme_bw())

sequence.table1 <- read.csv(file = "./tor/128/1_tor_128.txt", skip = 1, col.names = c("x", "y"), header = FALSE)
sequence.table2 <- read.csv(file = "./tor/256/1_tor_256.txt", skip = 1, col.names = c("x", "y"), header = FALSE)
sequence.table3 <- read.csv(file = "./tor/512/1_tor_512.txt", skip = 1, col.names = c("x", "y"), header = FALSE)
sequence.table4 <- read.csv(file = "./tor/1024/1_tor_1024.txt", skip = 1, col.names = c("x", "y"), header = FALSE)

sequence.table1$size <- 128
sequence.table2$size <- 256
sequence.table3$size <- 512
sequence.table4$size <- 1024

sequence.table <- rbind(sequence.table1, sequence.table2, sequence.table3, sequence.table4)

sequence.table %>%
  group_by(x, y, size) %>%
  dplyr::summarise(count = dplyr::n()) -> count.table

count.table$x <- as.factor(count.table$x)
count.table$y <- as.factor(count.table$y)

g <- ggplot(count.table, aes(x, y, fill = count)) +
  geom_raster() +
  facet_wrap(. ~ size, ncol = 4, scales="free") +
  #coord_cartesian(xlim = c(0, 1024), ylim = c(0, 1024)) +
  theme(text = element_text(size = 25),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(), 
        axis.text.y = element_blank(),
        #axis.ticks = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank()) +
  scale_fill_gradient(low="blue", high="red") +
  labs(fill = "#Msg") 

plot(g)

IMG_height = 2
IMG_width = 7.5

ggsave(plot = g, filename = "~/CBNet/tor-heatmap.pdf", 
       units = "cm", 
       height = IMG_height,
       width = IMG_width,
       device = "pdf", scale = 5.0)

