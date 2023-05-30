# Reference-genome-annotation
Overview of the process can also be found at: https://funannotate.readthedocs.io/en/latest/tutorials.html Most of these processes were run through SGE_Batch except for "sort", "clean" and "mask" steps were ran through qrsh

an example of using SGE_Batch: `eval "$(conda shell.bash hook)" conda activate /local/cluster/funannotate-1.8.9/ SGE_Batch -c "<script you want to run>" -r <log_name> -q <node EX:bpp@galls> -P <#CPU's> -m`

This is the pipeline used to annotate the redundans assembly
gap_closed_fasta is the gap closed assembly. This assembly was not sorted by scaffold length at the time of annotation.

1) fun_clean.sh
2) fun_sort.sh
3) fun_mask.sh
4) fun_train.sh
5) fun_predict.sh
6) fun_update.sh
7) Fix gene models manually in the .tbl file. Adjust gene lengths so they don't overlap with assembly gaps. Details cant be found in Rhizopogon_salebrosus.models-need-fixing. 
8) fun_fix.sh
9) fun_ipr_scan.sh
10) local_smash.sh
11) fun_annotate.sh




