library(reshape) # to rename columns
library(reshape2) # to rename columns
library(data.table) # to make sliding window dataframe
library(zoo) # to apply rolling function for sliding window
library(dplyr)
library(ggplot2)
library(tidyverse)
require(gridExtra)
require(ggpubr)
gene_statistics<- read.csv(file="chrom_pos_depth_repeats_gene_het2.table", header = T, sep = " ",row.names=NULL)
#remove gene_statistics

#modify column names
colnames(gene_statistics) <- colnames(gene_statistics)[2:ncol(gene_statistics)]
colnames(gene_statistics) <- c("CHROM","POS","DEPTH", "REPEAT", "GENE", "HET")
mean(gene_statistics$GENE)
head(gene_statistics)
tail(gene_statistics)
#genome_size <-33824327
#reflow the positions to be continuous
#gene_statistics$POS <- c(1:genome_size)
#centromere vector
centromere_pos<-c(510000,3200000,3090000,1570000,430000,2500000,1460000,960000,1200000,1000000,720000)
scaffold_order<-c("Scaffold2","Scaffold1","Scaffold3","Scaffold6","Scaffold4","Scaffold5","Scaffold8","Scaffold9","Scaffold7","Scaffold10","Scaffold11")

plot_list<- list()


#chromosome statistics as sliding window
gene_statistics.depth_average<-setDT(gene_statistics)[, .(
  window.start = rollapply(POS, width=50000, by=10000, FUN=min, align="left", partial=FALSE),
  window.end = rollapply(POS, width=50000, by=10000, FUN=max, align="left", partial=FALSE),
  coverage = rollapply(DEPTH, width=50000, by=10000, FUN=mean, align="left", partial=FALSE)
), .(CHROM)]

gene_statistics.repeat_average<-setDT(gene_statistics)[, .(
  window.start = rollapply(POS, width=50000, by=10000, FUN=min, align="left", partial=FALSE),
  window.end = rollapply(POS, width=50000, by=10000, FUN=max, align="left", partial=FALSE),
  coverage = rollapply(REPEAT, width=50000, by=10000, FUN=mean, align="left", partial=FALSE)
), .(CHROM)]

gene_statistics.het_average<-setDT(gene_statistics)[, .(
  window.start = rollapply(POS, width=50000, by=10000, FUN=min, align="left", partial=FALSE),
  window.end = rollapply(POS, width=50000, by=10000, FUN=max, align="left", partial=FALSE),
  coverage = rollapply(HET, width=50000, by=10000, FUN=mean, align="left", partial=FALSE)
), .(CHROM)]

gene_statistics.gene_average<-setDT(gene_statistics)[, .(
  window.start = rollapply(POS, width=50000, by=10000, FUN=min, align="left", partial=FALSE),
  window.end = rollapply(POS, width=50000, by=10000, FUN=max, align="left", partial=FALSE),
  coverage = rollapply(GENE, width=50000, by=10000, FUN=mean, align="left", partial=FALSE)
), .(CHROM)]
cor_vec<- 1:6
cor_vec[1]<-cor((gene_statistics.gene_average$coverage*50000),gene_statistics.repeat_average$coverage)
cor_vec[2]<-cor((gene_statistics.gene_average$coverage*50000),log(gene_statistics.depth_average$coverage))
cor_vec[3]<-cor((gene_statistics.gene_average$coverage*50000),gene_statistics.het_average$coverage)
cor_vec[4]<-cor(gene_statistics.het_average$coverage,gene_statistics.repeat_average$coverage)
cor_vec[5]<-cor(gene_statistics.het_average$coverage,log(gene_statistics.depth_average$coverage))
cor_vec[6]<-cor(gene_statistics.repeat_average$coverage,log(gene_statistics.depth_average$coverage))

cor_vec
#getting the rDNA coverage spike values for sliding window
highest_cov<-gene_statistics.depth_average$coverage[which(gene_statistics.depth_average$coverage > 2000)]
median_cov<-median(gene_statistics$DEPTH)
mean_cov<-mean(gene_statistics$DEPTH)
#not sliding window
highest_cov1<-gene_statistics$DEPTH[which.max(gene_statistics$DEPTH)]
median_cov1<-median(gene_statistics$DEPTH[gene_statistics$CHROM == 10])
mean_cov1<-mean(gene_statistics$DEPTH)


