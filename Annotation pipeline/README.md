# Reference-genome-annotation
Overview of the process can also be found at: https://funannotate.readthedocs.io/en/latest/tutorials.html Most of these processes were run through SGE_Batch except for "sort", "clean" and "mask" steps were ran through qrsh

an example of using SGE_Batch: `eval "$(conda shell.bash hook)" conda activate /local/cluster/funannotate-1.8.9/ SGE_Batch -c "<script you want to run>" -r <log_name> -q <node EX:bpp@galls> -P <#CPU's> -m

conda deactivate`

_gapcloser.1.2 was obtained from /nfs1/BPP/Spatafora_Lab/paez/Pogon_assembly/P212_Ass/redundans/scaffolding-closing_test/_gapcloser.1.2.fa

Script “cleans” an assembly by looking for duplicated contigs. The script first sorts the contigs by size, then starting with the shortest contig it runs a “leave one out” alignment using Mummer to determine if contig is duplicated elsewhere.

funannotate clean -i _gapcloser.1.2.fa --minlen 1000 -o _gapcloser.1.2.cleaned.fa

Sort scaffolds by length and renames headers

funannotate sort -i _gapcloser.1.2.cleaned.fa -b scaffold -o _gapcloser.1.2.cleaned.sorted.fa

softmask repeats

funannotate mask -i _gapcloser.1.2.cleaned.sorted.fa -o _gapcloser.1.2.cleaned.sorted.masked.fa

rename it to something nicer

mv _gapcloser.1.2.cleaned.sorted.masked.fa my-assembly.fa

align RNA-seq data, run Trinity, and then run PASA (train_script.sh)

funannotate train -i my-assembly.fa -o fun2  -l P_212_1.fq.gz -r P_212_2.fq.gz --jaccard_clip --cpus 8

train augustus and provide protein evidence(predict.sh)

funannotate predict -i my-assembly.fa -o fun2 --species 'Rhizopogon salebrosus' --protein_evidence protien_evidence/Rhives1.fasta protien_evidence/Rhivi1.fasta protien_evidence/Suibr2.fasta protien_evidence/Suiocc1.fasta

add UTR data to the predictions and fix gene models that are in disagreement with the RNA-seq data (update_script.sh)

funannotate update -i fun2 --cpus 8

Fix gene models manually in the .tbl file. Adjust gene lengths so they don't overlap with assembly gaps. Details cant be found in Rhizopogon_salebrosus.models-need-fixing. The deleted gene model can be found in FUN_004116. One gene model was deleted. Then ran (fix.sh)

funannotate fix -i fun2/update_results/Rhizopogon_salebrosus.gbk -t fix_6/Rhizopogon_salebrosus_deleted_004116_test.txt

in fun2 changed update_results/ to update_results_need_fixed/ then moved fix6/ into fun2/ and labelled fix6 as update_results/

Running InterProScan5 (iprscan_script.sh)

funannotate iprscan -i fun2 -m local --iprscan_path /local/cluster/interproscan/interproscan/interproscan.sh --cpus 4

running antismash locally for secondary metabolites. Could not do this through funannotate due to multiple versions of gene models.(antismash_local.sh)

antismash --cb-general --cb-knownclusters --cb-subclusters --asf --pfam2go --smcog-trees --genefinding-gff3 fun2/update_results/Rhizopogon_salebrosus.gff3 fun2/update_results/Rhizopogon_salebrosus.scaffolds.fa --output-dir fun2_antismash

Take a deep breath- finaly annotation(annotate.sh)

funannotate annotate -i fun2  --cpus 4 