#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -N BWA_aligner
#$ -V
#$ -t 1-2:1
i=$(expr $SGE_TASK_ID - 1)
REF="/nfs1/BPP/Spatafora_Lab/hars/whatshap_phasing/gap_closer.fasta"
FILE=( `cat gap_closer_reads.list`)
IFS=';' read -a arr <<< "${FILE[$i]}"
mkdir -p gap_closer_sams
mkdir -p gap_closer_bams
echo "${arr[1]}"
###
# Step 1: BWA mapping
# The GATK needs read group info:
# https://software.broadinstitute.org/gatk/guide/article?id=6472
# SM: sample
# LB: library, may be sequenced multiple times
# ID: Read Group Identifier, a unique identifier
# PL: Platform/technology used
RG="@RG\tID:${arr[0]}\tLB:${arr[0]}\tPL:illumina\tSM:${arr[0]}\tPU:${arr[0]}"
echo "Mapping reads using BWA"
echo "#####"
CMD="/raid1/home/bpp/tabimaj/bin/bwa/bwa mem -c 1 -M -R \"$RG\" $REF ${arr[1]} ${arr[2]} > gap_closer_sams/${arr[0]}.sam"
echo $CMD
eval $CMD
echo -n "BWA finished at "
date
#
###
###
# Step 2. SAMtools post-processing
echo "SAMtools: Fixing mates"
echo "#####"
CMD="samtools view -bSu gap_closer_sams/${arr[0]}.sam | samtools sort -n -O bam -o gap_closer_bams/${arr[0]}_nsort -T gap_closer_bams/${arr[0]}_nsort_tmp"
echo $CMD
eval $CMD
CMD="samtools fixmate -O bam gap_closer_bams/${arr[0]}_nsort /dev/stdout | samtools sort -O bam -o - -T gap_closer_bams/${arr[0]}_csort_tmp | samtools calmd -b - $REF > gap_closer_bams/${arr[0]}_fixed.bam"
echo $CMD
eval $CMD
echo -n "SAMtools step 1 finished at "
date
#
# Step 3. PICARD tools marking duplicates
echo "PICARD: Marking duplicates"
echo "#####"
CMD="/raid1/home/bpp/tabimaj/bin/jre1.8.0_144/bin/java -Xmx4g -Djava.io.tmpdir=/data -jar /raid1/home/bpp/tabimaj/bin/picard.jar MarkDuplicates I=gap_closer_bams/${arr[0]}_fixed.bam O=gap_closer_bams/${arr[0]}_dupmrk.bam MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000 ASSUME_SORT_ORDER=coordinate M=gap_closer_bams/${arr[0]}_marked_dup_metrics.txt"
echo $CMD
eval $CMD
CMD="samtools index gap_closer_bams/${arr[0]}_dupmrk.bam"
echo $CMD
eval $CMD
echo -n "PICARD: Marking duplicates finished at "
date
echo "Indel Realigner"
CMD="/raid1/home/bpp/tabimaj/bin/jre1.8.0_144/bin/java -Xmx4g -Djava.io.tmpdir=/data -jar /raid1/home/bpp/tabimaj/bin/GenomeAnalysisTK.jar -T RealignerTargetCreator -R $REF -I gap_closer_bams/${arr[0]}_dupmrk.bam -o gap_closer_bams/${arr[0]}.intervals"
echo $CMD
eval $CMD
CMD="/raid1/home/bpp/tabimaj/bin/jre1.8.0_144/bin/java -Xmx4g -Djava.io.tmpdir=/data -jar /raid1/home/bpp/tabimaj/bin/GenomeAnalysisTK.jar -T IndelRealigner -R $REF -I gap_closer_bams/${arr[0]}_dupmrk.bam -targetIntervals gap_closer_bams/${arr[0]}.intervals -o gap_closer_bams/${arr[0]}.reindel.bam --consensusDeterminationModel USE_READS -LOD 0.4"
echo $CMD
eval $CMD
###
