#!/bin/bash
#BSUB -q FIXME  # name of the partition to run job on
#BSUB -G FIXME # groupname for billing
#BSUB -cwd FIXME  # working directory
#BSUB -o logs/estimate_pi.out  # standard output file
#BSUB -e logs/estimate_pi.err  # standard error file
#BSUB -n 1        # number of CPUs. Default: 1
#BJOBS -R "select[mem>1000] rusage[mem=1000]" # RAM memory part 1. Default: 100MB
#BJOBS -M1000  # RAM memory part 2. Default: 100MB

/software/R-4.1.3/bin/Rscript FIXME
