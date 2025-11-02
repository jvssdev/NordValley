<p align="center"><img src="https://i.imgur.com/X5zKxvp.png" width=150px></p>

### New machine setup

Build ISO: `nix build .#nixosConfigurations.iso.config.system.build.isoImage`

Installation guide: <https://nixos.org/manual/nixos/unstable/#sec-installation-manual>

### NixOS Config


1. Ensure Git & Vim are installed:

    ```bash
    nix-shell -p git vim
    ```

2. Clone repo

    ```bash
    git clone https://codeberg.org/jvssdev/NordValley.git
    ```
  
3. Rebuild host

    If you are building on a new machine, generate a new hardware-configuration.nix using:

    ```bash
    sudo nixos-generate-config
    ```

    Then replace the config in hosts/ashes with the new configuration (from the home dir run):

    ```bash
    cp /etc/nixos/hardware-configuration.nix nix-home/hosts/ashes/
    ```

    Build from flake:

    ```bash
    sudo nixos-rebuild switch --flake /home/$USER/nix-home/#ashes
    ```
  
4. On subsequent runs, just run rebuild <hostname> e.g. : `rebuild ashes`

###  Home-Manger setup

1. Setup Home-Manger and Git (if not already installed)

    ```bash
    nix-shell -p git home-manager
    ```

2. Clone repo

    ```bash
    git clone https://codeberg.org/jvssdev/NordValley.git
    ```

3. Setup Home-Manager

    ```bash
    home-manager switch --flake /home/$USER/nix-home#universal
    ```

4. On subsequent runs, just run rebuild <hostname> e.g. : `rebuild universal`

### Useful tips

#### Upgrading flake

1. nix flake update

#### Authenticating with GitHub

1. `gh auth login`
2. `gh auth setup-git`

### Failed to start Home Manager for <User>

The real error is most likely hidden in the logs (Most likely a config file that you are trying to overwrite)

journalctl -xe --unit home-manager-<user>

#### Cleanup storage

Delete stale paths: `nix-collect-garbage`

Delete stale paths and generations older than x days: `nix-collect-garbage --delete-older-than 30d`

