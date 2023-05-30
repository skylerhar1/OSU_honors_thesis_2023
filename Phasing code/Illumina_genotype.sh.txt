#!/bin/bash
#$ -V
#$ -v TMPDIR=/data
#$ -N Geno_gap_closed_MATA
#$ -l mem_free=40G
#$ -l h=symbiosis
#$ -S /bin/bash
#$ -cwd

REF="/nfs1/BPP/Spatafora_Lab/hars/whatshap_phasing/gap_closer.fasta"
VCF="/nfs1/BPP/Spatafora_Lab/hars/whatshap_phasing/gap_closer_gvcf/P212_filtered_1.fq.gz.g.vcf.gz"
mkdir -p gap_closer_genotyped

CMD="/raid1/home/bpp/tabimaj/bin/gatk-4.0.1.2/gatk --java-options '-Xmx40g -Djava.io.tmpdir=/data -XX:ParallelGCThreads=1' GenotypeGVCFs -R $REF -V $VCF -new-qual -O gap_closer_genotyped/chromosomes.vcf.gz"

echo $CMD
eval $CMD

# EOF.
