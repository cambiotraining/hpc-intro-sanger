#!/bin/bash
#BSUB -q normal  # name of the partition to run job on
#BSUB -cwd FIXME  # working directory
#BSUB -o logs/estimate_pi.out  # standard output file
#BSUB -e logs/estimate_pi.err  # standard error file
#BSUB -n1        # number of CPUs. Default: 1
#BSUB -R"select[mem>1000] rusage[mem=1000]" # RAM memory part 1. Default: 100MB
#BSUB -M1000  # RAM memory part 2. Default: 100MB


Rscript FIXME
