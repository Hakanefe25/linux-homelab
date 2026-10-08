# Security notes

This repository is for learning and local experimentation.

It is not intended to be copied directly into a production environment.

## UFW

The provisioning script configures:

- default deny for incoming traffic
- default allow for outgoing traffic
- SSH allowed
- TCP/80 allowed

Vagrant exposes the web service only to the host through a `127.0.0.1` forwarded port.

## Fail2ban

The SSH jail uses:

- 5 retries
- 10 minute observation window
- 15 minute ban

These values are intentionally simple for a lab.

## Secrets

No secrets are stored in the repository.

If future services need credentials, use environment files that are ignored by Git or a proper secrets manager.

## Docker

The Vagrant user is added to the Docker group for convenience.

Membership in the Docker group effectively provides root-equivalent control over the host VM. That tradeoff is acceptable in this disposable lab, but it should be treated carefully on real systems.
