ADMIN_USER="youradminname"

users=$(awk -F: '$3 >= 1000 && $3 < 60000 && $1 != "nobody" && $7 !~ /(nologin|false)$/ {print $1}' /etc/passwd)

for user in $users; do
    if [ "$user" = "$ADMIN_USER" ]; then
        echo "Skipping $user"
        continue
    fi
    echo "Updating $user"
    chage -M 90 -m 3 -W 7 -I -1 "$user"
    chage -d 0 "$user"
done