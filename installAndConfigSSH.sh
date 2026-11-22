#!/bin/bash

set -o pipefail

read -p "Install ssh and set it up? (y/n): " ssh_yn
case "$ssh_yn" in
    [Yy]* )
        echo "installing ssh ..."
        apt-get install -y -q openssh-server openssh-client

	echo "setting up ssh ..."
        if systemctl cat ssh.service &>/dev/null; then SSH_SERVICE=ssh
	elif systemctl cat sshd.service &>/dev/null; then SSH_SERVICE=sshd
	else echo "didnt fid ssh or sshd service" >&2
	fi

	if [[ -n "$SSH_SERVICE" ]]; then
		SSHCONFIG=/etc/ssh/sshd_config

		[ -f "${SSHCONFIG}.bak" ] || cp "$SSHCONFIG" "${SSHCONFIG}.bak"
		echo "backup saved to ${SSHCONFIG}.bak"

		cat > "$SSHCONFIG" << 'EOF'

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
		    systemctl restart "$SSH_SERVICE"
		    systemctl enable --now "$SSH_SERVICE"
		    ufw allow ssh
		    ufw --force enable
		    echo -e "command to connect: \n"
		    echo "ssh ${SUDO_USER:-$(whoami)}@$(hostname -I | awk '{print $1}')"
		    echo "set network in vmware settings to bridged"
		else
		  echo "config bad, restoring backup" >&2
		  cp "${SSHCONFIG}.bak" "$SSHCONFIG"
		fi

		
	fi
	;;
    [Nn]* )
	echo "not installing and setting up ssh"
        ;;
    * )
	echo "enter y or n"
	;;
esac
