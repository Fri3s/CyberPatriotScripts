############CHANGE THIS OTHERWISE COOKED####################
ADMIN_USER="dtargaryen"

users=$(awk -F: '$3 >= 1000 && $3 < 60000 && $1 != "nobody" && $7 !~ /(nologin|false)$/ {print $1}' /etc/passwd)

for user in $users; do
    if [ "$user" = "$ADMIN_USER" ]; then
        echo "Skipping $user"
        continue
    fi
    echo "Updating $user"
    pw="$(openssl rand -base64 24 | tr -dc 'A-Za-z0-9' | head -c 14)-Aa1"
    if ! echo "$user:$pw" | chpasswd; then
        echo "  setting passwd for $user fail"
        continue
    fi
    chage -M 90 -m 3 -W 7 -I -1 "$user"
    chage -d 0 "$user"
done