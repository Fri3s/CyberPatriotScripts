#!/bin/bash
chown root:root /etc/exports
chmod 644 /etc/exports
chown -R root:root /etc/exports.d
chmod 755 /etc/exports.d
chmod 644 /etc/exports.d/*.exports
