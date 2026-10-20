#!/bin/bash

DIRS="/home /root /srv /opt /tmp /var/tmp /var/www /mnt /media /usr/local"
UDIRS="/home /root /tmp /var/tmp /var/www /srv /mnt /media"

SKIP=( ! -path '*/.cache/*' ! -path '*/.mozilla/*' ! -path '*/.config/*'
       ! -path '*/.local/share/*' ! -path '*/snap/*' ! -path '*/node_modules/*'
       ! -path '/opt/aeacus/*' ! -path '/usr/local/share/*' ! -path '/usr/local/lib/*'
       ! -name '*.desktop' )

{
find $DIRS -xdev -type f "${SKIP[@]}" -regextype posix-extended -iregex '.*\.(mp3|mp4|m4a|m4v|wav|flac|ogg|oga|aac|wma|mid|midi|avi|mkv|mov|wmv|flv|webm|mpg|mpeg|3gp|jpg|jpeg|png|gif|bmp|tiff?|webp|svg|psd|heic)' 2>/dev/null

find $DIRS -xdev -type f "${SKIP[@]}" -regextype posix-extended -iregex '.*\.(zip|rar|7z|tar|tgz|gz|bz2|xz|zst|iso|img|vdi|vmdk|ova|deb|rpm|appimage|run|bin|exe|msi|dmg|torrent)' 2>/dev/null

find $DIRS -xdev -type f "${SKIP[@]}" -regextype posix-extended -iregex '.*(rockyou|wordlist|passwords?|passwd|creds|credentials|hashes|shadow|dump|exploit|payload|backdoor|keylog|rootkit|mimikatz|netcat).*' 2>/dev/null

find $DIRS -xdev -type f "${SKIP[@]}" -regextype posix-extended -iregex '.*(\.bak|\.old|\.orig|\.save|\.swp|\.tmp|~)$' 2>/dev/null

find $UDIRS -xdev -type f "${SKIP[@]}" -perm /111 2>/dev/null
find $UDIRS -xdev -type f "${SKIP[@]}" -regextype posix-extended -iregex '.*\.(sh|py|pl|rb|php|jar|bat|ps1|elf|so)' 2>/dev/null

find /home /root /tmp /var/tmp -xdev -type f "${SKIP[@]}" -exec file {} + 2>/dev/null | grep -E 'ELF|PE32|executable' | cut -d: -f1
} | sort -u