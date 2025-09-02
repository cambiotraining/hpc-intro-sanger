---
pagetitle: "Sanger HPC"
---

# Software Management

::: {.callout-tip}
#### Lesson Objectives

- Use the `module` tool to search for and load pre-installed software.
- Understand what a package manager is, and how it can be used to manage software instalation on a HPC environment.
- Install the _Conda_ package manager. (optional)
- Create a software environment and install software using _Conda_. (optional)
:::


## Using Pre-installed Software

It is very often the case that HPC admins have pre-installed several software packages that are regularly used by their users.
Because there can be a large number of packages (and often different versions of the same program), you need to load the programs you want to use in your script using the `module` tool.

The following table summarises the most common commands for this tool:

| Command | Description |
| -: | :- |
| `module avail ` | List all available packages. |
| `module avail -i --contains "pattern"` <br> or <br> `module avail 2>&1 | grep -i "pattern"` | Search the available package list that matches "pattern" in a case-insensitive way. |
| `module load <program>` | Load the program and make it available for use. |
| `module unload <program>` | Unload the program (removes it from your PATH). |

If a package is not available through the `module` command, you can contact the HPC admin and ask them to install it for you.
Alternatively, you can use a package manager as we show in the next section.

The packages you have available will depend on the group you're in.  Your group affects your `$MODULEPATH` which in turn gives you access to various programme-specific packages.

<!-- 
For the rest of the course we'll be indexing and aligning a small drosophila genome, which requires some genomic tools.  The Cancer Ageing and Somatic Mutation programme (CASM) has the tool we need already loaded, so we need to temporarily add their module directory to our module paths.  To do so, simply run the following command from your `hpc_workshop` folder.  Note **this is just a temporary workaround**, once you are added to your programme's group, you'll automatically have access to relevant modules which you can check with `module avail`.

```bash
source configure_modules
```

You can check your module path by entering `echo $MODULEPATH` to see if the Cancer Genome Project directory has been added to your module path.  Or, you can run `module avail` to see which module groups you now have access to.

If you log off the farm during this course, you'll need to rerun this `export` one-liner again! 
-->


### Exercise

::: {.callout-exercise}
#### Software modules

Let's load the software package **bowtie2** so we can index and align a drosophila genome.

1. Check what modules are available on `gen22`. Can you find `bowtie` version 2.4.2?
2. Load the `bowtie2` version 2.4.2 using `module load`.
3. Run `bowtie2 --help` to make sure that the module has loaded properly.
4. Figure out where the bowtie2 software package is stored with the `which` command.


::: {.callout-answer}

**A1.**

Use `module avail` to list all software packages available on gen22.

**A2.**

We can first search to see which (if any) modules are available for this software: 

```bash
module avail -i --contains bowtie
```

We seem to have a few versions available:

```
bowtie-1.3.1
bowtie2-2.5.2/python-3.12.0
HGI/softpack/groups/team354/bowtie2/2.4.2
ISG/experimental/sp39/bowtie/2.5.2
```

As we are interested in version 2.4.2, we can load the module with:

```bash
module load HGI/softpack/groups/team354/bowtie2/2.4.2
```

**A3**

Running `bowtie2 --help` should print the help page from the software.
If this doesn't come up or if an error appears, you likely didn't manage to load the module properly.
This is a good sanity check when loading modules.

**A4**

Entering `which bowtie2` should show a path to `/software/hgi/softpack/installs/groups/team354//bowtie2/2.4.2-scripts/bowtie2`.

:::
:::


## Example: sequence read alignment

Once your sequencing data have been processed by SequenceSpace and/or your programme's IT team, you can then begin to analyze them in lustre. 
First, you need to transfer them from the "read-only" NFS or iRODS sections of the Farm to your lustre workspace.

We won't be doing this today (this is often a programme-specific process that requires unique permissions and some extra training), but it's important to keep this larger structure of data workflows in mind.
When discussing what you need to get started in your group, be sure to ask about how to get added to the group's permissions list and how they usually access sequencing data (iRODS, Canapps, NFS, etc.)

For our genome alignment @ex-alignment, we'll pretend that you have already staged the raw data files from long term storage (iRODS or NFS) into your lustre storage location in a folder called `data` within `hpc_workshop`.


### Exercise

