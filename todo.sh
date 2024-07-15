#!/bin/sh

if [ -n "$BASH_VERSION" ]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
elif [ -n "$ZSH_VERSION" ]; then
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
fi

FILE="$SCRIPT_DIR/TODO.txt"
FILE_BACKUP="$SCRIPT_DIR/TODO.txt.bk"

checkFile(){

  if [ ! -f "$FILE" ]; then
    echo "TODO.txt file doesn't exist.  Creating now!" &&
    touch "$FILE" &&
    sleep 0.4 &&
    echo -e "\nFile created"
  fi
}

editFile(){

  checkFile

  nano "$FILE"

  backupFile
}

backupFile(){ 
  
  cp "$FILE" "$FILE_BACKUP"

  #echo "ToDo file is backed-up!"

}

appendFile(){

  checkFile

  #create a temp file
  local tempfile=$(mktemp)

  #Cancel on ctrl+c
  #IMPORTANT! 'return 1' seems to make it work from zShell without exiting back to Bash - was 'exit 0' before
  trap 'echo -e "\nAppending cancelled"; rm -f $tempfile; return 1' INT

  #this '-' within cat should allow new line after 'enter' has been hit to be appended also;
  echo -e "\n" && cat - > "$tempfile"

  if [[ -s $tempfile ]]; then

    echo -e "\n" >> $tempfile &&

    cat $tempfile >> "$FILE"
    
  fi 

  rm -f "$tempfile"

} 

appendComplete(){
  echo -e "\n" &&
  sleep 1 && 
  echo -n "Text is being appended to TODO.txt." &&
  sleep .5 &&
  echo -n "." &&
  sleep .4 && 
  echo -n "." &&
  sleep .4 &&
  echo -n "." &&
  sleep .3 &&
  echo -n "." &&
  sleep .3 &&
  echo -n "." &&
  sleep .2 &&
  echo -n "." &&
  sleep .2 &&
  echo -n "." &&
  sleep .2 &&
  echo -e "\n\nTODO.txt file was successfully appended to!\n"

}

displayFile(){

  checkFile &&
  
  less "$FILE" 

}

outputTail(){

  checkFile &&

  echo
  tail "$FILE"

}

invalidOption(){

  echo -e "\nInvalid option!\n"

}



restoreBackup(){

  
  checkFile

  #-if zshell/or bash(echo "are you sure, --Warning Message-- (y/n)", read input); 
  #---if/case no, exit;
  #---if/case yes, cat $FILE_BACKUP > $FILE #this will over-write data!

  # this wouldn't work within the case to perform the function via variable
  #local restore=$(cat $FILE_BACKUP > $FILE)
  
  #-debug
  #local restore=$(echo "Hi")
  
  local user_verification="Are you sure? Your current TODO.txt will be over-written (y/n): "

  if [ -n "$BASH_VERSION" ]; then

    read -p "$user_verification" answer
    
  elif [ -n "$ZSH_VERSION" ]; then

    echo "$user_verification \c"
    read answer
    
  fi

  case "$answer" in
    y | Y | [Yy][Ee][Ss]) 
      # $restore wont work, had to be done manually
      cat $FILE_BACKUP > $FILE &&
      echo -e "\nRestoration complete!\n"
    ;;
    [Nn] | [Nn][Oo])
      echo -e "\nProcess aborted!\n" &&
      sleep 0.3
    ;;
    *)
      echo -e "\nInvalid input - Process aborted!\n" &&
      sleep 0.3
    ;;
  esac

}



userHelp(){

  echo -e "\nUsage: todo <flag>\n\n\t| -e (Edit TODO.txt) \n\t| -a (Append TODO.txt) \n\t| -d (Display all TODO.txt) \n\t| -h || --help (Help User Menu) \n\t| -t (Display tail/end of TODO.txt) \n\t| -rf (Restore from backup file $FILE_BACKUP) \n"

}



main(){
  
  case "$1" in
    -a) echo -e "\nTo Cancel, press ctrl+c! To finish appending, press enter, then ctrl+d\n" && 
      appendFile && 
      appendComplete &&
      backupFile
    ;;
    -e) shift; editFile
    ;;
    -t) outputTail 
    ;;
    -d) displayFile 
    ;;
    -rf) restoreBackup
    ;;
    --help | -h) userHelp
    ;;
    -* | "") invalidOption && userHelp
    ;;
  esac

}

main $1
