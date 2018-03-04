### pca_plot.R - v0.1 ###
# plots PCA using adegenet
# Mark Ravinet - 10/02/17

rm(list = ls())

require(getopt)
require(adegenet)
require(ggplot2)

# specify command line options
spec <- matrix(c(
  'infile', 'i', 1, 'character', 'specify infile',
  'outfile', 'o', 1, 'character', 'specify outfile',
  'naxes', 'n', 1, 'numeric', 'specify the number of axes',
  'help', 'h', 0, 'logical', 'display helpful help'
), ncol = 5, byrow = T)

# set command line options
opt = getopt(spec)

# show help if asked for
if (!is.null(opt$help)) {
  cat(paste(getopt(spec, usage=T),"\n"));
  q();
}

# set variables for call
infile <- opt$infile
outfile <- opt$outfile

# set naxes
if (is.null(opt$fdr)) {
  naxes <- 2
} else{
  naxes <- opt$naxes
}

# set variables
# infile <- "./evop_pca/plink.raw"
# outfile <- "./PCA_plot.pdf"
# naxes <-  2

# read in plink file
myData <- read.PLINK(infile)

# get population data
spp <- unlist(lapply(strsplit(myData@ind.names, "_"), function(y) y[3]))
spp <- sub("C", "citrinellus", spp)
spp <- sub("L", "labiatus", spp)
myData@pop <- as.factor(spp)

# generate hierachy
hier <- data.frame(ind = myData@ind.names, spp)

# make a distance matrix
x <- seploc(myData, n.block = 5, parallel = T)
ldist <- lapply(x, function(y) dist(as.matrix(y)))
dist <- Reduce("+", ldist) 

# perform PCA
pca <- glPca(myData, nf = naxes, parallel = T)

# make data into a dataframe
myDF <- data.frame(id = myData@ind.names, pop = myData@pop, pca$scores, row.names = NULL)

# get eigen values
pve <- (pca$eig/sum(pca$eig))*100


# plot data
p <- ggplot(myDF, aes(PC1, PC2, colour = pop)) + geom_point(size = 3)
p <- p + xlab(paste0("PC1 (", signif(pve[1], 3), "%)"))
p <- p + ylab(paste0("PC2 (", signif(pve[2], 3), "%)"))
p + theme(legend.title = element_blank(), legend.position = "bottom")
  
# write plot to output
ggsave(outfile, p, width = 8, height = 6)




