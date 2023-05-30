
source /local/cluster/funannotate-1.8.14/activate.sh
funannotate train -i gap_closed_assembly.fa -o gap_closed_fun  -l ../raw_data/P_212_1.fq.gz -r ../raw_data/P_212_2.fq.gz --jaccard_clip --cpus 8

conda deactivate
