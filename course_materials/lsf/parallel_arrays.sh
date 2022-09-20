#!/bin/bash
#BSUB -q normal  # name of the partition to run job on
#BSUB -cwd /FIXME/FIXME/hpc_workshop
#BSUB -o logs/parallel_arrays_%I.out
#BSUB -e logs/parallel_arrays_%I.err
#BSUB -n2        # numeber of CPUs. Default: 1
#BSUB -R"select[mem>1000] rusage[mem=1000]" # RAM memory part 1.
#BSUB -M1000  # RAM memory part 2.
#BSUB -W30 # time for the job HH:MM:SS.
#BSUB -J parallel[1-3]

echo "This is task number $LSB_JOBINDEX"
echo "Using $LSB_MAX_NUM_PROCESSORS CPUs"
echo "Running on:"
hostname
