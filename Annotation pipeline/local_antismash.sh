#!/bin/bash

source /local/cluster/antismash/activate.sh
antismash --cb-general --cb-knownclusters --cb-subclusters --asf --pfam2go --smcog-trees --genefinding-gff3 /nfs1/BPP/Spatafora_Lab/hars/final_reference_assembly/gap_closed_fun/update_results/Rhizopogon_salebrosus.gff3 /nfs1/BPP/Spatafora_Lab/hars/final_reference_assembly/gap_closed_fun/update_results/Rhizopogon_salebrosus.scaffolds.fa --output-dir gap_closed_antismash

conda deactivate 