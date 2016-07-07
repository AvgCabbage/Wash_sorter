#!/bin/bash

#Author: AvgCabbage
#Date:07/07/2016
#
#Use: Run wash to discover APs with wps enabled, then sort the results by power level

clear

#check if arguments are given
if [ $# -eq 0 ];then
	printf "\nMust specify options"
	printf "\n-f   input file"
	printf "\n-i   interface"
	printf "\n-t   timeout (ie. 10s)"
	exit 0
fi

#Set the variables with given arguments
while [[ $# -gt 1 ]]
do
	key="$1"
	case $key in
			-f)
			file="$2"
			shift
			;;
			-i)
			iface="$2"
			shift
			;;
			-t)
			timeout="$2"
			shift
			;;
			*)
			;;
	esac
shift
done

printf "Logging to ${file}..."
printf "\nUsing interface ${iface}..."
printf "\nScanning for ${timeout}...\n"
echo

#Check to make sure given interface exists
if [ ! -e /sys/class/net/"${iface}" ]
then
	printf "\nInterface ${iface} not found"
	exit 0
fi

#Run wash for the given amount of time and output to file
timeout $timeout wash -i ${iface} -C > "${file}"

#Get number of lines in output file, minus the header from wash
l=$( expr $( wc -l ${file} | sed "s/${file}//g" ) - "7" )


printf "\n------------------Networks sorted by signal strength----------------------"
printf "\n--------------------------------------------------------------------------\n"

#Sort the file starting at the first network to the last
##Replaces whitespace with ',' to make sorting easier, then replaces with tabs when finished
tail -n $l ${file} | tr -s ' ' ',' | sort -gr -k3,3 -t , | tr ',' '\t'
printf "\n"

exit 0
