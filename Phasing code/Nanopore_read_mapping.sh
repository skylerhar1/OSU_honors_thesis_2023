#!/bin/bash
reference="/nfs1/BPP/Spatafora_Lab/hars/whatshap_phasing/gap_closer.fasta"
input_sequences="/nfs1/BPP/Spatafora_Lab/skyler_caro_shared_dir/Spatafora_20221219_Pogon.fq.gz"
bwa mem -x ont2d $reference $input_sequences | samtools view - -Sb | samtools sort -  > gap_closer_nano_bams/mapping.sorted.bam
samtools index gap_closer_nano_bams/mapping.sorted.bam
