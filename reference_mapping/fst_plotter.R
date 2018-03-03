### fst_plotter - v0.1 ###
# plots fst from vcftools output
# Mark Ravinet - 10/02/16

rm(list = ls())
require(getopt)
require(ggplot2)

# specify command line options
spec <- matrix(c(
  'sites', 's', 1, 'character', 'specify sites file',
  'window', 'w', 1, 'character', 'specify window file',
  'output', 'o', 1, 'character', 'specify output path',
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
sites_input <- opt$sites
window_input <- opt$window
output <- opt$output

# sites_input <- "./stickleback/full_site.weir.fst"
# window_input <- "./stickleback/full_site.windowed.weir.fst"
# output <- "fst_plot.pdf"

# read data
sites <- read.delim(sites_input)
window <- read.delim(window_input)

# sort out column names
colnames(sites) <- tolower(colnames(sites))
colnames(sites)[3] <- "fst"
colnames(window) <- tolower(colnames(window))

# remove unneeded chromosomes - scaffolds and sex chromosome
sites <- sites[!(sites$chrom == "chrUn" | sites$chrom == "chrXIX"), ]
window <- window[!(window$chrom == "chrUn" | window$chrom == "chrXIX"), ]
# relevel factor
sites$chrom <- factor(as.character(sites$chrom))
window$chrom <- factor(as.character(window$chrom))

# reorder factor
sites$chrom <- factor(sites$chrom, levels(sites$chrom)[c(1:4, 6:9, 5, 10:20)])
window$chrom <- factor(window$chrom, levels(window$chrom)[c(1:4, 6:9, 5, 10:20)])

# add midpoint to sliding window data
window$pos <- (window$bin_start + window$bin_end)/2
# also add fst variable to make plotting easier (so ggplot will recognise)
window$fst <- window$mean_fst

# set plot theme
custom_theme <- theme_bw() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.key = element_blank(),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.title.x = element_text(size = 14),
        axis.title.y = element_text(size = 14),
        strip.text = element_text(size = 12),
        strip.background = element_rect(fill = "light grey"))

# plot fst
p <- ggplot(sites, aes(pos/10^6, fst))
p <- p + geom_point(col = "sky blue", alpha = 0.5)
p <- p + geom_line(data = window)
p <- p + facet_wrap(~chrom, ncol = 4, scales = "free_x")
p <- p + xlab("Position (Mbp)") + ylab(expression(italic(F)[ST]))
fst_plot <- p + custom_theme
ggsave(output, fst_plot, width = 12, height = 8)


