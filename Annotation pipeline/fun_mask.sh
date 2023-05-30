#!/bin/bash
eval "$(conda shell.bash hook)"
conda activate /local/cluster/funannotate-1.8.14
funannotate mask -i sorted_gap_closer.fasta -o gap_closed_assembly.fa


conda deactivate
