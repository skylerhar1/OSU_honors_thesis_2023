#!/bin/bash
eval "$(conda shell.bash hook)"
conda activate /local/cluster/funannotate-1.8.9/

funannotate fix -i fun_HI/update_results/Rhizopogon_salebrosus.gbk -t fun_HI/update_results/Rhizopogon_salebrosus.tbl


