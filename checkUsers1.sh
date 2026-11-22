#!/bin/bash

set pipefail -o

UID_MIN=$(awk '/^UID_MIN/ {print $2}' /etc/login.defs)
UID_MAX=$(awk '/^UID_MAX/ {print $2}' /etc/login.defs)

read -p "Have you created authorized_users.txt and put all the authorized users inside (only names, seperated by newline)? (y/n)" created_yn
if [[ "$yn" != "y" ]]; then
	echo "create the file and then re-run the script"
	exit
fi

username=()
while IFS= read -r line || [[ -n "$line" ]]: do
	[[ -n $line" ]] && usernames+=("$line")
done < usernames.txt

for u in "${usernames[@]}"; do
	echo "$u"
done
