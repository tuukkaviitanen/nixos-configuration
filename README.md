# Setup

1. Add `git` as system package and enable nix flakes to /etc/nixos/configuration.nix
2. Rebuild with `sudo nixos-rebuild switch`
3. Create ssh key and add it to GitHub (as the repository is private)
4. Download this configuration locally with `git clone <repository-address> ~/System`
5. Rebuild with the chosen configuration with `sudo nixos-rebuild switch --flake ~/System#configuration-name`
6. Reboot for all configurations to take place
7. Ready
