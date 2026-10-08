#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

log() {
  printf '\n[homelab] %s\n' "$1"
}

log "Updating package index"
apt-get update -y

log "Installing base packages"
apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  jq \
  ufw \
  fail2ban \
  unattended-upgrades

log "Configuring UFW"
ufw default deny incoming
ufw default allow outgoing
ufw allow OpenSSH
ufw allow 80/tcp
ufw --force enable

log "Configuring Fail2ban"
cat >/etc/fail2ban/jail.d/sshd.local <<'EOF'
[sshd]
enabled = true
port = ssh
backend = systemd
maxretry = 5
findtime = 10m
bantime = 15m
EOF

systemctl enable --now fail2ban

log "Installing Docker"
install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

chmod a+r /etc/apt/keyrings/docker.gpg

. /etc/os-release

cat >/etc/apt/sources.list.d/docker.list <<EOF
deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${VERSION_CODENAME} stable
EOF

apt-get update -y

apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

systemctl enable --now docker

if id vagrant >/dev/null 2>&1; then
  usermod -aG docker vagrant
fi

log "Enabling unattended security upgrades"
dpkg-reconfigure -f noninteractive unattended-upgrades || true

log "Provisioning complete"
