## plot fst data

rm(list = ls())

library(tidyverse)

# read in data
myData <- read_tsv("./cichlid.fst_citrinellus-labiatus.tsv")
# clear up
colnames(myData) <- c("batch", "locus", "pop1", "pop2", "chr", "bp", "col", "pi", "fst", "fishersp", "or", "ci_l", "ci_h", "LOD", "corr_fst", 
                      "smooth_fst", "AMOVA_fst", "corr_AMOVA_fst", "smooth_AMOVA_fst", "pval", "snp_window")

# gather fst
fst <- myData %>% select(corr_fst, AMOVA_fst) %>% gather(key = "stat", value = "fst")
fst$stat <- sub("_fst", "", fst$stat)

# make a plot
a <- ggplot(fst, aes(fst)) + geom_histogram(binwidth = 0.01, fill = "white", colour = "black")
a <- a + theme_light()  + xlab(expression(italic(F[ST])))
a <- a + facet_grid(stat~.)
a

# write it out
dev.print(pdf, "./fst_plot.pdf", height = 6, width = 8)
