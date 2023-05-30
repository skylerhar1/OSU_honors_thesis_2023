eval "$(conda shell.bash hook)"
conda activate /local/cluster/funannotate-1.8.14/



funannotate predict -i gap_closed_assembly.fa -o gap_closed_fun --species 'Rhizopogon salebrosus' --optimize_augustus --cpus 12 \
 --protein_evidence ../raw_data/protien_evidence/Rhives1.fasta ../raw_data/protien_evidence/Rhivi1.fasta ../raw_data/protien_evidence/Suibr2.fasta ../raw_data/protien_evidence/Suiocc1.fasta

conda deactivate
