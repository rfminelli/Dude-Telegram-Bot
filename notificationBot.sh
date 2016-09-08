#!/bin/bash

CHATID_grp1="-000000001";
CHATID_grp2="-000000002";
CHATID_grp3="-000000003";
CHATID_grp4="-000000004";

TOKEN="2643673:TeLeGraM_BoT_ToKeN_0siq";
TIME="10";
URL="https://api.telegram.org/bot${TOKEN}/sendMessage";

tail -Fn0 /var/log/dude.log | while read notifications; do
	notification=$(echo "${notifications}" | grep -o 'dude,event Service.*' | cut -d ' ' -f2-);
	[ -z "${notification}" ] && continue;

	# Emoji Icon
	if [ "`echo ${notification} | grep -c 'is now _down_'`" -ne "0" ]; then
		emoji="%F0%9F%94%B4 ";
	elif [ "`echo ${notification} | grep -c 'is now _up_'`" -ne "0" ]; then
		emoji="%E2%9C%85 ";
	elif [ "`echo ${notification} | grep -c 'is now _acked_'`" -ne "0" ]; then
		emoji="%F0%9F%94%B5 ";
	fi;

	# All Notifications
	curl -s --max-time ${TIME} -d "chat_id=${CHATID_grp4}&disable_web_page_preview=1&parse_mode=markdown&text=${emoji}${notification}" $URL >/dev/null

	client=$(echo "${notification}" | perl -p -e 's/Service.*at \*(.*)\* on.*/$1/g');
	deviceName=$(echo "${notification}" | perl -p -e 's/Service.*at \*.*\* on (.*) [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3} .*/$1/g');
	ipAddr=$(echo "${notification}" | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}');
	status=$(echo "${notification}" | grep -o '_\(.*\)_' | tr -d '_');
	statusMsg=$(echo "${notification}" | grep -o '`\(.*\)`' | tr -d '`()');

	# Add to sqlite database
	[ -n "${client}" ] && sqlite3 /path/dude/notifications.db "INSERT into dudeNotifications (client,deviceName,ipAddr,status,statusMsg) values (\"${client}\",\"${deviceName}\",\"${ipAddr}\",\"${status}\",\"${statusMsg}\");";

	# Group 1
	if [ "`echo "${client}" | grep -c 'Group1'`" -ne "0" ]; then
		curl -s --max-time ${TIME} -d "chat_id=${CHATID_grp1}&disable_web_page_preview=1&parse_mode=markdown&text=${emoji}${notification}" $URL >/dev/null
	fi;


	# Only Alarms
	if [ "`echo ${notification} | grep -c 'is now _down_'`" -ne "0" ]; then

		# Group 2
		if [ "`echo "${client}" | grep -c 'Group 2'`" -ne "0" ]; then
			curl -s --max-time ${TIME} -d "chat_id=${CHATID_grp2}&disable_web_page_preview=1&parse_mode=markdown&text=${emoji}${notification}" $URL >/dev/null
		fi;

		# Group 3
		if [ "`echo "${client}" | grep -c 'Group 3'`" -ne "0" ]; then
			curl -s --max-time ${TIME} -d "chat_id=${CHATID_grp3}&disable_web_page_preview=1&parse_mode=markdown&text=${emoji}${notification}" $URL >/dev/null
		fi;
	fi;
done;
