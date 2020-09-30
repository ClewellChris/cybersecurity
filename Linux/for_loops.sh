#!/bin/bash

#Create Variables

suids=$(find / -type f -perm /4000 2> /dev/null)

numbers=(echo {0..9})

states='California, Texas, Tennessee, Colorado, Seattle'

list=$(ls)

files=(
'/etc/passwd'
'/etc/shadow'
'/etc/hosts'
)

for numbers in ${numbers[@]}
do
 if [ $numbers = 3 ] || [ $numbers = 5 ] || [ $numbers = 7 ]
then
 echo $numbers
 fi
done

for states in ${states[@]}
do
 if [ $states == 'Hawaii' ]
then
  echo 'Hawaii is the best'
else
  echo 'I am not a fan of Hawaii'
  fi
done

for x in ${list[@]}
do
  echo $x
done

for suid in ${suids[@]}
do
  echo $suid
done

for file in ${files[@]}
do
  ls -l $file
done
