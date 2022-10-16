#!/bin/bash
#BSUB -q normal  # name of the partition to run job on
#BSUB -G FIXME # groupname for billing
#BSUB -cwd /nfs/users/nfs_FIXME/FIXME/hpc_workshop
#BSUB -o logs/drosophila_genome_indexing.out
#BSUB -e logs/drosophila_genome_indexing.err
#BSUB -n 1        # number of CPUs. Default: 1
#BSUB -R "select[mem>1000] rusage[mem=1000]" # RAM memory part 1. Default: 100MB
#BSUB -M1000  # RAM memory part 2. Default: 100MB
#BSUB -W10 # time for the job HH:MM:SS. Default: 1 min

# activate bowtie2 module
FIXME

# make an output directory for the index
mkdir -p results/drosophila/genome

# index the reference genome with bowtie2; the syntax is:
# bowtie2-build input.fa output_prefix
bowtie2-build data/genome/drosophila_genome.fa results/drosophila/genome/index
