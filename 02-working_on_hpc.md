---
pagetitle: "Sanger HPC"
---

# Working on the Farm

:::highlight
#### Questions

- How do I access the Sanger farm?
- How do I edit files on the farm?
- How do I move files in/out of the farm?

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

```console
ssh your-hpc-username@hpc-address
```

To log onto the Sanger farm, you'll need to add "-login" to the name of the HPC, using this command:

```console
ssh sanger-username@farm5-login
```

The Sanger service desk has set up your laptop to assume your Sanger ID, so you can use the simplified command to access the farm:
```console
ssh farm5-login
```

The first time you connect to an HPC, you may receive a message about the ECDSA key fingerprint.  By typing `yes` you'll add the 'fingerprint' of this HPC to your local computer's saved list of approved hosts.

After running this `ssh` command and approving any ECDSA key questions, you will be asked for your Sanger password and after typing it you will be logged in to the farm.


We will be using a test server called **gen3** in this course.  It is a small HPC, similar in structure to the larger farm5, run by the Sanger for scientists to learn about the farm and test LSF scripts.  Everyone with a Sanger ID has access to gen3, but farm5, the main HPC, is only accessible once you complete the Farm Induction course.

![Login to HPC using the terminal. 1) Use the ssh program to login to gen3.  2) If prompted, approve ECDSA key fingerprint. 3) When you type the command you will be asked for your password. Note that as you type the password nothing shows on the screen, but that's normal. 4) You will receive a login message and notice that your terminal will now indicate your HPC username and the name of the HPC server.](images/terminal_ssh.png)


:::exercise

**Q1.** Connect to gen3 using `ssh`

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

<details><summary>Answer</summary>

**A1.**

To login to the HPC we run the following from the terminal:

```bash
ssh USERNAME@gen3
```

(replace "USERNAME" with your Sanger username)

**A2.**

We can get a detailed list of the files on our home directory:

```console
ls -l
```

Further, we can explore the NFS directory using:
```console
ls /nfs
```

And check out the scratch folders available in lustre:
```console
ls -l /lustre
```


**A3.**

To find the path of your home directory, move to it and then use the `pwd` command to print the entire path:
```console
cd
pwd
```

It should be `/nfs/users/nfs_[first_initial_of_username]/[username]`


**A4.**
Once we are in the home directory, we can use `mkdir` to create our workshop sub-directory:

```console
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

</details>
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

```console
nano test.sh
```

This opens a text editor, where you can type the code that you want to save in the file. 
Once we're happy with our code, we can press <kbd>Ctrl</kbd>+<kbd>O</kbd> to write our data to disk. 
We'll be asked what file we want to save this to: press <kbd>Enter</kbd> to confirm the filename.
Once our file is saved, we can use <kbd>Ctrl</kbd>+<kbd>X</kbd> to quit the editor and return to the shell.

We can check with `ls` that our new file is there. 

![Screenshot of the command line text editor _Nano_. In this example, we also included `!#/bin/bash` in the first line of the script. This is called a [_shebang_](https://en.wikipedia.org/wiki/Shebang_(Unix)) and is a way to inform that this script uses the program `bash` to run the script.](images/nano.png)

Note that because we saved our file with `.sh` extension (the conventional extension used for shell scripts), _Nano_ does some colouring of our commands (this is called _syntax highlighting_) to make it easier to read the code. 


:::exercise

1. Create a new script file called `check_hostname.sh`. Copy the code shown below into this script and save it.
1. From the terminal, run the script using `bash`.

```bash
#!/bin/bash
echo "This job is running on:"
hostname
```

<details><summary>Answer</summary>
**A1.**

To create a new script in _Nano_ we use the command:

```console
nano check_hostname.sh
```

This opens the editor, where we can copy/paste our code. 
When we are finished we can click <kbd>Ctrl</kbd>+<kbd>X</kbd> to exit the program, and it will ask if we would like to save the file. 
We can type "Y" (Yes) followed by <kbd>Enter</kbd> to confirm the file name. 

**A2.**

We can run the script from the terminal using:

```console
bash test.sh
```

Which should print the result (your hostname might vary slightly from this answer):

```
This job is running on:
gen3-head1
```

(the output might be slightly different if you were assigned to a different login node of the HPC)

</details>
:::


## Moving Files

There are several options to move data between your local computer and a remote server.
We will cover three possibilities in this section, which vary in their ease of use.

A quick summary of these tools is given in the table below.

| | Filezilla | SCP | Rsync |
| :-: | :-: | :-: | :-: |
| Interface | GUI | Command Line | Command Line |
| Data synchronisation | yes | no | yes |


