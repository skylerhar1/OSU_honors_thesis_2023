#!/bin/bash
#first read-backed whatshap phasing


#this is the path to the nanopore bams
input_bam_nano="/nfs1/BPP/Spatafora_Lab/hars/whatshap_phasing/gap_closer_nano_bams/mapping.sorted.bam"

#This is the path to the illumina bams
input_bam_illu="/nfs1/BPP/Spatafora_Lab/hars/whatshap_phasing/gap_closer_bams/P212_filtered_1.fq.gz.reindel.bam"
#vcf generated from illumina data
input_vcf="/nfs1/BPP/Spatafora_Lab/hars/whatshap_phasing/gap_closer_genotyped/chromosomes.vcf.gz"
#reference assembly
reference="/nfs1/BPP/Spatafora_Lab/hars/whatshap_phasing/gap_closer.fasta"
#command
echo "whatshap phase -o gap_closed_phased.vcf --ignore-read-groups  --merge-reads --error-rate 0.05 --indels --distrust-genotypes --include-homozygous --reference=$reference $input_vcf  $input_bam_illu $input_bam_nano"

eval "whatshap phase -o gap_closed_phased.vcf --ignore-read-groups  --merge-reads --error-rate 0.05 --indels --distrust-genotypes --include-homozygous --reference=$reference $input_vcf  $input_bam_illu $input_bam_nano"
