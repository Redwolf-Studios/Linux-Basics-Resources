#!/usr/bin/env bash
# if fails stop 
set -e

# Make sure this machine supports APT
if ! command -v apt >/dev/null 2>&1; then
	echo "ERROR: This machine does not appear to use APT."
  exit 1
fi

# Update the System 
echo "========================="
echo "======System Update======"
echo "========================="
sudo apt update 
sudo apt upgrade -y

# After Update 
echo "========================="
echo "=====Update Complete====="
echo "========================="
