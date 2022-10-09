#!/bin/bash
#BSUB -q normal  # name of the partition to run job on
#BSUB -G FIXME # groupname for billing
#BSUB -J FIXME
#BSUB -cwd /FIXME/FIXME/hpc_workshop
#BSUB -o logs/parallel_estimate_pi_%I.out
#BSUB -e logs/parallel_estimate_pi_%I.err
#BSUB -n1        # number of CPUs. Default: 1
#BSUB -W10 # time for the job.


echo "Starting array: $LSB_JOBINDEX"

# make output directory, in case it doesn't exist
mkdir -p results/pi

# run pi_estimator script
/software/R-4.1.3/bin/Rscript scripts/pi_estimator.R > results/pi/replicate_${LSB_JOBINDEX}.txt

echo "Finished array: $LSB_JOBINDEX"
