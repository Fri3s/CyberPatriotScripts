#!/bin/bash

UID_MIN=$(awk '/^UID_MIN/ {print $2}' /etc/login.defs)
UID_MAX=$(awk '/^UID_MAX/ {print $2}' /etc/login.defs)

#list all users:
echo -e "\n"
echo "=== Users accounts: name, uid, shell ==="
getent passwd | awk -F: -v min="${UID_MIN:-1000}" -v max="${UID_MAX:-60000}" \
  '$3 >= min && $3 <= max {print $1, $3, $7}'

### fidnd shell paths that don't exist on disk ###
echo ""
echo "=== Shell paths that do NOT exist on disk ==="
awk -F: '{print $7}' /etc/passwd | sort -u | while read -r shell; do   # get each unique shell path 
    [ ! -f "$shell" ] && echo "MISSING: $shell"                       # #flag it if it isn't there
done

### find shells not regisetered in /etc/shells ###
echo ""
echo "=== Shells NOT listed in /etc/shells ==="
awk -F: '{print $1, $7}' /etc/passwd | while read -r user shell; do   # get each user + their shell
    case "$shell" in */nologin|/bin/false) continue ;; esac           # skip nologin/false, they're never in /etc/shells
    grep -qxF "$shell" /etc/shells 2>/dev/null || echo "NOT IN /etc/shells: $user -> $shell"   # flag if not an exact match
done

### find fake shell binaries (not owned by any package) ###
echo ""
echo "=== Shell binaries not owned by any installed package (possible fake) ==="
awk -F: '{print $7}' /etc/passwd | sort -u | while read -r shell; do   # get each unique shell path
    dpkg -S "$shell" >/dev/null 2>&1 || echo "UNOWNED BINARY: $shell"  # flag if dpkg doesn't recognize it
done

### find hidden trailing-space tampering in /etc/passwd ###
echo ""
echo "=== /etc/passwd lines with trailing whitespace ==="
grep -nP ' $' /etc/passwd   # flag any line ending in a hidden space
