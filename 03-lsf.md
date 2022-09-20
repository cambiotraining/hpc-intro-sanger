---
pagetitle: "HPC Course: LSF"
---

# Using the LSF Job Scheduler

:::highlight
#### Questions

- How do I submit jobs to the HPC?
- How can I customise my jobs?
- How can I estimate how many resources I need for a job?

#### Lesson Objectives

- Submit a simple job using LSF and analyse its output.
- Edit a job submission script to request non-default resources.
- Use LSF environment variables to customise scripts.
- Use the commands `bjobs` and `bacct` to obtain information about the jobs.
- Troubleshoot errors occurring during job execution.
:::

## Job Scheduler Overview

As we briefly discussed in "[Introduction to HPC](01-intro.html)", HPC servers usually have a _job scheduling_ software that manages all the jobs that the users submit to be run on the _compute nodes_.
This allows efficient usage of the compute resources (CPUs and RAM), and the user does not have to worry about affecting other people's jobs.

The job scheduler uses an algorithm to prioritise the jobs, weighing aspects such as:

- how much time did you request to run your job?
- how many resources (CPUs and RAM) do you need?
- how many other jobs have you got running at the moment?

Based on these, the algorithm will rank each of the jobs in the queue to decide on a "fair" way to prioritise them.
Note that this priority dynamically changes all the time, as jobs are submitted or cancelled by the users, and depending on how long they have been in the queue.
For example, a job requesting many resources may start with a low priority, but the longer it waits in the queue, the more its priority increases.


## Submitting a Job with LSF

To submit a job to LSF, you need to include your code in a _shell script_.
Let's start with a minimal example, found in our workshop data folder "lsf".

Our script is called `simple_job.sh` and contains the following code:

```bash
#!/bin/bash

sleep 60 # hold for 60 seconds
echo "This job is running on:"
hostname
```
######## edit path
We can run this script from the login node using the `bash` interpreter (make sure you are in the correct directory first: `cd ~/scratch/hpc_workshop/`):

```console
bash lsf/simple_job.sh
```

Which prints the output:

```
This job is running on:
login-node
```

To submit the job to the scheduler we instead use the `bsub` command in a very similar way:

```console
bsub lsf/simple_job.sh
```

However, this throws back an error:
```console
Returning output by mail is not supported on this cluster.
Please use the -o option to write output to disk.
Request aborted by esub. Job not submitted.
```

Do you have any ideas of what this error could be?

Our job, like all LSF jobs, has an output (echo printout and the hostname) and job statistics about what was done on the HPC.  Because the Sanger LSF is set up to disallow outputs to be sent to your email by default for security reasons, it is impossible for the job to run without specifying a "standard output" file.  We can fix this error using the `-o` argument:

```console
bsub -o simple_job.out lsf/simple_job.sh
```

Instead the output is sent to a file, which we called `simple_job.out`.
This file will be located in the same directory where you launched the job from.

We can investigate the output by looking inside the file, for example `cat simple_job.out`.

