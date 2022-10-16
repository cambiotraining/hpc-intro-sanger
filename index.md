---
pagetitle: "Sanger HPC"
output:
  html_document:
    toc: false
---

# Introduction to High-Performance Computing (Sanger)

**Authors:** Hugo Tavares, Chloe Pacyna, Lajos Kalmar

# {.unlisted .unnumbered .tabset}

## Overview

:::highlight

Knowing how to work on a High Performance Computing (HPC) system is an essential skill for applications such as bioinformatics, big-data analysis, image processing, machine learning, parallelising tasks, and other high-throughput applications. In this module we will cover the basics of High Performance Computing, what it is and how you can use it in practice. This is a hands-on workshop, which should be accessible to researchers from a range of backgrounds and offering several opportunities to practice the skills we learn along the way.  
The content is specifically tailored for the Sanger HPC server (aka the "FARM"), and by the end of the course you should be well equipped to start running your analysis on your local computing infrastructure.

:::


### Target Audience

This course is aimed at students and researchers of any background. We assume no prior knowledge of what a HPC is or how to use it.

It may be particularly useful for those who have attended other of our [Bioinformatics Training Courses](https://www.training.cam.ac.uk/bioinformatics/search) and now need to process their data on a Linux server. 
It will also benefit those who find themselves using their personal computers to run computationally demanding analysis/simulations and would like to learn how to adapt these to run on a HPC.


### Prerequisites

We assume a basic knowledge of the Unix command line. 
If you don't feel comfortable with the command line, please attend our accompanying [Introduction to the Unix Command Line](https://training.csx.cam.ac.uk/bioinformatics/course/bioinfo-unix2) course, which is scheduled to run just before this one.
Alternatively, if all you need is a refresher, please consult our [Command Line Cheatsheet](99-unix_cheatsheet.html). 

Namely, we expect you to be familiar with the following:

- Navigate the filesystem, for example: `pwd` (where am I?), `ls` (what's in here?), `cd` (how do I get there?)
- Investigate file content using utilities such as: `head`/`tail`, `less`, `cat`/`zcat`, `grep`
- Using "flags" to modify a program's behaviour, for example: `ls -l`
- Redirect output with `>`, for example: `echo "Hello world" > some_file.txt`
- Use the pipe `|` to chain several commands together, for example `ls | wc -l`
- Execute shell scripts with `bash some_script.sh`


### Setup & Data

Before attending the workshop, please install the necessary software following our **[setup instructions](99-setup.html)**.
If you have any issues installing the software, please [get in touch](mailto:bioinfo@hermes.cam.ac.uk) with us beforehand.

Please also **[download the workshop data](https://www.dropbox.com/sh/8ftw8biizk8sio1/AAB393Amhgn4-Kt2b8R1OszRa?dl=1)** (zip file) and save it to your desktop (do not unzip the file). 


## Authors

About the authors: 

- **Chloe Pacyna** 
  <a href="https://twitter.com/ChloePacyna" target="_blank"><i class="fa-brands fa-twitter" style="color:#4078c0"></i></a> 
  <a href="https://orcid.org/0000-0002-4404-8183" target="_blank"><i class="fa-brands fa-orcid" style="color:#a6ce39"></i></a> 
  <a href="https://github.com/cpacyna" target="_blank"><i class="fa-brands fa-github" style="color:#4078c0"></i></a>  
  _Affiliation_: Wellcome Sanger Institute  
  _Roles_: writing - review & editing; writing - original content; coding
- **Hugo Tavares** 
  <a href="https://orcid.org/0000-0001-9373-2726" target="_blank"><i class="fa-brands fa-orcid" style="color:#a6ce39"></i></a> 
  <a href="https://github.com/tavareshugo" target="_blank"><i class="fa-brands fa-github" style="color:#4078c0"></i></a>  
  _Affiliation_: Bioinformatics Training Facility, University of Cambridge  
  _Roles_: writing - review & editing; writing - original content; conceptualisation; coding
- **Lajos Kalmar**  
  _Affiliation_: MRC Toxicology, University of Cambridge  
  _Roles_: writing - original content; conceptualisation; coding


## Acknowledgements 

We thank Qi Wang (Department of Plant Sciences, University of Cambridge) for constructive feedback and ideas in the early iterations of this course. 