### Filezilla (GUI)

This program has a graphical interface, for those that prefer it and its use is relatively intuitive.

To connect to the remote server (see Figure 3):

1. Fill in the following information on the top panel:
  - Host: gen3
  - Username: your HPC username
  - Password: your HPC password
  - Port: 22
1. Click "Quickconnect" and the files on your "home" should appear in a panel on right side.
1. Navigate to your desired location by either clicking on the folder browser or typing the directory path in the box "Remote site:".
1. You can then drag-and-drop files between the left side panel (your local filesystem) and the right side panel (the HPC filesystem), or vice-versa.

![Example of a Filezilla session. Arrows in red highlight: the connection panel, on the top; the file browser panels, in the middle; the transfer progress panel on the bottom.](images/filezilla.svg)


### `scp` (command line)

This is a command line tool that can be used to copy files between two servers.
One thing to note is that it always transfers all the files in a folder, regardless of whether they have changed or not.

The syntax is as follows:

```bash
# copy files from the local computer to the HPC
scp -r path/to/source_folder <user>@gen3:path/to/target_folder

# copy files from the HPC to a local directory
scp -r <user>@gen3:path/to/source_folder path/to/target_folder
```

The option `-r` ensures that all sub-directories are copied (instead of just files, which is the default).


### `rsync` (command line)

This program is more advanced than `scp` and has options to synchronise files between two directories in multiple ways.
The cost of its flexibility is that it can be a little harder to use.

The most common usage is:

```bash
# copy files from the local computer to the HPC
rsync -auvh --progress path/to/source_folder <user>@gen3:path/to/target_folder

# copy files from the HPC to a local directory
rsync -auvh --progress <user>@gen3:path/to/source_folder path/to/target_folder
```

- the options `-au` ensure that only files that have changed _and_ are newer on the source folder are transferred
- the options `-vh` give detailed information about the transfer and human-readable file sizes
- the option `--progress` shows the progress of each file being transferred

:::warning

When you specify the *source* directory as `path/to/source_folder/` (with `/` at the end) or `path/to/source_folder` (without `/` at the end), `rsync` will do different things:

- `path/to/source_folder/` will copy the files *within* `source_folder` but not the folder itself
- `path/to/source_folder` will copy the actual `source_folder` as well as all the files within it
:::

:::note
**TIP**

To check what files `rsync` would transfer but not actually transfer them, add the `--dry-run` option. This is useful to check that you've specified the right source and target directories and options.
:::


:::exercise


- <a href="https://www.dropbox.com/sh/8ftw8biizk8sio1/AAB393Amhgn4-Kt2b8R1OszRa?dl=1" target="_blank" rel="noopener noreferrer">Download the data</a> for this course to your computer and place it on your Desktop. (do not unzip the file yet!)
- Use _Filezilla_, `scp` or `rsync` (your choice) to move this file to the directory we created earlier: `~/hpc_workshop/`.
- The file we just downloaded is a compressed file. From the HPC terminal, use `unzip` to decompress the file.
- Bonus: how many shell scripts (files with `.sh` extension) are there in your project folder?

<details><summary>Answer</summary>

Once we download the data to our computer, we can transfer it using either of the suggested programs.
We show the solution using command-line tools.

Notice that these commands are **run from your local terminal**:

```bash
# with scp
scp -r ~/Desktop/hpc_workshop_files.zip username@gen3:hpc_workshop/

# with rsync
rsync -avhu ~/Desktop/hpc_workshop_files.zip username@gen3:hpc_workshop/
```

Once we finish transfering the files we can go ahead and decompress the data folder.
Note, this is now run **from the HPC terminal**:

```bash
# make sure to be in the correct directory
cd ~/hpc_workshop/

# decompress the files
unzip hpc_workshop_files.zip
```

Finally, we can check how many shell scripts there are using the `find` program and piping it to the `wc` (word/line count) program:

`find -type f -name "*.sh" | wc -l`

`find` is a very useful tool to find files, check this [Find cheatsheet](https://devhints.io/find) to learn more about it.

</details>
:::


## Summary

:::highlight
#### Key Points

- The terminal is used to connect and interact with the HPC.
  - To connect to the HPC use `ssh user@remote-hostname`.
- _Visual Studio Code_ is a text editor that can be used to edit files directly on the HPC using the "Remote-SSH" extension.
- To transfer files to/from the HPC we can use _Filezilla_, which offers a user-friendly interface to synchronise files between your local computer and a remote server.
  - Transfering files can also be done from the command line, using tools such as `scp` and `rsync` (this is the most flexible tool but also more advanced).
:::
