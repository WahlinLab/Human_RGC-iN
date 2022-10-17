# This script was adapted from a script provided by the Intergalactic Utilities Commission (IUC)

# Load packages -----------------------------------------------------------

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
  library(ggrepel)
})

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
path <- "./raw/Conditions_CTL_vs_NAIBC1.csv"

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
top <- slice_min(results, order_by = fdr, n = 50)
toplabels <- pull(top, labels)
# USE THIS METHOD TO ADD CUSTOM GENE LABELS
custlabels <- c("ATOH7","POU4F2","POU4F1","ONECUT1","NEUROD1","NEUROD4","NEUROG2","P2RY12","GLUL","SOX2","PODXL","VIM","SLC1A3","PAX6","KLF4","CSPG4","RLBP1","TMEM119","DRGX","DCX","ONECUT2","APOLD1","MYC","FZD5","PDGFRA","ACP6","HMGA2","HSPG2","ANXA3","SOX9", "PAX6")

toplabels <- c(toplabels, custlabels)
print(toplabels)

# Label just the top genes in results table

results <- mutate(results, labels = ifelse(labels %in% toplabels, labels, ""))


# Create plot -------------------------------------------------------------

# Open file to save plot as PDF
pdf(file="./out/volcano.pdf", width=11,height=12)

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
