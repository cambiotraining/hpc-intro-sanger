---
pagetitle: "Sanger HPC"
output:
  html_document:
    toc: false
---

:::warning
Please make sure to follow these instructions before attending our workshops.
If you have any issues installing the software please get in touch with us beforehand.
:::

:::highlight
There are two recommended pieces of software needed to work with the HPC:

- a terminal
- a file transfer software

This document gives instructions on how to install or access these on different operating systems.
:::

## Unix terminal {.tabset}

### Windows

If you are comfortable with installing software on your computer, we highly recommend installing the **Windows Subsystem for Linux** (WSL2), which provides native _Linux_ functionality from within Windows.  
Alternatively, you can install **MobaXterm**, which provides a Unix-like terminal on _Windows_.  
We provide instructions for both, but you only need to install one of them.

----

##### MobaXterm (easier)

- Go the the [MobaXterm download page](https://mobaxterm.mobatek.net/download-home-edition.html).
- Download the "_Portable edition_" (blue button). 
  - Unzip the downloaded file and copy the folder to a convenient location, such as your Desktop.
  - You can directly run the program (without need for installation) from the executable in this folder. 

You can access your Windows files from within MobaXterm.
Your `C:\` drive is located in `/drives/C/` (equally, other drives will be available based on their letter). 
For example, your documents will be located in: `/drives/C/Users/<WINDOWS USERNAME>/Documents/`. 
By default, MobaXterm creates shortcuts for your Windows Documents and Desktop.  
It may be convenient to set shortcuts to other commonly-used directories, which you can do using _symbolic links_.
For example, to create a shortcut to Downloads: `ln -s /drives/C/Users/<WINDOWS USERNAME>/Downloads/ ~/Downloads`

----

##### WSL

There are detailed instructions on how to install WSL on the [Microsoft documentation page](https://learn.microsoft.com/en-us/windows/wsl/install). 
But briefly:

- Click the Windows key and search for  _Windows PowerShell_, right-click on the app and choose **Run as administrator**. 
- Answer "Yes" when it asks if you want the App to make changes on your computer. 
- A terminal will open; run the command: `wsl --install`. 
  - This should start installing "ubuntu". 
  - It may ask for you to restart your computer. 
- After restart, click the Windows key and search for _Ubuntu_, click on the App and it should open a new terminal. 
- Follow the instructions to create a username and password (you can use the same username and password that you have on Windows, or a different one - it's your choice). 
- You should now have access to a Ubuntu Linux terminal. 
  This (mostly) behaves like a regular Ubuntu terminal, and you can install apps using the `sudo apt install` command as usual. 

After WSL is installed, it is useful to create shortcuts to your files on Windows. 
Your `C:\` drive is located in `/mnt/c/` (equally, other drives will be available based on their letter). 
For example, your desktop will be located in: `/mnt/c/Users/<WINDOWS USERNAME>/Desktop/`. 
It may be convenient to set shortcuts to commonly-used directories, which you can do using _symbolic links_, for example: 

- **Documents:** `ln -s /mnt/c/Users/<WINDOWS USERNAME>/Documents/ ~/Documents`
  - If you use OneDrive to save your documents, use: `ln -s /mnt/c/Users/<WINDOWS USERNAME>/OneDrive/Documents/ ~/Documents`
- **Desktop:** `ln -s /mnt/c/Users/<WINDOWS USERNAME>/Desktop/ ~/Desktop`
- **Downloads**: `ln -s /mnt/c/Users/<WINDOWS USERNAME>/Downloads/ ~/Downloads`


### macOS

Mac OS already has a terminal available.  
Press <kbd><kbd>&#8984;</kbd> + <kbd>space</kbd></kbd> to open _spotlight search_ and type "terminal".

Optionally, if you would like a terminal with more modern features, we recommend installing [_iTerm2_](https://iterm2.com).


### Linux

Linux distributions already have a terminal available.  
On _Ubuntu_ you can press <kbd><kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>T</kbd></kbd> to open it.


## Filezilla {.tabset}

### Windows

- Go to the [Filezilla Download page](https://filezilla-project.org/download.php?show_all=1) and download the file _FileZilla_3.65.0_win64-setup.exe_ (the latest version might be slightly different). Double-click the downloaded file to install the software, accepting all the default options. 
- After completing the installation, go to your Windows Menu, search for "Filezilla" and launch the application, to test that it was installed successfully. 

### macOS

- Go to the [Filezilla Download page](https://filezilla-project.org/download.php?show_all=1) and download the file _FileZilla_3.65.0_macosx-x86.app.tar.bz2_ (the latest version might be slightly different).
  - Note: If you are on Mac OS X 10.11.6 [download version 3.51.0](https://download.filezilla-project.org/client/FileZilla_3.51.0-rc1_macosx-x86.app.tar.bz2) instead.
- Go to the Downloads folder and double-click the file you just downloaded to extract the application. Drag-and-drop the "Filezilla" file into your "Applications" folder. 
- You can now open the installed application to check that it was installed successfully (the first time you launch the application you will get a warning that this is an application downloaded from the internet - you can go ahead and click "Open").

### Linux

- _Filezilla_ often comes pre-installed in major Linux distributions such as Ubuntu. Search your applications to check that it is installed already. 
- If it is not, open a terminal and run:
  - Ubuntu: `sudo apt-get update && sudo apt-get install filezilla`
  - CentOS: `sudo yum -y install epel-release && sudo yum -y install filezilla`

