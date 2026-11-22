#!/bin/bash

set -o pipefail

UID_MIN=$(awk '/^UID_MIN/ {print $2}' /etc/login.defs)
UID_MAX=$(awk '/^UID_MAX/ {print $2}' /etc/login.defs)
authorized_users="authorized_users.txt"

read -p "Have you created ${authorized_users}  and put all the authorized users inside (only names, seperated by newline)? (y/n)" created_yn
if [[ "$created_yn" != "y" ]]; then
	echo "create the file and then re-run the script"
	exit
fi

echo "=== ALL USERS (uid, name, passwd, shell)==="
getent passwd | awk -F: '{print $3, $1, $2, $7}'

all_valid=$(mktemp)
trap 'rm -f "$all_valid"' EXIT #delete temp file when script ends

#while IFS= read -r line || [[ -n "$line" ]]; do
#	echo "$line"
#done < "$authorized_users"

system_users=$(mktemp)
cat > "$all_valid" << 'EOF'
root
daemon
bin
sys
sync
games
man
lp
mail
news
uucp
proxy
www-data
backup
list
irc
_apt
nobody
systemd-network
tss
systemd-timesync
messagebus
usbmux
dnsmasq
avahi
speech-dispatcher
fwupd-refresh
saned
geoclue
polkitd
rtkit
colord
gnome-initial-setup
Debian-gdm
EOF

cat "$authorized_users" >> "$all_valid"
LC_ALL=C sort -u -o "$all_valid" "$all_valid"

getent passwd | cut -d: -f1 | LC_ALL=C sort -u > ./current_users.txt

#while IFS= read -r line || [[ -n "$line" ]]; do
#	echo "$line"
#done < "$all_valid"

#comm number attribute means what columns to hide
#columsn are: only in 1, only in 2, in both
echo ""
echo "=== on system but NOT authorizedd ==="
LC_ALL=C comm -13 "$all_valid" ./current_users.txt

echo ""
echo "=== Authorized but NOT on system ==="
LC_ALL=C comm -23 "$all_valid" ./current_users.txt

echo ""
echo "=== Fake roots ==="
getent passwd | awk -F: '$3 == 0 && $1 != "root" {print NR": "$0}'

echo ""
echo "=== Shell doesnt exist or is not executable ==="
while IFS=: read -r name _ _ _ _ _ shell; do
	[[ -z "$shell" ]] && continue #-z test if empty (emtpy means /bin/sh)
	[[ -x "$shell" ]] || echo "MISSING: $name -> '$shell'" #-x allows symlinks
done < <(getent passwd)

echo ""
echo "=== Shell NOT listed in /etc/shells ==="
while IFS=: read -r name _ _ _ _ _ shell; do
	[[ -z "$shell" ]] && continue
	case "$shell" in */nologin|*/false) continue ;; esac #not listed in /etc/shells
	grep -qxF -- "$shell" /etc/shells || echo "NOT IN /etc/shells: $name -> '$shell'"
done < <(getent passwd)

echo ""
echo "=== Shell binary not owned by any package (possible fake) ==="
while IFS=: read -r name _ _ _ _ _ shell; do
	[[ -z "$shell" || ! -x "$shell" ]] && continue #missing already reported above
	real=$(readlink -f "$shell") #readlink resolves path to absolute path
	dpkg -S "$shell" >/dev/null 2>&1 || dpkg -S "$real" >/dev/null 2>&1 \
		|| echo "UNOWNED: $name -> '$shell'"
done < <(getent passwd)

echo ""
echo "=== /etc/passwd lines with trailing whitespace ==="
grep -nP '\s$' /etc/passwd || echo "none found"
