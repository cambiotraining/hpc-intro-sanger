---
title: "Working on the Sanger HPC cluster using LSF"
pagetitle: "Sanger HPC"
date: today
number-sections: false
---

## Overview 

Knowing how to work on a High Performance Computing (HPC) system is an essential skill for applications such as bioinformatics, big-data analysis, image processing, machine learning, parallelising tasks, and other high-throughput applications. In this module we will cover the basics of High Performance Computing, what it is and how you can use it in practice. This is a hands-on workshop, which should be accessible to researchers from a range of backgrounds and offering several opportunities to practice the skills we learn along the way.  
The content is specifically tailored for the Sanger HPC server (aka the "FARM"), and by the end of the course you should be well equipped to start running your analysis on your local computing infrastructure.


::: {.callout-tip}
### Learning Objectives

- Describe how a HPC cluster is typically organised and how it differs from a regular computer.
- Recognise the tasks that a HPC cluster is suitable for. 
- Access and work on a HPC server.
- Submit and manage jobs running on a HPC.
- Paralelise similar tasks at scale.
- Access, install and manage software on a HPC.
:::


### Target Audience

This course is aimed at students and researchers of any background. 
We assume no prior knowledge of what a HPC is or how to use it.

Much of the content is specific for the servers at the Wellcome Sanger Institute, although the concepts covered would apply to other clusters using the same job scheduler (LSF). 


### Prerequisites

We assume a solid knowledge of the Unix command line. 
If you don't feel comfortable with the command line, please attend our accompanying [Introduction to the Unix Command Line](https://training.csx.cam.ac.uk/bioinformatics/course/bioinfo-unix2) course.

Namely, we expect you to be familiar with the following:

- Navigate the filesystem: `pwd` (where am I?), `ls` (what's in here?), `cd` (how do I get there?)
- Investigate file content using utilities such as: `head`/`tail`, `less`, `cat`/`zcat`, `grep`
- Using "flags" to modify a program's behaviour, for example: `ls -l`
- Redirect output with `>`, for example: `echo "Hello world" > some_file.txt`
- Use the pipe `|` to chain several commands together, for example `ls | wc -l`
- Execute shell scripts with `bash some_script.sh`


## Citation & Authors

Please cite these materials if:

- You adapted or used any of them in your own teaching.
- These materials were useful for your research work. For example, you can cite us in the methods section of your paper: "We carried our analyses based on the recommendations in _YourReferenceHere_".

<!-- 
This is generated automatically from the CITATION.cff file. 
If you think you should be added as an author, please get in touch with us.
-->

{{< citation CITATION.cff >}}


## Acknowledgements

- Thanks to the [Informatics Support Group (High Performance Computing)](https://www.sanger.ac.uk/group/informatics-support-group/) at the Sanger, for providing guest accounts to our trainers, providing technical support during the workshops and for valuable feedback on the course content. 
- Thanks to Qi Wang (Department of Plant Sciences, University of Cambridge) for constructive feedback and ideas in the early iterations of this course.
- Thanks to [@Alylaxy](https://github.com/Alylaxy) for his pull requests to the repo ([#34](https://github.com/cambiotraining/hpc-intro/pull/34)).
- Thanks to the [HPC Carpentry](https://www.hpc-carpentry.org/index.html) community for developing similar content.