## look at covariation in PCs and data issues

rm(list = ls())

library(tidyverse)

# read in pca
pca <- read_csv("./pca_data.csv")

# read in het
het <- read_tsv("./cichlid.het", col_names = c("id", "ho", "he", "nsites", "f"), skip = 1)
# read in depth
depth <- read_tsv("./cichlid.idepth", col_names = c("id", "n", "mean_depth"), skip = 1)
# read in missing data
miss <- read_tsv("./cichlid.imiss", col_names = c("id", "n", "n_fil", "n_miss", "f_miss"), skip = 1)

# join to make a dataset
myData <- left_join(pca, het, by = "id")
myData <- left_join(myData, depth, by = "id")
myData <- left_join(myData, miss, by = "id")

# subset data
myData <- myData %>% select(-starts_with("n"))
# gather data
myData_g <- myData %>% select(-ho, -he) %>% gather(key = "stat", value = "value", -id, -pop, -PC1, -PC2)

# plot data 
a <- ggplot(myData_g, aes(value, PC1, colour = pop)) + geom_point() + facet_wrap(~stat, scales = "free_x")
a <- a + theme_light() + theme(legend.position = "bottom")

# dev.print(pdf, , height = 6, width = 8)
ggsave("./pca_corr.pdf", a, width = 6, height = 8)