#######################Calculating chromosomal means
#chromosomal depth means
d_mean_vec <- c(1:11)
for (i in 1:11){
  d_mean_vec[i]<-mean(gene_statistics$DEPTH[gene_statistics$CHROM == i])
}
d_mean_vec

#chromosomal repeat means
r_mean_vec <- c(1:11)
for (i in 1:11){
  r_mean_vec[i]<-mean(gene_statistics$REPEAT[gene_statistics$CHROM == i])
}
r_mean_vec

#chromosomal gene means
g_mean_vec <- c(1:11)
for (i in 1:11){
  g_mean_vec[i]<-mean(gene_statistics$GENE[gene_statistics$CHROM == i])
}
g_mean_vec

#chromosomal het means
h_mean_vec <- c(1:11)
for (i in 1:11){
  h_mean_vec[i]<-mean(gene_statistics$HET[gene_statistics$CHROM == i])
}
d_mean_vec
r_mean_vec
g_mean_vec
h_mean_vec
#reorder LGs so they make sense
mean_chr_stats<-data.frame(scaffold_order,d_mean_vec, r_mean_vec, g_mean_vec, h_mean_vec)
mean_chr_stats<-mean_chr_stats[order(scaffold_order),]
tmp<-mean_chr_stats[2,]
tmp2<-mean_chr_stats[3,]
mean_chr_stats<-mean_chr_stats[-c(2,3),]
mean_chr_stats[10,] <- tmp
mean_chr_stats[11,] <- tmp2
colnames(mean_chr_stats)<- c("LG", "Mean_Depth", "Mean_Repeat_Density", "Mean_Gene_Density", "Mean_Heterozygous_SNP_Density")
mean_chr_stats$LG <- factor(mean_chr_stats$LG,                                    # Change ordering manually
                                  levels = c("Scaffold1","Scaffold2","Scaffold3","Scaffold4","Scaffold5","Scaffold6","Scaffold7","Scaffold8","Scaffold9","Scaffold10","Scaffold11"))
mean_chr_stats


#############Genome wide means
genome_mean_depth<-mean(gene_statistics$DEPTH)
genome_mean_repeat<-mean(gene_statistics$REPEAT)
genome_mean_gene<-mean(gene_statistics$GENE)
genome_mean_het<-mean(gene_statistics$HET)
############Genome wide SDs
genome_sd_depth<-sd(gene_statistics$DEPTH)
genome_sd_repeat<-sd(gene_statistics$REPEAT)
genome_sd_gene<-sd(gene_statistics$GENE)
genome_sd_het<-sd(gene_statistics$HET)



#depth plot
depth_df<-mean_chr_stats[,1:2]
z_scores_depth <- (depth_df$Mean_Depth-mean(depth_df$Mean_Depth))/sd(depth_df$Mean_Depth)
p_depth<-ggplot(data=depth_df, aes(x=LG,y=Mean_Depth)) +
  geom_bar(stat="identity")
p_depth
#repeat plot
repeat_df<-mean_chr_stats[,c(1,3)]

z_scores_repeat <- (repeat_df$Mean_Repeat_Density-mean(repeat_df$Mean_Repeat_Density))/sd(repeat_df$Mean_Repeat_Density)

p_repeat<-ggplot(data=repeat_df, aes(x=LG,y=Mean_Repeat_Density)) +
  geom_bar(stat="identity")
p_repeat
#Gene plot
Gene_df<-mean_chr_stats[,c(1,4)]
boxplot(Gene_df$Mean_Gene_Density)
z_scores_Gene <- (Gene_df$Mean_Gene_Density-mean(Gene_df$Mean_Gene_Density))/sd(Gene_df$Mean_Gene_Density)
p_Gene<-ggplot(data=Gene_df, aes(x=LG,y=Mean_Gene_Density)) +
  geom_bar(stat="identity")
p_Gene
#Het plot
Het_df<-mean_chr_stats[,c(1,5)]
z_scores_Het <- (Het_df$Mean_Heterozygous_SNP_Density-mean(Het_df$Mean_Heterozygous_SNP_Density))/sd(Het_df$Mean_Heterozygous_SNP_Density)
p_Het<-ggplot(data=Het_df, aes(x=LG,y=Mean_Heterozygous_SNP_Density)) +
  geom_bar(stat="identity")
p_Het

