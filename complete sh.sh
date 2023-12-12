#!/bin/bash

#This is the comment section and first is in shell script mandate first line

USERNAME=$1
PASSWORD=$2
echo "Please enter your username"
read  username
echo "Please enter your password"
read -s password

echo "your user name is $username and password is $password"
echo "thank you"