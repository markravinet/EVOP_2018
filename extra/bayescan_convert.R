### bayescan_convert - v0.1 ###
# converts a snp matrix to bayescan input
# Mark Ravinet - 10/02/16

rm(list = ls())
require(getopt)

# specify command line options
spec <- matrix(c(
  'infile', 'i', 1, 'character', 'specify input geno matrix',
  'outfile', 'o', 1, 'character', 'specify path to write to',
  'pops', 'p', 0, 'character', 'specify population identifiers',
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

# process population names
if(is.null(opt$popnames)){
  pop <- c("L", "C")
} else{
  pop <- unlist(strsplit(opt$popnames, ","))
}

# set input files
# infile <- "./cichlid.geno"
# outfile <- "./cichlid_bayes.txt"

# read in data
sprintf("Reading %s", infile)
myData <- read.delim(infile)

# rename columns
colnames(myData)[1:3] <- c("chrom", "pos", "ref")

# remove NA values
myData[myData == "./."] <- NA

# set populations
npop <- length(pop)
nloci <- nrow(myData)
sprintf("%s populations", npop)
sprintf("%s loci", nloci)
sprintf("Populations are %s", paste(pop, collapse = " & "))


# convert to matrix
sprintf("Converting %s to Bayescan input", infile)
x <- as.matrix(myData[, 4:ncol(myData)])
# find populations
pop1 <- grep(pop[1], colnames(x))
pop2 <- grep(pop[2], colnames(x))
# calculate population sizes
pop_sizes <- c(length(pop1), length(pop2))

# count alleles
allele_counts <- apply(x, 1, function(z){
  ngen1 <- length(na.omit(z[pop1]))*2
  ngen2 <- length(na.omit(z[pop2]))*2
  alleles <- unique(unlist(strsplit(na.omit(z), "/")))
  nall <- length(alleles)
  all1 <- sapply(alleles, function(y){
    sum(unlist(strsplit(na.omit(z[pop1]), "/")) == y)
  })
  all2 <- sapply(alleles, function(y){
    sum(unlist(strsplit(na.omit(z[pop2]), "/")) == y)
  })
  list(pop1 = c(ngen1, nall, all1), pop2 = c(ngen2, nall, all2))
})
# assign to populations
pop1_all <- lapply(allele_counts, function(z) z$pop1)
pop2_all <- lapply(allele_counts, function(z) z$pop2)

sprintf("Conversion complete, writing to %s", outfile)
# write header to file
header <- paste("[loci]=", nloci, "\n\n", "[populations]=", npop, "\n", sep = "")
cat(header, file = outfile, append = F)
write(" ", file = outfile, append = TRUE)
# write pop 1 info
pop_info <- paste("[pop]=", c(1, 2), "\n", sep = "")
cat(pop_info[1], file = outfile, append = T)
# write pop1 data
lapply(1:nloci, function(z){
  test <- c(z, pop1_all[[z]], "\n")
  cat(test, file = outfile, append = T)
})
# write pop 2 info
cat("\n", file = outfile, append = T)
cat(pop_info[2], file = outfile, append = T)
# write pop2 data
lapply(1:nloci, function(z){
  test <- c(z, pop2_all[[z]], "\n")
  cat(test, file = outfile, append = T)
})
sprintf("%s written", outfile)

