#!/usr/bin/env bash
set -euo pipefail

printf 'Linux Homelab Health Check\n'
printf '%s\n' '--------------------------'

if systemctl is-active --quiet docker; then
  echo '[OK] Docker service is active'
else
  echo '[FAIL] Docker service is not active'
  exit 1
fi

if systemctl is-active --quiet fail2ban; then
  echo '[OK] Fail2ban is active'
else
  echo '[WARN] Fail2ban is not active'
fi

if docker ps --format '{{.Names}}' | grep -qx 'homelab-nginx'; then
  echo '[OK] Nginx container is running'
else
  echo '[FAIL] Nginx container is not running'
  exit 1
fi

if curl -fsS http://127.0.0.1/ >/dev/null; then
  echo '[OK] HTTP service responded successfully'
else
  echo '[FAIL] HTTP service did not respond'
  exit 1
fi

echo
echo 'UFW status:'
ufw status | sed 's/^/  /'

echo
echo 'Docker containers:'
docker ps --format '  {{.Names}} | {{.Status}} | {{.Ports}}'
