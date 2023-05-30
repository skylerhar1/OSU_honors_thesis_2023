source /local/cluster/funannotate-1.8.14/activate.sh

funannotate iprscan -i gap_closed_fun -m local --iprscan_path /local/cluster/interproscan/interproscan/interproscan.sh --cpus 16
conda deactivate