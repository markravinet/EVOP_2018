### Bayes_plot.R - v0.1 ###
# plots Bayescan outout
# Mark Ravinet - 10/02/16

rm(list = ls())
require(getopt)
require(ggplot2)

# specify command line options
spec <- matrix(c(
  'infile', 'i', 1, 'character', 'specify infile',
  'outfile', 'o', 1, 'character', 'specify outfile',
  'fdr', 'f', 0, 'numeric', 'specify false discovery rate',
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

# set fdr
if (is.null(opt$fdr)) {
  FDR <- 0.1
} else{
  FDR <- FDR
}

# dummy variables
# infile <- "../../My scientific papers/LittleCampbell/ddrads/outlier/bayescan/LC_roesti_080915_fst.txt"
# outfile <- "./bayes_plot.pdf"

# read in data
myData <- read.table(infile, sep = "", skip = 0, header = T)

# set FDR
FDR <- FDR

# set up factor - do loci pass threshold?
myData$threshold <- factor(ifelse(myData$qval <= FDR, "outlier", "neutral"))

# make plot
p <- ggplot(myData, aes(log10(qval), fst, colour = threshold))
p <- p + geom_point()
p <- p + xlim(0, min(log10(myData$qval))) + xlim(0, -2)
p <- p + geom_vline(xintercept = log10(FDR), lty = 2, lwd = 0.75)
p <- p + ylab(expression(paste(italic("F")[ST]))) + xlab(expression(paste("Log"[10], italic(" q"))))
p <- p + theme_bw()
bplot <- p + theme(legend.position = "bottom",
                   legend.title = element_blank(),
                   axis.title.x = element_text(size = 14, face = "bold"),
                   axis.title.y = element_text(size = 14, face = "bold"),
                   axis.text.x = element_text(size = 12), axis.text.y = element_text(size = 12),
                   legend.key = element_blank(), 
                   panel.grid = element_blank()) 

# write plot to output
ggsave(outfile, bplot, width = 12, height = 8)


