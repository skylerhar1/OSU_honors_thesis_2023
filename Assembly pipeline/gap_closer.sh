#!/bin/bash
#This script uses a nanopore fasta file to gap close a genome assembly
nanopore_fasta="/nfs1/BPP/Spatafora_Lab/skyler_caro_shared_dir/Spatafora_20221219_Pogon.fasta"
pilon_path="/nfs1/BPP/Spatafora_Lab/hars/bin/pilon-1.23.jar"
reference="/nfs1/BPP/Spatafora_Lab/hars/final_reference_assembly/reference_chromosomes.fasta"
illumina_reads1="/nfs1/BPP/Spatafora_Lab/hars/reference_reads/P212_1.fasta"
illumina_reads2="/nfs1/BPP/Spatafora_Lab/hars/reference_reads/P212_2.fasta"
samtools_path="/local/cluster/bin/samtools"
java_path="/bin/java"
/nfs1/BPP/Spatafora_Lab/hars/bin/tgs_gapCloser/tgsgapcloser \
        --scaff  $reference \
        --reads  $nanopore_fasta \
        --output test_pilon_gapcloser \
        --pilon  $pilon_path  \
        --ngs    $illumina_reads1 $illumina_reads2 \
        --samtools $samtools_path  \
        --java    $java_path \
        >gap_closer.log 2>gap_closer.err

