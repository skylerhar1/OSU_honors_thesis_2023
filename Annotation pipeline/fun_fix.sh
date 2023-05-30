#!/bin/bash
eval "$(conda shell.bash hook)"
conda activate /local/cluster/funannotate-1.8.14/

funannotate fix -i gap_closed_fun/update_results/Rhizopogon_salebrosus.gbk -t gap_closed_fun/update_results/Rhizopogon_salebrosus.tbl


