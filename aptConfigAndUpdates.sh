#!/bin/bash

set -o pipefail

SOURCES_LIST=/etc/apt/sources.list
APT_HARDEN_FILE=/etc/apt/apt.conf.d/99hardening.conf
AUTO_UPGRADE_FILE=/etc/apt/apt.conf.d/20auto-upgrades

[ -f "${SOURCES_LIST}.bak" ] || cp "$SOURCES_LIST" "${SOURCES_LIST}.bak"

cat > "$SOURCES_LIST" << 'EOF'

deb https://deb.debian.org/debian bookworm main
deb https://deb.debian.org/debian bookworm-updates main
deb https://security.debian.org/debian-security bookworm-security main
EOF

cat > "$APT_HARDEN_FILE" << 'EOF'
Acquire::https::Verify-Peer "true";
Acquire::https::Verify-Host "true";
APT::Get::AllowUnauthenticated "false";
Acquire::AllowInsecureRepositories "false";
Acquire::AllowDowngradeToInsecureRepositories "false";
EOF

[ -f "$AUTO_UPGRADE_FILE" ] && [ ! -f "${AUTO_UPGRADE_FILE}.bak" ] && cp "$AUTO_UPGRADE_FILE" "${AUTO_UPGRADE_FILE}.bak"

cat > "$AUTO_UPGRADE_FILE" << 'EOF'
APT::Periodic::Update-Package-Lists "1";
EOF

export DEBIAN_FRONTEND=noninteractive

read -p "Run apt update? (y/n): " yn
case "$yn" in
    [Yy]* )
        echo "running apt update ..."
        apt-get update -q
        ;;
    [Nn]* )
        echo "not running apt update"
        ;;
    * )
        echo "enter y or n"
        ;;
esac

read -p "run apt full-upgrade?" upgradeyn
case "$upgradeyn" in
    [Yy]* )
        echo "running apt-get full-upgrade"
        apt-get full-upgrade -y -q -o Dpkg::Options::="--force-confold"
        ;;
    [Nn]* )
        echo "not running full upgrade"
        ;;
    * )
        echo "enter y or n"
        ;;
esac
