#!/bin/bash
#$ -N mkgvcf_uf
#$ -V
#$ -cwd
#$ -S /bin/bash
#$ -l mem_free=10G
#$ -t 1-1:1

i=$(expr $SGE_TASK_ID - 1)
FILE=( `cat "/nfs1/BPP/Spatafora_Lab/hars/whatshap_phasing/gap_closer_bams.list" `)
IFS=';' read -r -a arr <<< "${FILE[$i]}"

mkdir -p gap_closer_gvcf/

REF="/nfs1/BPP/Spatafora_Lab/hars/whatshap_phasing/gap_closer.fasta"


CMD="/raid1/home/bpp/tabimaj/bin/gatk-4.0.1.2/gatk --java-options \"-Xmx10g -Djava.io.tmpdir=/data\" HaplotypeCaller --reference $REF --ERC GVCF -ploidy 2 --input ${arr[1]} -O gap_closer_gvcf/${arr[0]}.g.vcf.gz"
echo $CMD
eval $CMD

echo
date
echo "mkgvcf finished."

myEpoch=(`date +%s`)
echo "Epoch start:" $myEpoch

# EOF.