:::note
The first line of the shell scripts `#!/bin/bash` is called a [_shebang_](https://en.wikipedia.org/wiki/Shebang_(Unix)) and indicates which program should interpret this script. In this case, _bash_ is the interpreter of _shell_ scripts (there's other shell interpreters, but that's beyond what we need to worry about here).

Remember to **always have this as the first line of your script**.
If you don't, `bsub` will throw an error.
:::


## Configuring Job Options

The -o argument is just one of over 70 different options for submitting a job with `bsub`.  You can imagine the bsub command would get rather long and difficult to keep track of!  To make submitting a job simpler and more reproducible, you can include each of your bsub arguments as a line starting with `#BSUB` at the beginning of your script within the script, after the shebang.

Here is how we could modify our script:

```bash
#!/bin/bash
#BSUB -o logs/simple_job.out

sleep 8 # hold for 8 seconds
echo "This job is running on:"
hostname
```

If we now re-run the script using `bsub test_job.sh`, the output goes to a file within the log folder named `simple_job.out`.

There are many other options we can specify when using LSF, and we will encounter several more of them as we progress through the materials.
Here are some of the most common ones (anything in `<>` is user input):

| Command | Description |
| -: | :---------- |
| `-cwd <path>` | *working directory* used for the job. This is the directory that LSF will use as a reference when running the job. |
| `-o <path/filename>` | file where the output that would normally be printed on the console is saved in. This is defined _relative_ to the working directory set above. |
| `-e <path/filename>` | file where the error log is saved in. This is defined _relative_ to the working directory set above. |
| `-G <name>` | group name. This is required on the farm as it logs compute resources used for billing to your group.  Ask your labmates for the name. |
| `-q <name>` | *partition* name. See details in the following section. |
| `- n<ncores>` | number of CPUs to be requested. |
| `-R"select[mem><megabytes_required>] rusage[mem=<megabytes_required>]"` | First part of two options to request custom RAM memory for the job. |
| `-M<megabytes_required>` | Second part of two options to request custom RAM memory for the job. |
| `-W<time in the form of [hour:]minute>` | the time you need for your job to run. This is not always easy to estimate in advance, so if you're unsure you may want to request a good chunk of time. However, the more time you request for your job, the lower its priority in the queue. |
| `-J <name>` | a name for the job. |


:::note
**Default Resources**

If you don't specify any options when submitting your jobs, you will get the default configured by the HPC admins.
For example, on farm5, the defaults you will get are:

- 10 minutes of running time (equivalent to `-W 00:10:00`)
- _normal_ partition (equivalent to `-q normal`)
- 1 CPU (equivalent to `-c 1`)
- 100MB RAM (equivalent to `-M 100 -R"select[mem>100] rusage [mem=100] span [hosts=1]"`)
:::


### Partitions

Often, HPC servers have different types of compute node setups (e.g. partitions for fast jobs, or long jobs, or high-memory jobs, etc.).
LSF calls these "queues" and you can use the `-q` option to choose which queue your job runs on.
Usually, which queues are available on your HPC should be provided by the admins.

It's worth keeping in mind that these partitions have separate queues, so you should always try to choose the partition that is most suited to your job.

You can check the queues available using the command `bqueues -l`.

#### For example, on farm5 we have to partitions with the following characteristics:

General use partitions:
- `normal` partition (default)
  - Maximum 12 hours
- `long` partition
  - Maximum 48 hours
- `basement` partition
  - Maximum 30 days
  - Default maximum 300 basement jobs per user

A selection of special case partitions:
- `hugemem`/`hugemem-restricted`/`teramem` partitions
  - For  large memory machines. (512GB/1TB).
- `yesterday` partition
  - For very urgent jobs that need to be done "yesterday"
  - Default maximum 7 yesterday partition jobs
- `small` partition
  - For many, very small jobs (batches 10 jobs together to prevent scheduler overload)



## Getting Job Information

After submitting a job, we may want to know:

- What is going on with my job? Is it running, has it finished?
- If it finished, did it finish successfully, or did it fail?
- How many resources (e.g. RAM) did it use?
- What if I want to cancel a job because I realised there was a mistake in my script?

You can check the status of all your jobs in the queue by using:

```console
bjobs -w
```

Or get detailed information on one job in particular with:

```console
bjobs -l <JOBID>
```

This gives you information about the job's status: `PEND` means it's *pending* (waiting in the queue) and `RUN` means it's *running*.

To check several statistics about a job (and whether it completed or failed), you can use:

```console
bhist -l JOBID
```

This shows you the status of the job, whether it completed or not, how long it took to run, and how much memory it used.
Therefore, this command is very useful to determine suitable resources (e.g. RAM, time) next time you run a similar job.

Alternatively, you can use the `bacct` command once a job has completed, which allows displaying this and other information in a more condensed way (and for multiple jobs if you want to).

For example:

```console
bacct -l JOBID
```

- `jobname` is the job's name
- `account` is the account used for the job
- `state` gives you the state of the job
- `AllocCPUs` is the number of CPUs you requested for the job
- `reqmem` is the memory that you asked for (Mc or Gc indicates MB or GB per core; Mn or Gn indicates MB or GB per node)
- `maxrss` is the maximum memory used during the job *per core*
- `averss` is the average memory used *per core*
- `elapsed` how much time it took to run your job

All the options available with `bacct` can be listed using `bacct -e`.
If you forgot what the job id is, check the stdout file (created with the -o argument of bsub).

On our farm, `bacct` is reading information from `/usr/local/lsf/work/<cluster_name>/logdir/lsb.acct.*`.

:::note
The `bacct` command may not be available on every HPC, as it depends on how it was configured by the admins.
:::


Finally, if you want to suspend a job, you can use:
```console
bstop <JOBID>
```

Suspended jobs can be restarted using:
```console
bresume <JOBID>
```

To irreversibly end a job, use:
```console
bkill <JOBID>
```

All three commands `bstop`, `bresume`, and `bkill` can be applied to all of your own jobs by replacing the job ID with `0`.

It's impossible to edit other users' jobs, so don't worry about accidentally deleting everyone's Farm jobs!

:::warning
**WATCH OUT**

When specifying the `-o` option including a directory name, if the output directory does not exist, `bjobs` will fail and throw the same 'mail' command as we saw earlier.

For example, let's say that we would like to keep our job output files in a folder called "logs".
For the example above, we might set these #BJOBS options:

```bash
#BJOBS -D /home/username/scratch/hpc_workshop/
#BJOBS -o logs/simple_job.log
```

But, unless we create the `logs/` directory _before running the job_, `bjobs` will fail.

Another thing to note is that you should not use the `~` home directory shortcut with the `-D` option. For example:

```bash
#BJOBS -D ~/scratch/hpc_workshop/
```

Will not reliably work, instead you should use the full path, for example:

```bash
#BJOBS -D /home/username/scratch/hpc_workshop/
```

:::


:::exercise

In the "scripts" directory, you will find an R script called `pi_estimator.R`.
This script tries to get an approximate estimate for the number Pi using a stochastic algorithm.

<details><summary>How does the algorithm work?</summary>

If you are interested in the details, here is a short description of what the script does:

> The program generates a large number of random points on a 1×1 square centered on (½,½), and checks how many of these points fall inside the unit circle. On average, π/4 of the randomly-selected points should fall in the circle, so π can be estimated from 4f, where f is the observed fraction of points that fall in the circle. Because each sample is independent, this algorithm is easily implemented in parallel.

![Estimating Pi by randomly placing points on a quarter circle. (Source: [HPC Carpentry](https://carpentries-incubator.github.io/hpc-intro/16-parallel/index.html))](https://carpentries-incubator.github.io/hpc-intro/fig/pi.png){ width=50% }

</details>

If you were running this script interactively (i.e. directly from the console), you would use the R script interpreter: `Rscript scripts/pi_estimator.R`.
Instead, we use a shell script to submit this to the job scheduler.

1. Edit the shell script in `lsf/estimate_pi.sh` by correcting the code where the word "FIXME" appears. Submit the job to SLURM and check its status in the queue.
2. How long did the job take to run? <details><summary>Hint</summary>Use `bjobs -l JOBID` or `bacct JOBID`.</details>
3. The number of samples used to estimate Pi can be modified using the `--nsamples` option of our script, defined in millions. The more samples we use, the more precise our estimate should be.
    - Adjust your SLURM submission script to use 200 million samples (`Rscript scripts/pi_estimator.R --nsamples 200`), and save the job output in `logs/estimate_pi_200M.log`.
    - Monitor the job status with `bjobs` and `bhist -l JOBID`. Do you find any issues?

<details><summary>Answer</summary>

**A1.**

In the shell script we needed to correct the user-specific details in the `#BJOBS` options.
Also, we needed to specify the path to the script we wanted to run.
This can be defined relative to the working directory that we've set with `-D`.
For example:

```bash
#!/bin/bash
#BJOBS -q normal  # name of the queue to run job on
#BJOBS -cwd /nfs/users/nfs_USERINITIAL/USERID/hpc_workshop/course_materials  # working directory
#BJOBS -o logs/estimate_pi.out  # standard output file
#BJOBS -e logs/estimate_pi.err  # standard error file
#BJOBS -n1        # number of CPUs. Default: 1
#BJOBS -R"select[mem>1000] rusage[mem=1000]" # RAM memory part 1. Default: 100MB
#BJOBS -M1000  # RAM memory part 2. Default: 100MB

# run the script
Rscript scripts/pi_estimator.R
```

**A2.**

As suggested in the hint, we can use the `bhist` or `bacct` commands for this:

```console
bjobs -l JOBID
bacct JOBID
```

Replacing JOBID with the ID of the job we just ran.

If you cannot remember what the job id was, you can check all your jobs using `bjobs` or view the outfile generated at the beginning of the run.

Sometimes it may happen that the "Memory Utilized" is reported as 0.00MB or a lower value than you would expect.
That's very odd, since for sure our script must have used _some_ memory to do the computation.
The reason is that SLURM doesn't always have time to pick memory usage spikes, and so it reports a zero.
This is usually not an issue with longer-running jobs.

**A3.**

The modified script should look similar to this:

```bash
#!/bin/bash
#BSUB -q normal  # name of the queue to run job on
#BSUB -D /scratch/USERNAME/hpc_workshop/  # working directory
#BSUB -o logs/estimate_pi_200M.log  # standard output file
#BSUB -e logs/estimate_pi_200M.err  # standard error file
#BSUB -n1        # number of CPUs. Default: 1
#BSUB -R"select[mem>1000] rusage[mem=1000] span[hosts=1]" # RAM memory part 1. Default: 100MB
#BSUB -M1000  # RAM memory part 2. Default: 100MB

# run the script
Rscript scripts/pi_estimator.R --nsamples 200
```

However, when we run this job, examining the output file (`cat logs/estimate_pi_200M.log`) will reveal and error indicating that our job was killed.

Furthermore, if we use `bacct` to get information about the job, it will show `State: OUT_OF_MEMORY (exit code 0)`. (**Note:** on our training machines it may show `State: FAILED (exit code 137)`, which is the exit code for an out-of-memory error in our cloud setup)

This suggests that the job required more memory than we requested.
We can also check this by seeing what `bacct` reports as "Memory Utilized" and see that it exceeded the default 1GB (although sometimes it shows 0.0GB if it ran too fast and SLURM didn't register the memory usage peak).

To correct this problem, we would need to increase the memory requested to SLURM, adding to our script, for example, `#BJOBS -R "select[mem>30000] rusage [mem=30000] span[hosts=1]"` and `#BJOBS -M 30000` to request 30Gb of RAM memory for the job.
In this case, you would also have to use a different partition that gives you access to high memory notes (`#BJOBS -q basement`).

</details>

:::


## LSF Environment Variables

One useful feature of LSF jobs is the automatic creation of environment variables.
Generally speaking, variables are a character that store a value within them, and can either be created by us, or sometimes they are automatically created by programs or available by default in our shell.


:::note

<details><summary>More about shell variables</summary>

An example of a common shell environment variable is `$HOME`, which stores the path to the user's `/home` directory.
We can print the value of a variable with `echo $HOME`.

The syntax to create a variable ourselves is:

```shell
VARIABLE="value"
```

Notice that there should be **no space between the variable name and its value**.

If you want to create a variable with the result of evaluating a command, then the syntax is:

```shell
VARIABLE=$(command)
```

Try these examples:

```shell
# Make a variable with a path starting from the user's /home
DATADIR="$HOME/scratch/data/"

# list files in that directory
ls $DATADIR

# create a variable with the output of that command
DATAFILES=$(ls $DATADIR)
```

</details>
:::

When you submit a job with LSF, it creates several variables, all starting with the prefix `$LSB_`.
One useful variable is `$LSB_MAX_NUM_PROCESSORS`, which stores how many CPUs we requested for our job.
This means that we can use the variable to automatically set the number of CPUs for software that support multi-processing.
We will see an example in the following exercise.

:::exercise

The R script used in the previous exercise supports parallelisation of some of its internal computations.
The number of CPUs used by the script can be modified using the `--ncpus` option.
For example `pi_estimator.R --nsamples 200 --ncpus 2` would use two CPUs.

1. Modify your submission script (`slurm/estimate_pi.sh`) to:
    1. Should you still use the `normal` partition?
    1. Use the `$LSB_MAX_NUM_PROCESSORS` variable to set the number of CPUs used by `pi_estimator.R` (and ensure you have set `--nsamples 200` as well).
    1. Request 10G of RAM memory for the job.
    1. Bonus (optional): use `echo` within the script to print a message indicating the job number (SLURM's job ID is stored in the variable `$LSB_JOBID`).
2. Submit the job a few times, each one using 1, 2 and then 8 CPUs. Make a note of each job's ID.
3. Check how much time each job took to run (using `bacct JOBID`). Did increasing the number of CPUs shorten the time it took to run?

<details><summary>Answer</summary>

**A1.**

We can modify our submission script in the following manner, for example for using 2 CPUs:

```bash
#!/bin/bash
#BSUB -q normal     # partiton name
#BSUB -D /FIXME/FIXME/hpc_workshop/  # working directory
#BSUB -o logs/estimate_pi_200M.out      # output file
#BSUB -e logs/estimate_pi_200M.err      # error file
#BSUB -R"select[mem>1000] rusage[mem=1000]" # RAM memory part 1. Default: 100MB
#BSUB -M1000  # RAM memory part 2. Default: 100MB
#BSUB -n2                          # number of CPUs

# launch the Pi estimator script using the number of CPUs that we are requesting from SLURM
Rscript exercises/pi_estimator.R --nsamples 200 --ncpus $LSB_MAX_NUM_PROCESSORS
```

We can run the job multiple times while modifying the `#BJOBS -n` option, saving the file and re-running `bjobs slurm/estimate_pi.sh`.

After running each job we can use `bjobs -l JOBID` (or `bacct JOBID`) command to obtain information about how long it took to run.

Alternatively, since we want to compare several jobs, we could also have used `bacct` like so:

`bacct -o JobID,elapsed -j JOBID1,JOBID2,JOBID3`

In this case, it does seem that increasing the number of CPUs shortens the time the job takes to run. However, the increase is not linear at all.
For example going from 1 to 2 CPUs seems to make the job run faster, however increasing to 8 CPUs makes little difference compared to 2 CPUs (this may depend on how many `--nsamples` you used).
This is possibly because there are other computational costs to do with this kind of parallelisation (e.g. keeping track of what each parallel thread is doing).

</details>

:::

Here is a table summarising some of the most useful environment variables that SLURM creates:

| Variable | Description |
| -: | :- |
| `$LSB_MAX_NUM_PROCESSORS` | Number of CPUs requested with `-n` |
| `$LSB_JOBID` | The job ID |
| `$LSB_JOBNAME` | The name of the job defined with `-J` |
| `$LSB_EXECCWD` | The working directory defied with `-cwd` |
| `$LSB_JOBINDEX` | The number of the sub-job when running parallel arrays (covered in the [Job Arrays](05-job_arrays.html) section) |


## Interactive Login

Sometimes it may be useful to directly get a terminal on one of the compute nodes.
This may be useful, for example, if you want to test some scripts or run some code that you think might be too demanding for the login node (e.g. to compress some files).

It is possible to get interactive access to a terminal on one of the compute nodes using the `-Is` argument in `bsub`.
This command takes options similar to the normal `bsub` program, so you can request resources in the same way you would when submitting scripts.

For example, to access to 8 CPUs and 10GB of RAM for 10 minutes on one of the compute nodes we would do:

```console
bsub -Is -n8 -R"select[mem>1000] rusage[mem=1000]" -M1000 -q normal -W10 bash
```

You may get a message saying that LSF is waiting to allocate your request (you go in the queue, just like any other job!).
Eventually, when you get in, you will notice that your terminal will indicate you are on a different node (different from the login node).
You can check by running `hostname`.

After you're in, you can run any commands you wish, without worrying about affecting other users' work.
Once you are finished, you can use the command `exit` to terminate the session, and you will go back to the login node.

Note that, if the time you requested (with the `-W` option) runs out, your session will be immediately killed.


## Summary

:::highlight
#### Key Points

- Include the commands you want to run on the HPC in a shell script.
  - Always remember to include `#!/bin/bash` as the first line of your script.
- Submit jobs to the scheduler using `bsub submission_script.sh`.
- Customise the jobs by including `#BSUB` options at the top of your script (see table in the materials above for a summary of options).
  - As a good practice, always define an output file with `#BSUB -o`. All the information about the job will be saved in that file, including any errors.
- Check the status of a submitted job by using `bjobs -u USERNAME` and `bacct -j JOBID`.
- To cancel a running job use `bkill JOBID`.

#### Further resources

- [IBM Spectrum LSF Reference Site](https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=reference)
- [bsub Reference Page](https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=reference-bsub)
- [LSF to PBS/SLURM/SGE/etc. Reference](https://slurm.schedmd.com/rosetta.gif)
:::
