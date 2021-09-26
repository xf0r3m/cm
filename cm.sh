#!/bin/bash


if [ ! -d "$HOME/.cm" ]; then mkdir $HOME/.cm; fi

while getopts ':ab:c:hi:l:u:p:s:' opt; do

		case $opt in
			'a') batch=1;;
			'b') batch=$OPTARG;;
			'c') command=$OPTARG;;
			'h') cat help.txt; exit 0;;
			'i') index=$OPTARG;;
			'l') listPath=$OPTARG;
				list=$(cat $OPTARG | awk '{printf $1" "}');;
			'u') user=$OPTARG;;
			'p') protocol=$OPTARG;;
			's') show=$OPTARG;;
			':') continue;;

		esac
	done


if [ ! "$list" ]; then 

	listPath="$HOME/.cm/list";
	if [ -f $listPath ]; then 	
		list=$(cat $HOME/.cm/list | awk '{printf $1" "}');
	else 
		echo "Nie zdefiniowano domyślnej listy";
		exit 1;
	fi
fi

if [ ! "$user" ]; then

	if [ -f $HOME/.cm/user ]; then
		user=$(cat $HOME/.cm/user);
	else
		echo "Nie zdefiniowano domyślnego użytkownika";
		exit 1;
	fi
fi

if [ ! "$protocol" ]; then protocol="ssh"; fi

if [ "$show" ]; then

	if [ $show = 'list' ]; then cat $listPath | grep -n '.'; fi
	if [ $show = 'user' ]; then echo $user; fi

	exit 0;
fi

if [ "$index" ]; then

	if [ ! "$list" ]; then echo "Nie zdefiniowano listy"; exit 1;
	else
		server=$(cat $listPath | sed -n "${index}p");
		
		if echo $server | grep ":" > /dev/null; then 

			host=$(echo $server | cut -d ":" -f 1);
			port=$(echo $server | cut -d ":" -f 2);

			if [ $protocol = "sftp" ]; then

				sftp -P $port ${user}@${host};
			else

				if [ "$command" ]; then 
					ssh -t ${user}@${host} -p $port "$command";
				else
					ssh ${user}@${host} -p $port;
				fi
			fi
		else

			if [ $protocol = "sftp" ]; then 

				sftp ${user}@${server};

			else
				if [ "$command" ]; then 
					ssh -t ${user}@${server} "$command";
				else 
					ssh ${user}@${server};
				fi
			fi

		fi
	fi

elif [ "$batch" ]; then

	if [ "$command" ]; then

		if echo $batch | grep "-" > /dev/null; then

			if echo $batch | grep "," > /dev/null; then 
				sRange=$(echo $batch | cut -d '-' -f 1);
				eRange=$(echo $batch | cut -d '-' -f 2 | cut -d "," -f 1);

				i=2;
				commaC=$(echo $batch | grep -o ',' | awk '{printf $1"\n"}' | wc -l | awk '{printf $1}');
				commaC=$(expr $commaC + 1);

				while [ $i -le $commaC ]; do
			
					index=$(echo $batch | cut -d "," -f $i);
					server=$(cat $listPath | sed -n "${index}p");

					if echo $server | grep ":" > /dev/null; then 

						host=$(echo $server | cut -d ":" -f 1);
						port=$(echo $server | cut -d ":" -f 2);

						ssh -t ${user}@${host} -p $port "$command";
					else
						ssh ${user}@${server} "$command";
					fi
					i=$(expr $i + 1);

				done

			else
				sRange=$(echo $batch | cut -d "-" -f 1);
				eRange=$(echo $batch | cut -d "-" -f 2);
			fi
				i=$sRange;
				while [ $i -le $eRange ]; do 

					server=$(cat $listPath | sed -n "${i}p");
			
					if echo $server | grep ":" > /dev/null; then

						host=$(echo $server | cut -d ":" -f 1);
						port=$(echo $server | cut -d ":" -f 2);

						ssh -t ${user}@${host} -p $port "$command";
					else

						ssh -t ${user}@${server} "$command";

					fi
					i=$(expr $i + 1);
				done 
		elif echo $batch | grep "," > /dev/null; then 

			i=1;
			commaC=$(echo $batch | grep -o ',' | awk '{printf $1"\n"}' | wc -l | awk '{printf $1}');
			commaC=$(expr $commaC + 1);

			while [ $i -le $commaC ]; do
			
				index=$(echo $batch | cut -d "," -f $i);
				server=$(cat $listPath | sed -n "${index}p");

				if echo $server | grep ":" > /dev/null; then 

					host=$(echo $server | cut -d ":" -f 1);
					port=$(echo $server | cut -d ":" -f 2);

					ssh -t ${user}@${host} -p $port "$command";
				else
					ssh -t ${user}@${server} "$command";
				fi
				i=$(expr $i + 1);

			done

		else
			lineC=$(cat $listPath | wc -l | awk '{printf $1}');

			i=1;
			while [ $i -le $lineC ]; do
			
				server=$(cat $listPath | sed -n "${i}p");

				if echo $server | grep ":" > /dev/null; then 

					host=$(echo $server | cut -d ":" -f 1);
					port=$(echo $server | cut -d ":" -f 2);

					ssh -t ${user}@${host} -p $port "$command";
				else
					ssh -t ${user}@${server} -c "$command";
				fi
				i=$(expr $i + 1);

			done

		fi


	else
		echo "Nie zdefiniowano polecenia";
		exit 1;
	fi

else

	export PS3='> ';
	select server in $list; do

	if [ ! "$server" ]; then break; fi

		if echo $server | grep ":" >> /dev/null; then 

			host=$(echo $server | cut -d ":" -f 1);
			port=$(echo $server | cut -d ":" -f 2);
			
			if [ $protocol = "sftp" ]; then 
				sftp -P $port ${user}@$host;
			else
				if [ "$command" ]; then 
					ssh -t ${user}@$host -p $port "$command";
				else
					ssh ${user}@$host -p $port;
				fi
			fi
		else 
			if [ $protocol = "sftp" ]; then
				sftp ${user}@$server;
			else
				if [ "$command" ]; then
					ssh -t ${user}@$server "$command";
				else
					ssh ${user}@$server;
				fi
			fi
		fi
	done

fi

