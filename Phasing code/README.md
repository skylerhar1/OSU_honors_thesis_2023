In order to use whatshap, we needed to generate three different files: One Bam file from mapping nanopore reads to the reference, 
One Bame file from mapping illumina reads to the reference genome,
one vcf file generated from mapping variant found by mapping illumina reads to the reference.
steps  2-4 were called using qsub

Here is the order that these scripts were run
1) Nanopore_read_mapping.sh
2) Illumina_BWA_aligner.sh
3) Illumina_gVCF.sh
4) Illumina_genotype.sh
5) Whatshap_script_with_gap_closed_reference.sh
6) Whatshap_stats.sh
