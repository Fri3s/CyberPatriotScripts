#!/bin/bash
chown root:root /etc/vsftpd.conf
chmod 600 /etc/vsftpd.conf
chown root:root /etc/ftpusers /etc/vsftpd.ftpusers /etc/vsftpd.userlist
chmod 644 /etc/ftpusers /etc/vsftpd.ftpusers /etc/vsftpd.userlist
