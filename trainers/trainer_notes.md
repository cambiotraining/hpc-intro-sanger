# Trainer notes

In general there are two main resources: 

- A [slide deck](https://docs.google.com/presentation/d/14B7jHJUJ010xqhMwyTL1eh_DT9ih7Nf2sKmdL0dLnOM/edit?usp=sharing), containing supporting slides for various sections of the course (detailed below).
- [Course materials page](https://cambiotraining.github.io/hpc-intro-sanger/), containing detailed explanations of the course content. These materials serve a few purposes:
  - For participants: it's a reference to use after the course (course notes).
  - For trainers: useful to prepare the delivery of materials, i.e. knowing what you should be demonstrating interactively during the course.
  - For exercises during the course - at the relevant point of the course you can point participants to section X for the exercise. 

Below, we give details to help you prepare each section of the materials.


## Introduction to HPC

This is a general introduction to HPC, followed by specifics about the FARM.

- Starts with a presentation which should last ~35 min ([slides](https://docs.google.com/presentation/d/1KmnSznETddQdRYa6UAXtT-eMOsW7tEwbsOh0fK62c84/edit?usp=sharing))
  - The slides have speaker notes, which contain some tips along the way. 
- Make sure participants can clarify questions about the HPC.
- Ideally the session should take no more than ~1h.
- The slides are equivalent to [chapter 3](https://cambiotraining.github.io/hpc-intro-sanger/materials/01-intro.html) of the materials. But these materials are only there as reference material for the participants, you don't need to use them during the course.
- We usually skip the exercise for this session to save time.


## Working on the FARM

This quite a short session where the main purpose is to have everyone SSH into the training HPC. 

- Slides 32 - 36; materials [chapter 4](https://cambiotraining.github.io/hpc-intro-sanger/materials/02-ssh.html)
- Exercise in slide 35
  - For Windows/MobaXterm users people sometimes get confused about pasting password on the terminal - this is highlighted in slide 20, make sure to highlight this. 
- Slide 36: mention the text editors and quickly demo Nano just to remind people how to use it (see speaker notes)


## Moving files

- Slides 37-52: these go through Filezilla, scp and rsync. Based on feedback from previous courses, there are now slides schematically illustrating how `rsync`/`scp` work, as the syntax can be confusing for those. 
  - **Time saver:** if running over time at this stage of the workshop, skip the `rsync` and `scp` slides and just use Filezilla (mention to participants there's extra material you are skipping, but they can look at after the course).
- After going through these slides, there's an exercise, which requires them to transfer the workshop data from their computers to the HPC.


## Job submission with LSF

This is the most critical part of the course where participants learn to use LSF in practice. 

- Slides 53-55: there are just 2 slides to quickly introduce LSF, then most of the session is interactive (see slide speaker notes)
- You should interactively open your terminal and demonstrate things as in [chapter 6](https://cambiotraining.github.io/hpc-intro-sanger/materials/04-lsf.html). 
- The demo is insterspersed with exercises - point people to the relevant section as you go through
- Slide 56: at the end of the demo and exercises go through this summary to wrap-up the session


## Managing software

This covers the topic of loading software using environment modules and mention Conda

- Slides 58-65: use these to introduce these topics; look at the speaker notes which give tips for when to switch back to interactive demo.
- Interactive demo and exercises in [chapter 6](https://cambiotraining.github.io/hpc-intro-sanger/materials/05-software.html)
- We don't go into details about `mamba` in this course. There's slides to illustrate how it works.
  - **Time saver:** skip the Mamba slides if running over time. 


## Parallelising jobs with arrays

- Slides 57-71: do these slides first, followed by the first exercise. Before the exercise you can do an interactive demo using the `parallel_arrays.sh` script provided. 
- Slides 72-76: after exercise come back to slides to explain how the $LSB_JOBINDEX variable can be used. 
- Exercise: often participants ask further explanations about this script, in particular as there is a lot of bash programming. You can point them to the [Unix materials](https://cambiotraining.github.io/unix-shell/materials/02-programming/02-variables.html) if they are not familiar with bash variables. 


## Tips & Tricks

- At the end of the course, go through these slides to share some time-saving tips. 
  - **Time saver:** skip this section if you've ran out of time.
- Also use this last session to clarify any remaining questions.
