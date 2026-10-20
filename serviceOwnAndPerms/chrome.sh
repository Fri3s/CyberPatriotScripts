#!/bin/bash
chown -R root /opt/google/chrome /etc/opt/chrome
chmod -R go-w /opt/google/chrome /etc/opt/chrome
chown root:root /opt/google/chrome/chrome-sandbox
chmod 4755 /opt/google/chrome/chrome-sandbox
for h in /home/*; do
  u=$(stat -c %U "$h"); g=$(stat -c %G "$h")
  chown -R "$u:$g" "$h/.config/google-chrome" 2>/dev/null
  chmod 700 "$h/.config/google-chrome" 2>/dev/null
done
