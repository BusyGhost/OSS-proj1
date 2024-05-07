#! /bin/bash

if [ $# -ne 3 ]
then
	echo "usage: ./prj1_12214167_kimseungyeon file1 file2 file3"
	exit 1
fi

echo "
***********OSS-Project1**********
*       StudentID: 12214167     *
*       Name: Seungyeon Kim     *
*********************************"

stop="N"

teams=$1
players=$2
matches=$3

until [ "$stop" = "Y" ]
do
	echo -e "\n[MENU]"
	echo "1. Get the data of Heung-Min Son's Current Club, Appearances, Goals, Assits in
	players.csv"
	echo "2. Get the team data to enter a league position in team.csv"
	echo "3. Get the Top-3 Attendance matches in matches.csv"
	echo "4. Get the team's league position and team's top scorer in teams.csv &player.csv"
	echo "5. Get the modified format of date_GMT in matches.csv"
	echo "6. Get the data of the winningteam by the largest difference on home stadium in teams.c
	sv & matches.csv"
	echo "7. Exit"
	read -p "Enter your CHOICE(1~7) :" choice

	case $choice in 
	1)	
		read -p "Do you want to get the Heung-Min Son's data? (y/n) :" yn
		if [ $yn = "y" ]
		then	cat $players | awk -F, '$1~"Heung-Min Son" {printf("Team:%s, Appearances:%d, Goals:%d, Assits:%d\n", $4, $6, $7, $8)}'
		fi ;;
	2)
		read -p "What do you want to get the team data of league_position[1~20]:" pos
		cat $teams | awk -v a=$pos -F, '$6==a {print a, $1, (($2/($2+$3+$4)))}' ;;
	3)      
                read -p "Do you want to know Top-3 attendance data and average attendance? (y/n) :" yn
                if [ $yn = "y" ]
                then  
			echo "***Top-3 Attendance Match***"
			sort -nr -t ',' -k 2 $matches | tail -n +2 | head -n 3 | awk -F, '{printf("\n%s vs %s (%s)\n%d %s\n", $3, $4, $1, $2, $7)}'
		fi ;;
	4)      
                read -p "Do you want to get each teams's ranking and the highest-scoring player? (y/n) :" yn
                if [ $yn = "y" ]
                then 
			pos=$(cat $teams | awk -F, '$6 ~ /^[0-9]/ {print $6","$1}' | sort -t ',' -k 1n | cut -d, -f2)
			cnt=0
			IFS=$'\n'
			for var in $pos
			do 
				echo -e "\n$((++cnt)) $var"
				cat $players | awk -F ',' -v team=$var '$4==team{print $1 "," $7}' | sort -nr -t ',' -k 2 | head -n 1 | tr ',' ' '
			done
		fi	;;
	5)      
                echo "5" ;;
	6)      
                echo "6" ;;
	7)      
                echo "Bye!"
		stop="Y" ;;
	*)	
		echo "Error: Invalid option.."
	esac
done

exit 0

