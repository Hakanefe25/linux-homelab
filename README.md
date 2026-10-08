# Linux Homelab

A reproducible Ubuntu homelab built with **Vagrant, Docker, Nginx, UFW and Fail2ban**.

The goal of this project is to practice Linux administration, service deployment, networking and basic security in a disposable virtual machine.

## Stack

- Ubuntu 24.04 LTS
- Vagrant
- VirtualBox
- Bash
- Docker Engine
- Docker Compose
- Nginx
- UFW
- Fail2ban
- GitHub Actions

## What it does

Running `vagrant up` creates a Linux VM and automatically:

- updates the system
- installs useful admin packages
- configures UFW
- installs and configures Fail2ban
- installs Docker
- enables Docker at boot
- starts an Nginx container
- exposes the lab service to the host
- installs a simple health-check script

## Architecture

```text
Host machine
    |
    |  http://localhost:8080
    v
+-----------------------------+
| Ubuntu 24.04 VM             |
|                             |
|  UFW                        |
|   |                         |
|   v                         |
|  Docker                     |
|   |                         |
|   v                         |
|  Nginx container :80        |
|                             |
|  Fail2ban + SSH             |
+-----------------------------+
```

More detail: [`docs/architecture.md`](docs/architecture.md)

## Requirements

Install:

- VirtualBox
- Vagrant

Then clone the repository:

```bash
git clone https://github.com/Hakanefe25/linux-homelab.git
cd linux-homelab
```

Start the lab:

```bash
vagrant up
```

SSH into the VM:

```bash
vagrant ssh
```

Open the service on the host:

```text
http://localhost:8080
```

Check service health inside the VM:

```bash
/usr/local/bin/homelab-health
```

Destroy the VM when finished:

```bash
vagrant destroy -f
```

## Useful commands

```bash
vagrant status
vagrant ssh
vagrant reload
vagrant halt
vagrant destroy -f
```

Inside the VM:

```bash
docker ps
docker compose -f /opt/homelab/docker-compose.yml ps
sudo ufw status verbose
sudo fail2ban-client status
sudo systemctl status docker
```

## Repository layout

```text
.
├── .github/workflows/ci.yml
├── docker/
│   ├── docker-compose.yml
│   └── nginx/
│       └── index.html
├── docs/
│   ├── architecture.md
│   └── security.md
├── provision/
│   └── bootstrap.sh
├── scripts/
│   └── health-check.sh
├── .gitignore
├── LICENSE
├── README.md
└── Vagrantfile
```

## Security notes

This is a **local learning environment**, not a production-hardening template.

The VM uses:

- UFW with deny-by-default inbound rules
- SSH allowed for Vagrant access
- Fail2ban for SSH brute-force protection
- Docker service enabled with standard defaults

See [`docs/security.md`](docs/security.md).

## What I practiced

- Linux provisioning
- Virtual machines
- Bash scripting
- Service management with systemd
- Docker and Docker Compose
- Reverse-proxy/web-service basics
- Linux firewall rules
- Basic SSH hardening concepts
- Health checks
- Infrastructure documentation

## Roadmap

- Add Prometheus + Grafana
- Add a FastAPI service
- Add PostgreSQL
- Add automated backups
- Add Ansible provisioning
- Add TLS for internal services
- Add multiple VM roles
- Add centralized logging

## License

MIT
