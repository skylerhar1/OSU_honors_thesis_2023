#!/bin/bash
eval "$(conda shell.bash hook)"
conda activate /local/cluster/funannotate-1.8.14
funannotate clean -i /nfs1/BPP/Spatafora_Lab/hars/final_reference_assembly/gap_closer.fasta -o cleaned_gap_closer.fasta -m 500

conda deactivate
