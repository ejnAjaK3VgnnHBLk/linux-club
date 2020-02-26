#!/bin/bash

################################################################################
#									       #
#     THIS SCRIPT HAS NOT BEEN PROPERLY TESTED! USE WITH EXTREME CAUTION!      #
#									       #
################################################################################

# Puropse: automatically generate users with listed usernames, and passwords 
# 	   set to the same thing as the username.
# Details: Perl is used to generate a hash that will be placed into /etc/shadow
# 	   along with the usernames. Usernames and passwords are stored in 
#	   cleartext because we aren't going for ultimate cryptographical 
#	   security. See @TODO.
# TODO:    Setup encryption on home directories and store passwords throughout 
#	   the script in an ecyrpted way to minimize security risk.

# Check for root
if [[ $EUID -ne 0 ]]; then
	echo "User must be run as root"
	exit 1
fi

# Check if perl is installed
if perl < /dev/null > /dev/null 2>&1 ; then
	echo "Perl is installed. Continuing..."
else
	echo "Please install perl to run the script"
	exit 1
fi


declare -a users=("peroid1" "period2" "peroid3" "peroid4" "period5" "peroid6" "peroid7" "peroid8" "period9")

for i in "${users[@]}"; do
	echo $i
	username=$i
	egrep "^$username" /etc/passwd > /dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists!"
		exit 1
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $username)
		useradd -m -p $pass $username
		[ $? -eq 0 ] && echo "User has been added to the system!" || echo "Failed to add user!"
	fi

done


