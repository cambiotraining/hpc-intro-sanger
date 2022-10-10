#!/bin/bash
#BSUB -q FIXME  # name of the partition to run job on
#BSUB -G FIXME # groupname for billing
#BSUB -cwd FIXME  # working directory
#BSUB -o logs/estimate_pi.out  # standard output file
#BSUB -e logs/estimate_pi.err  # standard error file
#BSUB -n 1        # number of CPUs. Default: 1


/software/R-4.1.3/bin/Rscript FIXME
