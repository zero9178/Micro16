#!/bin/sh

./build.sh

if [ $# -eq 0 ] 
then
	# Register tests here
	EXECUTABLES="./work/micro16_tb:./work/decoder_tb"
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
		COMMAND="${p} --vcd=./work/$(basename $p).vcd" 
		echo "Executing ${COMMAND}"
		eval $COMMAND
	done
)
