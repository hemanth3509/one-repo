#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo " Script started "

help(){
    echo " USAGE : { sh old-logs.sh -s <source-dir> -a <archive|delete> -d <destination> -t <day> -m <memory-in-mb> } "
    echo " -s <source dir> "
    echo " -a <Archive> or <Delete>"
    echo " -d <destination >"
    echo " -t <time>"
}

action (){
    if [ ! -d "$SOURCE_DIR" ]  # ! denotes opposite
then
    echo -e "$R Source directory: $SOURCE_DIR does not exists. $N"
    else
    if [ "$archive" == "archive" ] && [ ! -d "$DESTINATION" ]
    then
    echo -e "$R Please provide valid destination directory $N"
    else
     if [ "$archive" == "archive" ] && [ -d "$DESTINATION" ]
     then
    echo -e "$G destination exits to archive $N"
    fi
   fi
    if [ "$archive" == "delete" ]
    then 
        echo -e "$G Source directory exists $SOURCE_DIR please delete $N"
        FILES_TO_DELETE=$(find $SOURCE_DIR -type f -mtime "+"$TIME -name "*.log")

        while IFS= read -r line
            do
                echo "Deleting file: $line"
                rm -rf $line
        done <<< $FILES_TO_DELETE
    fi
fi
}

options(){
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

if [ "$1" != "-s" ]
    then
        help
        exit 1
    else
        options "$@"
fi

if [ "$archive" == "archive" ] || [ "$archive" == "delete" ]
    then
    action "$archive" "$DESTINATION"
    else
    help
fi
