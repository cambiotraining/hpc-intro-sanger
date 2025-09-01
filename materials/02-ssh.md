---
pagetitle: "Sanger HPC"
---

# Working on the Farm

::: {.callout-tip}
#### Learning Objectives

- Use different software tools to work on a remote server: terminal, text editor and file transfer software.
- Login to the farm and navigate its filesystems.
- Edit scripts on the HPC using _Nano_.
- Move files in and out of the farm using _Filezilla_ or `rsync`/`scp`. 

:::

![Useful tools for working on the farm or any remote HPC server. The terminal is used to login to the HPc and interact with it (e.g. submit jobs, navigate the filesystem). _Nano_ is a text editor that can be used from the terminal. _Visual Studio Code_ is an alternative text editor that has the ability to connect to a remote server so that we can edit scripts stored on the HPC. _Filezilla_ is an FTP application, which can be used to transfer files between the HPC and your local computer.](images/tool_overview.svg)


## Connecting to the HPC

All interactions with the farm happen via the terminal (or command line).
To connect to the HPC we use the program `ssh`.
The syntax is:

```bash
ssh your-hpc-username@hpc-address
```

To log onto the Sanger farm, you'll need to add "-login" to the name of the HPC, using this command:

```bash
ssh sanger-username@farm22-login
```

The Sanger service desk has set up your laptop to assume your Sanger ID, so you can use the simplified command to access the farm:
```bash
ssh farm22-login
```

The first time you connect to an HPC, you may receive a message about the ECDSA key fingerprint.  By typing `yes` you'll add the 'fingerprint' of this HPC to your local computer's saved list of approved hosts.

After running this `ssh` command and approving any ECDSA key questions, you will be asked for your Sanger password and after typing it you will be logged in to the farm.


We will be using a test server called **gen22** in this course.  It is a small HPC, similar in structure to the larger farm22, run by the Sanger for scientists to learn about the farm and test LSF scripts.  Everyone with a Sanger ID has access to gen22, but farm22, the main HPC, is only accessible once you complete the Farm Induction course.

![Login to HPC using the terminal. 1) Use the ssh program to login to gen22.  2) If prompted, approve ECDSA key fingerprint. 3) When you type the command you will be asked for your password. Note that as you type the password nothing shows on the screen, but that's normal. 4) You will receive a login message and notice that your terminal will now indicate your HPC username and the name of the HPC server.](images/terminal_ssh.png)


### Exercise

::: {.callout-exercise}
#### Connecting to the HPC

**Q1.** Connect to gen22 using `ssh`

**Q2.**
Take some time to explore your home directory to identify what files and folders are in there.
Can you identify and navigate through the scratch (Lustre) and NFS directories?

**Q3.**
Print the path to your home directory.

**Q4.**
Create a directory called `hpc_workshop` in your own home directory.

**Q5.**
Use the commands `free -h` (available RAM memory) and `nproc --all` (number of CPU cores available) to check the capabilities of the login node of our HPC.
Check how many people are logged in to the HPC login node using the command `who`.

::: {.callout-answer}

**A1.**

To login to the HPC we run the following from the terminal:

```bash
ssh USERNAME@gen22
```

(replace "USERNAME" with your Sanger username)

**A2.**

We can get a detailed list of the files on our home directory:

```bash
ls -l
```

Further, we can explore the NFS directory using:

```bash
ls /nfs
```

And check out the scratch folders available in lustre:

```bash
ls -l /lustre
```


**A3.**

To find the path of your home directory, move to it and then use the `pwd` command to print the entire path:

```bash
cd
pwd
```

It should be `/nfs/users/nfs_[first_initial_of_username]/[username]`


**A4.**
Once we are in the home directory, we can use `mkdir` to create our workshop sub-directory:

```bash
cd
mkdir hpc_workshop
```

**A5.**

We run these commands to investigate how much memory and CPUs the _login node_ that we connected to at the moment has. 
Usually, the login node is not very powerful, and we should be careful not to run any analysis on it. 

