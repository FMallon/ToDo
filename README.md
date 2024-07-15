# ToDo
Old script I made, newly improved to work with zShell, as well as restore-from-backup functionality.

The script will use, and add to a text file, User Notes.

In terminal:

  -  todo -a #this will bring up a prompt for the User to add a not.  Pressing Enter, then [Ctrl+d] will append to the file.  [Ctrl + c] will cancel.

  -  todo -e #this will allow the User to edit manually via Nano

  -  todo -h #will bring up a Help Menu with all the options

There are other functions, like auto-backup, and restoring from backup file.

This is functional with zShell & Bash.


# Installation Guide

  -  git clone https://github.com/FMallon/ToDo/ #to desired directory path

Then add to your ~/.bashrc &/or ~/.zshrc:
  -  alias [your desired alias name]='. ~/The/Path/To/The/Folder/todo.sh'<br>
    <b>#example:</b> alias todo='. ~/Programs/ToDo/todo.sh'<br>
      <b>#or:</b> alias todo='source ~/Programs/ToDo/todo.sh'<br>
      <b>#this will depend on your path to the Program, and your desired alias name etc.</b>


  