z_score_matrix<-cbind(z_scores_depth,z_scores_repeat,z_scores_Gene,z_scores_Het)
z_score_df<-data.frame(mean_chr_stats$LG,z_score_matrix)
write.csv(z_score_df, "C:/Users/Skyler/Documents/loose work files/scaffold all plots/z_score_table.csv", row.names=FALSE)

#####calculate sum of repeats per chromosomes

#chromosomal repeat sums
repeat_sum_vec <- c(1:11)
chr_lengths<- c(1:11)

for (i in 1:11){
  repeat_sum_vec[i]<-sum(gene_statistics$REPEAT[gene_statistics$CHROM == i])
  chr_lengths[i]<-max(gene_statistics$POS[gene_statistics$CHROM == i])
}
repeat_sum_vec
chr_lengths
repeat_to_non_repeat_ratio<-repeat_sum_vec/(chr_lengths-repeat_sum_vec)
ratio_df<-data.frame(scaffold_order,repeat_to_non_repeat_ratio, row.name = FALSE)

#reorder LGs so they make sense
ratio_df<-ratio_df[order(scaffold_order),]
tmp<-ratio_df[2,]
tmp2<-ratio_df[3,]
ratio_df<-ratio_df[-c(2,3),]
ratio_df[10,] <- tmp
ratio_df[11,] <- tmp2
ratio_df$scaffold_order <- factor(ratio_df$scaffold_order,                                    # Change ordering manually
                  levels = c("Scaffold1","Scaffold2","Scaffold3","Scaffold4","Scaffold5","Scaffold6","Scaffold7","Scaffold8","Scaffold9","Scaffold10","Scaffold11"))
p_ratio<-ggplot(data=ratio_df, aes(x=scaffold_order,y=repeat_to_non_repeat_ratio)) +
  geom_bar(stat="identity") +
  xlab("Scaffold")
p_ratio
fisher.test(het_df)

#Median depth of ITS region
chr_10<-gene_statistics[which(gene_statistics$CHROM == 10),]
median(chr_10$DEPTH[which(chr_10$POS > 933000 & chr_10$POS < 947000)])

#Median depth of Scaffold3 segmental duplication
chr_3<-gene_statistics.depth_average[which(gene_statistics.depth_average$CHROM == 3),]

cov.average.plot <- ggplot(chr_3, aes(x=window.end, y=coverage, colour=CHROM)) + 
  geom_point(shape = 20, size = 2, colour=chr_3$CHROM) +
  geom_line(colour=chr_3$CHROM, size = 0.1)+
  scale_x_continuous(name="Genomic Position (bp)", limits=c(0,3480000),labels = scales::comma,breaks = scales::pretty_breaks(n = 30)) +
  scale_y_continuous(name="Average Coverage Depth", limits=c(0, 450))+
  ggtitle("P_212", subtitle = "Reference Genome")

cov.average.plot
duplication_med_cov<-median(chr_3$coverage[which(chr_3$window.start > 1300000 & chr_3$window.end < 2700000)])
not_dup_med_cov<-median(chr_3$coverage[which(chr_3$window.start > 2700000 | chr_3$window.start <1300000)])
duplication_med_cov/not_dup_med_cov
#Median depth of Scaffold 8 segmental duplication
#use chrom = 7 due to sort differences
chr_8<-gene_statistics.depth_average[which(gene_statistics.depth_average$CHROM == 7),]
#detirmin duplication range
cov.average.plot <- ggplot(chr_8, aes(x=window.end, y=coverage, colour=CHROM)) + 
  geom_point(shape = 20, size = 2, colour=chr_8$CHROM) +
  geom_line(colour=chr_8$CHROM, size = 0.1)+
  scale_x_continuous(name="Genomic Position (bp)", limits=c(0,2800000),labels = scales::comma,breaks = scales::pretty_breaks(n = 30)) +
  scale_y_continuous(name="Average Coverage Depth", limits=c(0, 450))+
  ggtitle("P_212", subtitle = "Reference Genome")

cov.average.plot
duplication_med_cov<-median(chr_8$coverage[which(chr_8$window.start >= 800000)])
not_dup_med_cov<-median(chr_8$coverage[which(chr_8$window.start <800000)])
duplication_med_cov/not_dup_med_cov
chr_8$window.end[which.max(chr_8$window.end)]
