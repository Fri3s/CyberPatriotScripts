#!/bin/bash
chown -R root /usr/lib/firefox /etc/firefox
chmod -R go-w /usr/lib/firefox /etc/firefox
chmod 644 /etc/firefox/policies/policies.json
for h in /home/*; do
  u=$(stat -c %U "$h"); g=$(stat -c %G "$h")
  chown -R "$u:$g" "$h/.mozilla" 2>/dev/null
  chmod 700 "$h/.mozilla" 2>/dev/null
done
