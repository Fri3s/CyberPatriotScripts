#!/bin/bash

if systemctl list-unit-files | grep -q '^ssh\.service'; then
  SSH_SERVICE=ssh
elif systemctl list-unit-files | grep -q '^sshd\.service'; then
  SSH_SERVICE=sshd
else
  echo "didnt fid ssh or sshd service" >&2
  exit 1
fi

set -euo pipefail

CONFIG=/etc/ssh/sshd_config
BACKUP=/etc/ssh/sshd_config.bak

if [[ $EUID -ne 0 ]]; then
  echo "run this as root" >&2
  exit 1
fi

cp "$CONFIG" "$BACKUP"
echo "backup saved to $BACKUP"

cat >> "$CONFIG" << 'EOF'

Port 22
AddressFamily inet
ListenAddress 0.0.0.0
RekeyLimit default none
SyslogFacility AUTH
LogLevel VERBOSE
LoginGraceTime 30s
PermitRootLogin no
StrictModes yes
MaxAuthTries 3
MaxSessions 2
PubkeyAuthentication no
AuthorizedPrincipalsFile none
AuthorizedKeysCommand none
AuthorizedKeysCommandUser nobody
HostbasedAuthentication no
IgnoreUserKnownHosts yes
IgnoreRhosts yes
PasswordAuthentication yes
PermitEmptyPasswords no
KbdInteractiveAuthentication no
KerberosAuthentication no
KerberosOrLocalPasswd no
KerberosTicketCleanup yes
GSSAPIAuthentication no
GSSAPICleanupCredentials yes
GSSAPIStrictAcceptorCheck yes
GSSAPIKeyExchange no
UsePAM yes
AllowAgentForwarding no
AllowTcpForwarding no
GatewayPorts no
X11Forwarding no
X11DisplayOffset 10
X11UseLocalhost yes
PermitTTY yes
PrintMotd no
PrintLastLog yes
TCPKeepAlive no
PermitUserEnvironment no
Compression no
ClientAliveInterval 300
ClientAliveCountMax 2
UseDNS no
PidFile /run/sshd.pid
MaxStartups 10:30:100
PermitTunnel no
ChrootDirectory none
VersionAddendum none
Banner /etc/issue.net
AcceptEnv LANG LC_*
PubkeyAcceptedAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-512 
DisableForwarding yes
AllowStreamLocalForwarding no
EOF

if sshd -t; then
  echo "config ok"
  systemctl restart ssh
eles
  echo "config bad, restoring backup" >&2
  cp "$BACKUP" "$CONFIG"
fi

systemctl enable --now "$SSH_SERVICE"
systemctl reload "$SSH_SERVICE"
ufw enable
ufw allow ssh
echo "command to connect: \n"
echo "ssh ${SUDO_USER:-$(whoami)}@$(hostname -I | awk '{print $1}')"
echo "set network in vmware settings to bridged"
