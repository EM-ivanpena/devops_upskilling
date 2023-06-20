#!/bin/bash

count_lines_owner(){
	owner=$1
	#echo $(ls -l ./*.txt | sed -n 's/'"$1"'/'"$1"'/p') | awk '{print $9}'
	for file in $(ls -l ./*.txt | awk '($4 == "'$owner'") {print}' | awk '{print $9}'); do
		num_lines=$(wc -l $file)
		echo "File: $file, Lines: $num_lines"
	done
}

count_lines_month(){
	month=$1
	#echo $(ls -l ./*.txt | awk '($6 == "'$1'") {print}' | awk '{print $9}')
	for file in $(ls -l ./*.txt | awk '($6 == "'$month'") {print}' | awk '{print $9}'); do
		num_lines=$(wc -l $file)
		echo "File: $file, Lines: $num_lines"
	done
}


option_o=false
option_m=false

while getopts ":o:m:" option; do
	case "$option" in
	o)
		option_o=true
		if $option_m; then
			echo "Usage: Cannot use both options at the same time. Discarding option o" >&2
			exit 1
		else
			o=${OPTARG}
			echo "Looking for files where the owner is: ${o}"
			count_lines_owner ${o};
			#echo $@
		fi
		;;
	m)
		option_m=true
		if $option_o; then
			echo "Usage: Cannot use both options at the same time. discarding option m" >&2
			exit 1
		else
			m=${OPTARG}
			echo "Looking for files where the month is: ${m}"
			count_lines_month ${m};
		fi
		;;
	?)
		if [ ${OPTARG} != "o" ] && [ ${OPTARG} != "m" ]; then
			echo "Usage: invalid option "${OPTARG}". The script only allows options o or m."
		else
			echo "Usage: option ${OPTARG} requires an argument."
		fi
		;;
	esac
done


#shift $((OPTIND -1))

if [ $OPTIND -eq 1 ]; then
	echo "Usage: No option was passed. Script only allows two options: -o for owner or -m for month."
fi
shift $((OPTIND -1))
