---
pagetitle: "Sanger Farm Course: Intro"
---

# Working on the farm

:::highlight
#### Questions

- How do I access the Sanger farm?
- How do I edit files on the farm?
- How do I move files in/out of the farm?

#### Learning Objectives

- Use different software tools to work on a remote server: terminal, _Visual Studio Code_ and _Filezilla_.
- Login to the farm and navigate its filesystems.
- Use the "Remote-SSH" extension in _Visual Studio Code_ to edit scripts directly on the farm.
- Use _Filezilla_ to connect to the farm and move files in and out of its storage.
:::

![Useful tools for working on the farm or any remote HPC server. The terminal is used to login to the HPC and interact with it (e.g. submit jobs, navigate the filesystem). _Visual Studio Code_ is a text editor that has the ability to connect to a remote server so that we can edit scripts stored on the HPC. _Filezilla_ is an FTP application, which can be used to transfer files between the HPC and your local computer.](images/tool_overview.svg)

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

![Login to HPC using the terminal. 1) Use the ssh program to login to gen3.  2) If prompted, approve ECDSA key fingerprint. 3) When you type the command you will be asked for your password. Note that as you type the password nothing shows on the screen, but that's normal. 4) You will receive a login message and notice that your terminal will now indicate your HPC username and the name of the HPC server.](images/terminal_ssh.svg)


:::exercise

> You are automatically allocated 10GB in `/nfs/users/nfs_c/` and 100GB in `/lustre/scratchXXX/`.

**Q1.** Connect to gen3 using `ssh`

**Q2.**
Take some time to explore your home directory to identify what files and folders are in there.
Can you identify and navigate through the scratch and NFS directories?

**Q3.**
Create a directory called `hpc_workshop` in our course's "scratch" directory.

**Q4.**
Use the commands `free -h` (available RAM memory) and `nproc --all` (number of CPU cores available) to check the capabilities of the login node of our HPC.
Check how many people are logged in to the HPC login node using the command `who`.

<details><summary>Answer</summary>

**A1.**

To login to the HPC we run the following from the terminal:

```bash
ssh USERNAME@gen3
```

(replace "USERNAME" by your Sanger username)

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

Once we are in the scratch directory, we can use `mkdir` to create our workshop sub-directory:

```console
mkdir hpc_workshop
```

**A4.**

The main thing to consider in this question is where you run the commands from.
To get the number of CPUs and memory on your computer make sure you open a new terminal and that you see something like `[your-local-username@laptop: ~]$` (where "user" is the username on your personal computer and "laptop" is the name of your personal laptop).
Note that this does not work on the MacOS shell (see [this post](https://www.macworld.co.uk/how-to/how-check-mac-specs-processor-ram-3594298/) for instructions to find the specs of your Mac).

Conversely, to obtain the same information for the HPC, make sure you are logged in to the HPC when you run the commands. You should see something like `[your-hpc-username@login ~]$`

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

:::note
**Passwordless Login**

To make your life easier, you can configure `ssh` to login to a server without having to type your password or username.
This can be done using SSH key based authentication.
See [this page](https://code.visualstudio.com/docs/remote/troubleshooting#_quick-start-using-ssh-keys) with detailed instructions of how to create a key and add it to the remote host.
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


- <a href="https://drive.google.com/u/0/uc?id=14kmKqdvTxhAvwXD91yR_IzNv6Z0tY-Gh&export=download" target="_blank" rel="noopener noreferrer">Download the data</a> for this course to your computer and place it on your Desktop. (do not unzip the file yet!)
- Use _Filezilla_, `scp` or `rsync` (your choice) to move this file to the directory we created earlier: `/scratch/user/hpc_workshop/`.
- The file we just downloaded is a compressed file. From the HPC terminal, use `unzip` to decompress the file.
- Bonus: how many shell scripts (files with `.sh` extension) are there in your project folder?

<details><summary>Answer</summary>

Once we download the data to our computer, we can transfer it using either of the suggested programs.
We show the solution using command-line tools.

Notice that these commands are **run from your local terminal**:

```bash
# with scp
scp -r ~/Desktop/hpc_workshop_files.zip username@gen3:scratch/hpc_workshop/

# with rsync
rsync -avhu ~/Desktop/hpc_workshop_files.zip username@gen3:scratch/hpc_workshop/
```

Once we finish transfering the files we can go ahead and decompress the data folder.
Note, this is now run **from the HPC terminal**:

```bash
# make sure to be in the correct directory
cd ~/scratch/hpc_workshop/

# decompress the files
unzip hpc_workshop_files.zip
```

Finally, we can check how many shell scripts there are using the `find` program and piping it to the `wc` (word/line count) program:

`find -type f -name "*.sh" | wc -l`

`find` is a very useful tool to find files, check this [Find cheatsheet](https://devhints.io/find) to learn more about it.

</details>
:::










:::exercise

If you haven't already done so, connect your local machine to the HPC following the instructions below.

<details><summary>Connecting VS Code to remote host</summary>![](images/vscode_ssh.svg)</details>

1. Move into the `hpc_workshop` folder of your scratch space (this is the folder you created in the previous exercise).
2. Create a new file and save it as `test.sh`. Copy the code shown below into this script and save it.
3. From the terminal, run this script with `bash test.sh`

```bash
#!/bin/bash
echo "This job is running on:"
hostname
```

<details><summary>Answer</summary>
**A1.**

To open the folder we follow the instructions in Figure 3 and use the following path:
`/lustre/user/hpc_workshop`
(replacing "user" with your username)

**A2.**

To create a new script in VS Code we can go to "File > New File" or use the <kbd>Ctrl + N</kbd> shortcut.

**A3.**

We can run the script from the terminal.
First make sure you are on the correct folder:

#########need to edit - get scratch folder
```console
cd /scratch/user/hpc_workshop
```

Then run the script:

```console
bash scripts/test.sh
```

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
