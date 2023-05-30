library(reshape) # to rename columns
library(data.table) # to make sliding window dataframe
library(zoo) # to apply rolling function for sliding window
library(dplyr)
library(ggplot2)
library(tidyverse)
het<- read.csv(file="P212_all_pos_het.table", header = T, sep = " ",row.names=NULL)
#modify column names
colnames(het) <- colnames(het)[2:ncol(het)]
colnames(het) <- c("CHROM","POS","HET")
mean(het$HET)
head(het)
tail(het)
#genome_size <-33824324
#34100419
#reflow the positions to be continuous
het$POS <- c(1:genome_size)

#genome coverage as sliding window
het.average<-setDT(het)[, .(
  window.start = rollapply(POS, width=50000, by=10000, FUN=min, align="left", partial=TRUE),
  window.end = rollapply(POS, width=50000, by=10000, FUN=max, align="left", partial=TRUE),
  coverage = rollapply(HET, width=50000, by=10000, FUN=mean, align="left", partial=TRUE)
), .(CHROM)]
#breaks = scales::pretty_breaks(n = 20) controls the amount of number on the bottom of the graph
het.average.plot <- ggplot(het.average, aes(x=window.end, y=coverage, colour=CHROM)) + 
  geom_point(shape = 20, size = 2, colour=het.average$CHROM) +
  geom_line(colour=het.average$CHROM, size = 0.1)+
  scale_x_continuous(name="Genomic Position (bp)", limits=c(0,33824324),labels = scales::comma,breaks = scales::pretty_breaks(n = 10)) +
  scale_y_continuous(name="Average Heterozygosity", limits=c(0, 0.1))+
  ggtitle("P_212", subtitle = "Reference Genome")
het.average.plot






