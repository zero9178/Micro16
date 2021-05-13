#!/bin/bash
set -e
./build.sh

if [ $# -eq 0 ] 
then
	# Register tests here
	EXECUTABLES="./work/micro16_tb:./work/decoder_tb:./work/alu_tb"
else
	EXECUTABLES=
	for var in "$@"
	do
		NEW=work/$(echo "$var" | tr '[:upper:]' '[:lower:]')
		if [ -z "$EXECUTABLES" ]
		then
			EXECUTABLES=$NEW
		else
			EXECUTABLES="${EXECUTABLES}:${NEW}"
		fi
		
	done
fi

( IFS=:
	for p in $EXECUTABLES; do
		COMMAND="${p} --wave=./work/$(basename $p).ghw" 
		echo "Executing ${COMMAND}"
		eval $COMMAND
	done
)
