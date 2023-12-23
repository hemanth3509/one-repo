#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

help(){
    echo " ERROR in passing the arguments "
    echo " USAGE : { sh old-logs.sh -s <source-dir> -a <archive|delete> -d <destination dir> -t <days> -m <memory-in-mb> } "
    echo " -s <source dir> "
    echo " -a <Archive> or <Delete>"
    echo " -d <destination >"
    echo " -t <time>"
}

action (){
    if [ ! -d "$SOURCE_DIR" ] 
    then
      echo -e "$R Source directory: $SOURCE_DIR does not exists. $N"

      exit 1
    else
    if [ "$archive" == "archive" ] && [ ! -d "$DESTINATION" ] # When archive specified then destination is mandate
      then
       echo -e "$R Please provide valid destination directory $N"
       exit 1
    else
    if [ "$archive" == "archive" ] && [ -d "$DESTINATION" ] # When bothe archive and destination is given
     then
        echo -e "$G destination exits to archive $N"
        FILES_TO_ARCHIVE=$(find $SOURCE_DIR -type f -mtime +$TIME -name "*.log") # Finding files to archive
            if [ $? != 0 ] # checks if find executed successfully or not to proceed further
                then 
                echo -e " $R ERROR in finding the files $N" 
                exit 1
                else  
                if [ -n "$FILES_TO_ARCHIVE" ]  # If files are found and available to archive
                then 
                    while IFS= read -r line
                    do
                    echo "Archiving files : $line"
                    zip -r "$DESTINATION/$(basename "$line").zip" $line
                    if [ $? == 0 ]
                        then
                            rm -rf $line
                        else
                            echo " Error in archiving"
                            exit 1
                    fi
                    done <<< $FILES_TO_ARCHIVE
                else
                echo -e "$Y No file to archive $N"  # When no files exists to archive
                fi
            fi
        fi
   fi
    if [ "$archive" == "delete" ]
    then 
        if [ -z "$TIME" ] # Checks if time arg is provided or not
            then 
              echo -e "$R please provide the time to delte the logs $N"
              help
              exit 1
        else
        FILES_TO_DELETE=$(find $SOURCE_DIR -type f -mtime +$TIME -name "*.log")
           if [ $? != 0 ]  # Checks if find executed sucessfully or not 
           then 
           echo -e " $R ERROR in finding the files $N"
           exit 1
           else  
             if [ -n "$FILES_TO_DELETE" ]  # If files are availble to delete
             then 
                while IFS= read -r line
                do
                    echo "Deleting file: $line"
                    rm -rf $line
                done <<< $FILES_TO_DELETE
             else
                    echo -e "$Y No files to delete $N"  # When no files are there
                fi
            fi
        fi
    fi
fi
}

options(){                 # Using getopts for taking the arguments as options form the user
    OPTSTRING=":s:a:d:t:"
        while getopts ${OPTSTRING} opt;
            do
            case ${opt} in
                s)  SOURCE_DIR=$OPTARG ;; 
                a)  archive=$OPTARG ;;
                d)  DESTINATION=$OPTARG ;; 
                t)  TIME=$OPTARG ;; 
                :) 
                    echo " in : please pass the arguments";
                    help; 
                    exit 1 ;;
                ?)  help;
                    exit 1 ;;  
            esac
            done
        shift $((OPTIND -1))
}

options "$@"

#if [ "$1" != "-s" ]  # When the manda
#    then
#        help
#        exit 1
#    else
#        options "$@"
#fi

if [ "$archive" == "archive" ] || [ "$archive" == "delete" ]
    then
    action "$archive" "$DESTINATION"
    else
    help
    exit 1
fi
