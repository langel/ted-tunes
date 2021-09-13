#!/bin/bash

name=$1

if [[ -n "$name" ]]; then
	echo "dasm $name.asm -o$name.prg && xplus4 $name.prg"
	dasm $name.asm -o$name.prg && xplus4 $PWD/$name.prg
else
	echo "prescribed usage:"
	echo "./osx_makerun.sh \${project_name}"
fi
