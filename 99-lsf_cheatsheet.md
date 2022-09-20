---
pagetitle: "HPC Course"
---

# LSF Quick Reference Guide

This page summarises the most relevant information to work with the HPC, to be used as a quick-reference guide.

This is used in the examples that follow:

- username `xyz123`
- submitting the script `simulation.sh`
- project's directory is `/home/xyz123/scratch/simulations/`
- billing account is `TRAINING-SL3-CPU`
- partition name is `skylake`


## SLURM Commands

| Command | Description |
| -: | :- |
| `bsub simulation.sh` | submit script to scheduler |
| `bjobs` | jobs currently in the queue |
| `bcancel JOBID` | cancel the job with the specified ID (get the ID from the command above) |
| `bcancel -u xyz123` | cancel all your jobs at once |
| `bhist JOBID` | basic information about the job |
| `bacct JOBID` | custom information about your job |


## Submission Script Template

At the top of the submission shell script, you should have your `#BSUB` options.
Use this as a general template for your scripts:

```bash
#!/bin/bash
#BSUB -J my_simulation[1-4]           # a job name for convenience, or array setup
#BSUB -cwd /home/xyz123/scratch/simulations  # your working directory
#BSUB -o logs/simulation.out     # standard output (and standard error if omitting -e) will be saved in this file
#BSUB -q skylake                 # partition
#BSUB -n2                       # number of CPUs
#BSUB -R"select[mem>1000] rusage[mem=1000]"   # RAM memory part 1.
#BSUB -M1000                    # RAM memory part 2. 
#BSUB -W15                # Time for the job in (hh:)mm
```
