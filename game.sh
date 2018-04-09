#!/bin/bash
trap ctrl_c INT
trap handle_exit exit
function ctrl_c() {
	exit 0
}
function handle_exit() {
	clear
	echo "CLEANED UP"
	cd $GAME_DIR
	./cleanup.sh
}
./worldbuild.sh
GAME_DIR=`pwd -P`
echo "ls
ls -l
cd
less" > $GAME_DIR/tool.kit
cd game
localHome=`pwd -P`
absoluteHome=`pwd -P`
homeLen=${#localHome}
currDir=$localHome
cmd=">>"
cd start
clear
less README.txt
while : 
	do
		currDir=`pwd -P`
    		read -p "`pwd -P`$cmd " inputline
		currCommand=$(grep "$inputline" $GAME_DIR/tool.kit)
		echo "$inputline" > $GAME_DIR/.hist
		if [[ $inputline == "exit" ]]
		then
			exit 0
		elif [[ ${inputline:0:4} == "less" ]]
		then
			$inputline 2>&1
		elif [[ ${inputline:0:2} == "cd" ]]
		then
			$inputline 2>&1
			currDir=`pwd -P`
			if [[ $currDir == $localHome/D1 ]]
			then
				homeLen=${#currDir}
				localHome=$currDir
				cmd=">LOCK>"
			fi
			if [[ $currDir == $localHome/D2 ]]
			then
				xrandr --output LVDS1 --rotate inverted
			fi

		elif [[ $currCommand != "" ]]
		then
			$inputline 2>&1
		else
			if [[ $currDir == $absoluteHome/D1 ]]
			then
				if [[ $inputline == "./escape.sh" ]]
				then
					echo "USAGE: ./escape.sh <password>"
				elif [[ $inputline == "./escape.sh EXECUTION" ]]
				then
					cd ..
					currDir=`pwd -P`
					localHome=`pwd -P`
					homeLen=${#currDir}
					cmd=">>"
					mv D1/ D1\<COMPLETE\>
					cd ..
					./buildD2.sh
					cd game
				else
					echo "$inputline: command?? not found in toolkit"
				fi
			else
				echo "$inputline: command not found in toolkit"
			fi
		fi
		currDir=`pwd -P`
		if [[ ${#currDir} < $homeLen ]]
		then
			echo "ACCESS DENIED"
			cd $localHome
		fi
done
