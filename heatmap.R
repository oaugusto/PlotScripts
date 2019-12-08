
library(tidyverse)

# setup
options(scipen = 999)
theme_set(theme_bw())

sequence.table <- read.csv(file = "./hpcDS/exact_boxlib_multigrid_c_large.txt", skip = 1, col.names = c("x", "y"), header = FALSE)

sequence.table %>%
  group_by(x, y) %>%
  summarise(count = n()) -> count.table

count.table$x <- as.factor(count.table$x)
count.table$y <- as.factor(count.table$y)

g <- ggplot(count.table, aes(x, y, fill = count)) +
  geom_raster() +
  #coord_cartesian(xlim = c(1, 128), ylim = c(1, 128)) +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(), 
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank()) 

plot(g)

IMG_height = 7
IMG_width = 7

ggsave(plot = g, filename = "~/CBNet/trace_0_8.pdf", 
       units = "cm", 
       height = IMG_height,
       width = IMG_width,
       device = "pdf", scale = 4.0)

