#!/bin/bash
#BSUB -q normal  # name of the partition to run job on
#BSUB -G FIXME # groupname for billing
#BSUB -J FIXME[2-FIXME]   # we start at 2 because of the header
#BSUB -cwd /FIXME/FIXME/hpc_workshop
#BSUB -o logs/drosophila_mapping_%I.out
#BSUB -e logs/drosophila_mapping_%I.err
#BSUB -n 2         # number of CPUs. Default: 1
#BSUB -R "select[mem>1000] rusage[mem=1000]" # RAM memory part 1. Default: 100MB
#BSUB -M1000  # RAM memory part 2. Default: 100MB
#BSUB -W30  # time for the job


# load bowtie2
module load bowtie2

# get the relevant line of the CSV sample information file
# see http://bigdatums.net/2016/02/22/3-ways-to-get-the-nth-line-of-a-file-in-linux/
SAMPLE_INFO=$(cat data/drosophila_sample_info.csv | head -n FIXME | tail -n 1)

# get the sample name and paths to read1 and read2
SAMPLE=$(echo $SAMPLE_INFO | cut -d "," -f 1)
READ1=$(echo $SAMPLE_INFO | cut -d "," -f 2)
READ2=$(echo $SAMPLE_INFO | cut -d "," -f 3)

# create output directory
mkdir -p "results/drosophila/mapping"

# output some informative messages
echo "The input read files are: $READ1 and $READ2"
echo "Number of CPUs used: $LSB_MAX_NUM_PROCESSORS"

# Align the reads to the genome
bowtie2 --very-fast -p "$LSB_MAX_NUM_PROCESSORS" \
  -x "results/drosophila/genome/index" \
  -1 "$READ1" \
  -2 "$READ2" > "results/drosophila/mapping/$SAMPLE.sam"
