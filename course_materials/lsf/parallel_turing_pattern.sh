#!/bin/bash
#BSUB -q normal  # name of the partition to run job on
#BSUB -cwd /scratch/FIXME/hpc_workshop
#BSUB -o logs/turing_pattern_%I.out
#BSUB -e logs/turing_pattern_%I.err
#BSUBv -n1         # number of CPUs. Default: 1
#BSUB -R"select[mem>1000] rusage[mem=1000]" # RAM memory part 1. Default: 100MB
#BSUB -M1000  # RAM memory part 2. Default: 100MB
#BSUB -W30  # time for the job 
#BSUB -J FIXME[2-FIXME]   # we start at 2 because of the header

echo "Starting array: $LSB_JOBINDEX"

# activate software environment
source activate scipy

# make output directory
mkdir -p results/turing

# get the relevant line of the CSV parameter file
# see http://bigdatums.net/2016/02/22/3-ways-to-get-the-nth-line-of-a-file-in-linux/
PARAMS=$(cat data/turing_model_parameters.csv | head -n FIXME | tail -n 1)

# separate the values based on comma "," as delimiter
FEED=$(echo ${PARAMS} | cut -d "," -f 1)
KILL=$(echo ${PARAMS} | cut -d "," -f 2)

# Launch script using our defined variables
python scripts/turing_pattern.py --feed ${FEED} --kill ${KILL} --outdir results/turing

echo "Finished array: $LSB_JOBINDEX"