To see how many people are currently on the login node we can combine the `who` and `wc` commands:

```bash
# pipe the output of `who` to `wc`
# the `-l` flag instructs `wc` to count "lines" of its input
who | wc -l
```

You should notice that several people are using the same login node as you.
This is why we should **never run resource-intensive applications on the login node** of a HPC.

:::
:::


## Editing Scripts Remotely

Most of the work you will be doing on a HPC is editing script files.
These may be scripts that you are developing to do a particular analysis or simulation, for example (in _Python_, _R_, _Julia_, etc.).
But also - and more relevant for this course - you will be writing **shell scripts** containing the commands that you want to be executed on the compute nodes.

There are several possibilities to edit text files on a remote server.
A simple one is to use the program _Nano_ directly from the terminal. 
This is a simple text editor available on most linux distributions, and what we will use in this course.

Although _Nano_ is readily available and easy to use, it offers limited functionality and is not as user friendly as a full-featured text editor.
You can use other more full-featured text editors from the command line such as `vim`, but it does come with a steeper learning curve. 
Alternatively, we recommend [_Visual Studio Code_](https://code.visualstudio.com/), which is an open-source software with a wide range of functionality and several extensions, including an extension for [working on remote servers](https://code.visualstudio.com/docs/remote/ssh).


### Nano

<img src="https://upload.wikimedia.org/wikipedia/commons/9/97/GNU-Nano-Logo.png" alt="Nano text editor logo" style="float:right;width:20%">

To create a file with _Nano_ you can run the command:

```bash
nano test.sh
```

This opens a text editor, where you can type the code that you want to save in the file. 
Once we're happy with our code, we can press <kbd>Ctrl</kbd>+<kbd>O</kbd> to write our data to disk. 
We'll be asked what file we want to save this to: press <kbd>Enter</kbd> to confirm the filename.
Once our file is saved, we can use <kbd>Ctrl</kbd>+<kbd>X</kbd> to quit the editor and return to the shell.

We can check with `ls` that our new file is there. 

![Screenshot of the command line text editor _Nano_. In this example, we also included `!#/bin/bash` in the first line of the script. This is called a [_shebang_](https://en.wikipedia.org/wiki/Shebang_(Unix)) and is a way to inform that this script uses the program `bash` to run the script.](images/nano.png)

Note that because we saved our file with `.sh` extension (the conventional extension used for shell scripts), _Nano_ does some colouring of our commands (this is called _syntax highlighting_) to make it easier to read the code. 


### Exercise

::: {.callout-exercise}
#### Editing scripts

1. Create a new script file called `check_hostname.sh`. Copy the code shown below into this script and save it.
1. From the terminal, run the script using `bash`.

```bash
#!/bin/bash
echo "This job is running on:"
hostname
```

::: {.callout-answer}
**A1.**

To create a new script in _Nano_ we use the command:

```bash
nano check_hostname.sh
```

This opens the editor, where we can copy/paste our code. 
When we are finished we can click <kbd>Ctrl</kbd>+<kbd>X</kbd> to exit the program, and it will ask if we would like to save the file. 
We can type "Y" (Yes) followed by <kbd>Enter</kbd> to confirm the file name. 

**A2.**

We can run the script from the terminal using:

```bash
bash test.sh
```

Which should print the result (your hostname might vary slightly from this answer):

```
This job is running on:
gen22-head1
```

(the output might be slightly different if you were assigned to a different login node of the HPC)

:::
:::


## Summary

::: {.callout-tip}
#### Key Points

- The terminal is used to connect and interact with the HPC. 
  - To connect to the HPC we use `ssh username@remote-hostname`.
- _Nano_ is a text editor that is readily available on HPC systems. 
  - To create or edit an existing file we use the command `nano path/to/filename.sh`. 
  - Keyboard shortcuts are used to save the file (<kbd>Ctrl + O</kbd>) and to exit (<kbd>Ctrl + X</kbd>).
:::
