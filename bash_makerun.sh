#!/bin/bash

name=$1

if [[ -n "$name" ]]; then
	echo "dasm $name.asm -o$name.prg && ~/d/games/vice/xplus4.exe $PWD/$name.prg"
	dasm $name.asm -o$name.prg 
	~/d/games/vice/xplus4.exe $name.prg
else
	echo "prescribed usage:"
	echo "./osx_makerun.sh \${project_name}"
fi

