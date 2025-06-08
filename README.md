# My NixOS setup

> These are my configurations for NixOS running on my laptops

## What?

[NixOS](https://nixos.org) is a Linux distribution uses the Nix programming language to configure the whole system. Everything from the Linux kernel version to programs to desktop appearance. All in just a few Nix files.

## Setup

1. Add `git` as system package and enable nix flakes to /etc/nixos/configuration.nix
2. Rebuild with `sudo nixos-rebuild switch`
4. Download this configuration locally with `git clone git@github.com:tuukkaviitanen/nixos-configuration.git ~/System`
5. Rebuild with the chosen configuration with `sudo nixos-rebuild switch --flake ~/System#configuration-name`
6. Reboot for all configurations to take place
7. Ready
