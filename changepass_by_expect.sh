#!/bin/sh
if [ $# -ne 2 ]; then
	echo "Usage:$argv0 <username> <passwd>"
	exit 2
else 
	USERNAME=$1
	PASSWORD=$2
	expect<<-END
	spawn passwd $USERNAME 
	sleep 2
	expect "assword:"
	send "$PASSWORD\r"
	expect "assword:"
	send "$PASSWORD\r"
	expect eof
	END
fi

