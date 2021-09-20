#!/bin/bash
#SBATCH -p training  # name of the partition to run job on
#SBATCH -D /home/participant58/dep_test
#SBATCH -o dep2.log
#SBATCH -c 1        # number of CPUs. Default: 1
#SBATCH --mem=1G    # RAM memory. Default: 1G
#SBATCH -t 00:00:20 # time for the job HH:MM:SS. Default: 1 min

touch long_test.txt
sleep 80
mv long_test.txt long_final.txt
#exit 0