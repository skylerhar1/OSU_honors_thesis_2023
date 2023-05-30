#!/bin/bash
eval "$(conda shell.bash hook)"
conda activate /local/cluster/funannotate-1.8.14
funannotate sort -i cleaned_gap_closer.fasta -o sorted_gap_closer.fasta -b scaffold


conda deactivate
