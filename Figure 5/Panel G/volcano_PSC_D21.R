<<<<<<< HEAD
# This script was adapted from a script provided by the Intergalactic Utilities Commission (IUC)

# Load packages -----------------------------------------------------------

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
  library(ggrepel)
})

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
path <- "./raw/naipPSC_vs_D21.csv"

# Import data  ------------------------------------------------------------
results <- read.csv(path, header = TRUE)
# Format data  ------------------------------------------------------------

# Create columns from the column numbers specified
results <- results %>% mutate(fdr = .[[3]],
                              logfc = .[[2]],
                              labels = .[[1]])

# Get names for legend
down <- unlist(strsplit('Down,Not Sig,Up', split = ","))[1]
notsig <- unlist(strsplit('Down,Not Sig,Up', split = ","))[2]
up <- unlist(strsplit('Down,Not Sig,Up', split = ","))[3]

# Set colours
colours <- setNames(c("#67ab8e", "grey", "#a98de8"), c(down, notsig, up))

# Create significant (sig) column
results <- mutate(results, sig = case_when(
  fdr < 0.05 & logfc > 0.58 ~ up,
  fdr < 0.05 & logfc < -0.58 ~ down,
  TRUE ~ notsig))
write.csv(results, "./out/volcano.csv")


# Specify genes to label --------------------------------------------------

## Extract into vector ##

# USE THIS METHOD TO ADD GENE LABELS BASED ON TOP n GENES IN order_by CATEGORY
#top <- slice_min(results, order_by = fdr, n = 20)
#toplabels <- pull(top, labels)

# USE THIS METHOD TO ADD CUSTOM GENE LABELS
toplabels <- c("CNTN1", "SEMA6D", "SEMA6C", "DCX", "SOX2","MYC", "SLIT1", "NANOG", "KLF4", "POU4F1", "POU4F2", "SNCG", "ISL1", "RBFOX3", "SYN1", "NCAN", "NCAM1")

print(toplabels)

# Label just the top genes in results table

results <- mutate(results, labels = ifelse(labels %in% toplabels, labels, ""))


# Create plot -------------------------------------------------------------

# Open file to save plot as PDF
pdf(file="./out/volcano.pdf", width=10,height=10)

# Set up base plot
p <- ggplot(data = results, aes(x = logfc, y = -log10(fdr))) +
  geom_point(aes(colour = sig)) +
  scale_color_manual(values = colours) +
  theme(axis.line = element_line(colour = "black"))

# Add gene labels
p <- p + geom_label_repel(data = filter(results, labels != ""), aes(label = labels),
                          min.segment.length = 0,
                          max.overlaps = Inf,
                          show.legend = FALSE)


# Set legend title
p <- p + theme(legend.title = element_blank())

# Print plot
print(p)

# Close PDF graphics device
dev.off()
=======
# This script was adapted from a script provided by the Intergalactic Utilities Commission (IUC)

# Load packages -----------------------------------------------------------

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
  library(ggrepel)
})

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
path <- "./raw/naipPSC_vs_D21.csv"

# Import data  ------------------------------------------------------------
results <- read.csv(path, header = TRUE)
# Format data  ------------------------------------------------------------

# Create columns from the column numbers specified
results <- results %>% mutate(fdr = .[[3]],
                              logfc = .[[2]],
                              labels = .[[1]])

# Get names for legend
down <- unlist(strsplit('Down,Not Sig,Up', split = ","))[1]
notsig <- unlist(strsplit('Down,Not Sig,Up', split = ","))[2]
up <- unlist(strsplit('Down,Not Sig,Up', split = ","))[3]

# Set colours
colours <- setNames(c("#67ab8e", "grey", "#a98de8"), c(down, notsig, up))

# Create significant (sig) column
results <- mutate(results, sig = case_when(
  fdr < 0.05 & logfc > 0.58 ~ up,
  fdr < 0.05 & logfc < -0.58 ~ down,
  TRUE ~ notsig))
write.csv(results, "./out/volcano.csv")


# Specify genes to label --------------------------------------------------

## Extract into vector ##

# USE THIS METHOD TO ADD GENE LABELS BASED ON TOP n GENES IN order_by CATEGORY
#top <- slice_min(results, order_by = fdr, n = 20)
#toplabels <- pull(top, labels)

# USE THIS METHOD TO ADD CUSTOM GENE LABELS
toplabels <- c("CNTN1", "SEMA6D", "SEMA6C", "DCX", "SOX2","MYC", "SLIT1", "NANOG", "KLF4", "POU4F1", "POU4F2", "SNCG", "ISL1", "RBFOX3", "SYN1", "NCAN", "NCAM1")

print(toplabels)

# Label just the top genes in results table

results <- mutate(results, labels = ifelse(labels %in% toplabels, labels, ""))


# Create plot -------------------------------------------------------------

# Open file to save plot as PDF
pdf(file="./out/volcano.pdf", width=10,height=10)

# Set up base plot
p <- ggplot(data = results, aes(x = logfc, y = -log10(fdr))) +
  geom_point(aes(colour = sig)) +
  scale_color_manual(values = colours) +
  theme(axis.line = element_line(colour = "black"))

# Add gene labels
p <- p + geom_label_repel(data = filter(results, labels != ""), aes(label = labels),
                          min.segment.length = 0,
                          max.overlaps = Inf,
                          show.legend = FALSE)


# Set legend title
p <- p + theme(legend.title = element_blank())

# Print plot
print(p)

# Close PDF graphics device
dev.off()
>>>>>>> b56299771f995e4f3baac5ead30349c455998a0b
