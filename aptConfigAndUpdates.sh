#!/bin/bash

set -o pipefail

SOURCES_LIST=/etc/apt/sources.list

cat >> "$SOURCES_LIST" << 'EOF'

deb https://deb.debian.org/debian bookworm main
deb https://deb.debian.org/debian bookworm-updates main
deb https://security.debian.org/debian-security bookworm-security main
EOF


