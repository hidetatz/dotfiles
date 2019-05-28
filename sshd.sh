#!/bin/bash

set -e

echo ""
echo "============================================"
echo "Starting sshd on background"
echo "detach from container by Ctrl-p + Ctrl-q and do 'make ssh'"
echo "============================================"
echo ""

sudo /usr/sbin/sshd -D
