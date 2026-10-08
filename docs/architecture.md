# Architecture

## Overview

The project creates one Ubuntu virtual machine with Vagrant.

Vagrant is responsible for:

1. creating the VM
2. configuring host-to-guest port forwarding
3. running the bootstrap provisioning script
4. copying application files into the VM
5. starting the Docker Compose stack

## Network flow

```text
Browser on host
      |
      | localhost:8080
      v
Vagrant forwarded port
      |
      | guest port 80
      v
Ubuntu VM
      |
      v
Docker published port
      |
      v
Nginx container
```

The forwarded host port binds to `127.0.0.1`, which keeps the service local to the host by default.

## Provisioning

`provision/bootstrap.sh` installs:

- UFW
- Fail2ban
- Docker Engine
- Docker Compose plugin
- utility packages

The application stack is stored at:

```text
/opt/homelab
```

The health-check command is installed as:

```text
/usr/local/bin/homelab-health
```