::: {.callout-exercise #ex-alignment}
#### Using modules with LSF

In the `hpc_workshop/data` folder, you will find some files resulting from whole-genome sequencing individuals from the model organism _Drosophila melanogaster_ (fruit fly).
Our objective will be to align our sequences to the reference genome, using a software called _bowtie2_.

![](images/mapping.png){ width=50% }

But first, we need to prepare our genome for this alignment procedure (this is referred to as indexing the genome).
We have a file with the _Drosophila_ genome in `data/genome/drosophila_genome.fa`.

Open the script in `job_scripts/drosophila_genome_indexing.sh` and edit the `#BSUB` options with the word "FIXME". Submit the script to LSF using `bsub`, check it's progress, and whether it ran successfully. Troubleshoot any issues that may arise.

::: {.callout-answer}

We need to fix the script to specify the correct working directory with our username (only showing the relevant line of the script):

```bash
#BSUB -cwd /nfs/users/nfs_USERINITIAL/USERID/hpc_workshop/
```

We also need to make sure we load the module in the compute node, by adding the following line at the start of the script:

```bash
module load HGI/softpack/groups/team354/bowtie2/2.4.2
```

Remember that even though we may have loaded the environment on the login node, the scripts are run on a different machine (one of the compute nodes), so we need to remember to **always load modules or conda environments in our LSF submission scripts**.

We can then launch it with bsub:

```bash
bsub job_scripts/drosophila_genome_indexing.sh
```

We can check the job status by using `bjobs`.
And we can obtain more information by using `bacct JOBID` or `bhist JOBID`.

We should get several output files in the directory `results/drosophila/genome` with an extension ".bt2":

```bash
ls results/drosophila/genome
```

```
index.1.bt2
index.2.bt2
index.3.bt2
index.4.bt2
index.rev.1.bt2
index.rev.2.bt2
```

:::
:::


## Package managers

Often you may want to use software packages that are not be installed by default on the HPC.
There are several ways you could manage your own software installation, one of the most popular ones being the use of the package manager **Conda** or its newer implementation **Mamba**.

Covering Conda/Mamba is out of the scope of these materials, but check out our course [**Reproducible and scalable bioinformatics: managing software and pipelines**](https://training.cam.ac.uk/bioinformatics/course/bioinfo-Biopipelines) to learn more about this topic.

If you are familiar with Conda/Mamba, you may know that to activate a software environment you use the command `mamba activate`.
However, to load environments in a shell script that is being submitted to LSF you need to first source a configuration file from Conda/Mamba.
For example, let's say we had an environment called `datasci`; to activate it in our LSF script, we would need the following syntax:

```bash
# Always add these two commands to your scripts
eval "$(conda shell.bash hook)"
source $CONDA_PREFIX/etc/profile.d/mamba.sh

# then you can activate the environment
mamba activate datasci
```

This is because when we submit jobs to LSF the jobs will start in a non-interactive shell, and `mamba` doesn't get automatically set. 
Running the `source` command shown will ensure `mamba activate` becomes available. 

::: {.callout-note}
#### Mamba versus Module

Although _Mamba_ is a great tool to manage your own software installation, the disadvantage is that the software is not compiled specifically taking into account the hardware of the HPC. 
This is a slightly technical topic, but the main practical consequence is that software installed by HPC admins and made available through the `module` system may sometimes run faster than software installed via `conda`. 
This means you will use fewer resources and your jobs will complete faster.
:::


## Summary

::: {.callout-tip}
#### Key Points

- The `module` tool can be used to search for and load pre-installed software packages on a HPC. This tool may not always be available on your HPC.
  - `module avail` is used to list the available software.
  - `module load PACKAGE_NAME` is used to load the package. 
- To install your own software, you can use the _Conda_ package manager.
  - _Conda_ allows you to have separate "software environments", where multiple package versions can co-exist on your system.
- Use `conda env create <ENV>` to create a new software environment and `conda install -n <ENV> <PROGRAM>` to install a program on that environment. 
- Use `conda activate <ENV>` to "activate" the software environment and make all the programs installed there available. 
  - When submitting jobs to `bsub`, always remember to include `source $CONDA_PREFIX/etc/profile.d/conda.sh` at the start of the shell script, followed by the `conda activate` command. 
- Always remember to include either `module load` or `conda activate` in your submission script.
:::
