library(reshape) # to rename columns
library(reshape2) # to rename columns
library(data.table) # to make sliding window dataframe
library(zoo) # to apply rolling function for sliding window
library(dplyr)
library(ggplot2)
library(tidyverse)
require(gridExtra)
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
for(i in 1:11){
  chrom1<-gene_statistics[gene_statistics$CHROM==i,]
  rm(gene_statistics)
  #chromosome statistics as sliding window
  chrom1.depth_average<-setDT(chrom1)[, .(
    window.start = rollapply(POS, width=50000, by=10000, FUN=min, align="left", partial=FALSE),
    window.end = rollapply(POS, width=50000, by=10000, FUN=max, align="left", partial=FALSE),
    coverage = rollapply(DEPTH, width=50000, by=10000, FUN=mean, align="left", partial=FALSE)
  ), .(CHROM)]
  
  chrom1.repeat_average<-setDT(chrom1)[, .(
    window.start = rollapply(POS, width=50000, by=10000, FUN=min, align="left", partial=FALSE),
    window.end = rollapply(POS, width=50000, by=10000, FUN=max, align="left", partial=FALSE),
    coverage = rollapply(REPEAT, width=50000, by=10000, FUN=mean, align="left", partial=FALSE)
  ), .(CHROM)]
  
  chrom1.het_average<-setDT(chrom1)[, .(
    window.start = rollapply(POS, width=50000, by=10000, FUN=min, align="left", partial=FALSE),
    window.end = rollapply(POS, width=50000, by=10000, FUN=max, align="left", partial=FALSE),
    coverage = rollapply(HET, width=50000, by=10000, FUN=mean, align="left", partial=FALSE)
  ), .(CHROM)]
  
  chrom1.gene_average<-setDT(chrom1)[, .(
    window.start = rollapply(POS, width=50000, by=10000, FUN=min, align="left", partial=FALSE),
    window.end = rollapply(POS, width=50000, by=10000, FUN=max, align="left", partial=FALSE),
    coverage = rollapply(GENE, width=50000, by=10000, FUN=mean, align="left", partial=FALSE)
  ), .(CHROM)]
  num_obs<- length(chrom1.gene_average$coverage)
  new_df<-as.data.frame(matrix(nrow=num_obs,ncol=5))
  colnames(new_df)<-c("window.start","LOG_DEPTH", "REPEAT", "GENE_sum", "HET")
  new_df$window.start <- chrom1.depth_average$window.start
  new_df$REPEAT<- chrom1.repeat_average$coverage
  new_df$LOG_DEPTH <- log(chrom1.depth_average$coverage)
  new_df$GENE_sum <- chrom1.gene_average$coverage*50000
  new_df$HET <- chrom1.het_average$coverage
  
  
  #breaks = scales::pretty_breaks(n = 20) controls the amount of number on the bottom of the graph
  #melt data frame into long format
  new_df <- reshape2::melt(new_df ,  id.vars = 'window.start', variable.name = 'series', factorsAsStrings=F)
  
  #create line plot for each column in data frame

  if (i==1){#Scaffold2 MAT-A addition
    p<-ggplot(new_df, aes(window.start, value)) +
      geom_line() +
      #Adds centromere and other feature location manually
      geom_vline(xintercept = centromere_pos[i], colour = "blue",size=1.5)+
      geom_vline(xintercept =  2850000, size = 1.5, colour = "green")+
      facet_grid(series ~ ., scales = "free_y",switch = "y") + 
      ggtitle("P212 Sliding Window Statistics", subtitle = scaffold_order[i])+
      scale_x_continuous(name="Genomic Position (bp)",labels = scales::comma,breaks = scales::pretty_breaks(n = 10))+
      scale_y_continuous(name="50kb Sliding Window Mean")
  }else if (i == 2){#Scaffold 1 MAT-B location
  
    p<-ggplot(new_df, aes(window.start, value)) +
      geom_line() +
      #Adds centromere and other feature location manually
      geom_vline(xintercept = centromere_pos[i], colour = "blue",size=1.5)+
      geom_vline(xintercept = 720000, size =1.5, colour = "orange")+
  
      facet_grid(series ~ ., scales = "free_y",switch = "y") + 
      ggtitle("P212 Sliding Window Statistics", subtitle = scaffold_order[i])+
      scale_x_continuous(name="Genomic Position (bp)",labels = scales::comma,breaks = scales::pretty_breaks(n = 10))+
      scale_y_continuous(name="50kb Sliding Window Mean")
  } else if (i == 10){
    #Scaffold 10 rDNA addition
    p<-ggplot(new_df, aes(window.start, value)) +
      geom_line() +
      #Adds centromere and other feature location manually
      geom_vline(xintercept = centromere_pos[i], colour = "blue",size=1.5)+
      geom_vline(xintercept = 942000,size=1.5, colour = "dark red")+
      facet_grid(series ~ ., scales = "free_y",switch = "y") + 
      ggtitle("P212 Sliding Window Statistics", subtitle = scaffold_order[i])+
      scale_x_continuous(name="Genomic Position (bp)",labels = scales::comma,breaks = scales::pretty_breaks(n = 10))+
      scale_y_continuous(name="50kb Sliding Window Mean")
  } else {
    p<-ggplot(new_df, aes(window.start, value)) +
      geom_line() +
      #Adds centromere and other feature location manually
      geom_vline(xintercept = centromere_pos[i], colour = "blue",size=1.5)+
      facet_grid(series ~ ., scales = "free_y",switch = "y") + 
      ggtitle("P212 Sliding Window Statistics", subtitle = scaffold_order[i])+
      scale_x_continuous(name="Genomic Position (bp)",labels = scales::comma,breaks = scales::pretty_breaks(n = 10))+
      scale_y_continuous(name="50kb Sliding Window Mean")
  }
  print(p)
  plot_list[[i]]<-p
  gene_statistics<- read.csv(file="chrom_pos_depth_repeats_gene_het2.table", header = T, sep = " ",row.names=NULL)
  #modify column names
  colnames(gene_statistics) <- colnames(gene_statistics)[2:ncol(gene_statistics)]
  colnames(gene_statistics) <- c("CHROM","POS","DEPTH", "REPEAT", "GENE", "HET")
}
#Combine plots into manageable grids
grid.arrange(plot_list[[1]],plot_list[[2]],plot_list[[3]],plot_list[[5]],ncol=2)
grid.arrange(plot_list[[6]],plot_list[[4]],plot_list[[9]],plot_list[[7]],ncol = 2)
grid.arrange(plot_list[[8]],plot_list[[10]],plot_list[[11]],ncol=2)
#Create a Legend
plot(NULL ,xaxt='n',yaxt='n',bty='n',ylab='',xlab='', xlim=0:1, ylim=0:1)
legend("topleft", legend =c('Centromere', 'MAT-A', 'MAT-B',
                            'rDNA'), pch=16, pt.cex=3, cex=1.5, bty='n',
       col = c('blue','green','orange','dark red'))
mtext("Legend", at=0.2, cex=2)
table(centromere_pos)


#Median depth of all chromosomes


