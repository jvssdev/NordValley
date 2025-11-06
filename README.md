<p align="center"><img src="https://i.imgur.com/X5zKxvp.png" width=150px></p>

# NordValley NixOS Installation Guide

Complete guide for installing and configuring NixOS with River or MangoWC window managers.

## Prerequisites

- NixOS ISO (minimal or graphical)
- Internet connection
- Bootable USB drive with NixOS
- Basic Linux terminal knowledge

## Quick Installation

### Option 1: Automatic Installation (Recommended)

1. **Boot from NixOS USB**

2. **Configure network** (if needed):
```bash
# For WiFi
sudo systemctl start wpa_supplicant
wpa_cli

# For Ethernet (usually automatic)
```

3. **Clone the repository**:
```bash
# Temporarily in live environment
git clone https://github.com/joaovictor-ss/NordValley.git
cd NordValley
```

4. **Run the installer**:
```bash
chmod +x install.sh
./install.sh
```

The script will:
- Automatically detect if running in live or installed environment
- Guide you through disk partitioning
- Request user information
- Install the complete system
- Configure everything automatically

### Option 2: Manual Installation

If you prefer step-by-step:

#### 1. Partition the disk

```bash
# Identify your disk
lsblk

# Partition (example for /dev/sda)
sudo parted /dev/sda -- mklabel gpt
sudo parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
sudo parted /dev/sda -- set 1 esp on
sudo parted /dev/sda -- mkpart primary 512MiB 100%
```

#### 2. Format partitions

```bash
# Boot (EFI)
sudo mkfs.fat -F 32 -n BOOT /dev/sda1

# Root
sudo mkfs.ext4 -L nixos /dev/sda2
```

#### 3. Mount partitions

```bash
sudo mount /dev/sda2 /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/sda1 /mnt/boot
```

#### 4. Generate hardware configuration

```bash
sudo nixos-generate-config --root /mnt
```

#### 5. Clone repository to target system

```bash
sudo mkdir -p /mnt/home/yourusername
cd /mnt/home/yourusername
sudo git clone https://github.com/joaovictor-ss/NordValley.git
```

#### 6. Update flake with your information

Edit `/mnt/home/yourusername/NordValley/flake.nix`:

```nix
userInfo = {
  userName = "yourusername";
  fullName = "Your Full Name";
  userEmail = "your@email.com";
};
```

#### 7. Copy hardware configuration

```bash
sudo cp /mnt/etc/nixos/hardware-configuration.nix \
   /mnt/home/yourusername/NordValley/hosts/ashes/
```

#### 8. Install NixOS

For River:
```bash
sudo nixos-install --flake /mnt/home/yourusername/NordValley#river
```

For MangoWC:
```bash
sudo nixos-install --flake /mnt/home/yourusername/NordValley#mangowc
```

#### 9. Set user password

```bash
sudo nixos-enter --root /mnt
passwd yourusername
exit
```

#### 10. Unmount and reboot

```bash
sudo umount -R /mnt
sudo reboot
```

## Post-installation

After rebooting into the installed system:

### 1. Configure the system

```bash
cd ~/NordValley
./install.sh
```

Or manually:

```bash
# For River
sudo nixos-rebuild switch --flake .#river

# For MangoWC
sudo nixos-rebuild switch --flake .#mangowc
```

### 2. Verify everything is working

```bash
# Test the editor
hx

# Test the terminal
ghostty

# Check services
systemctl status
```

## Directory Structure

After installation:

```
~/NordValley/               # Main configuration
  ├── dotfiles/            # Configuration files
  ├── hosts/               # Per-host configurations
  ├── modules/             # NixOS modules
  └── flake.nix           # Entry point

~/.config/                  # Symlinks to dotfiles
  ├── helix/
  ├── ghostty/
  ├── waybar/
  └── ...
```

## Customization

### Change Window Manager

```bash
# Rebuild with another WM
sudo nixos-rebuild switch --flake ~/NordValley#mangowc
```

### Update the system

```bash
cd ~/NordValley
nix flake update
sudo nixos-rebuild switch --flake .#river
```

### Add packages

Edit `~/NordValley/modules/packages.nix`:

```nix
basePackages = [
  # Your packages here
  neovim
  git
  # ...
];
```

Then:

```bash
sudo nixos-rebuild switch --flake ~/NordValley#river
```

## Main Keybindings

### River

- `Super + Return`: Open terminal
- `Super + D`: Launcher (Fuzzel)
- `Super + Q`: Close window
- `Super + Shift + E`: Exit

### Ghostty (Terminal)

- `Ctrl + Shift + T`: New tab
- `Ctrl + Shift + W`: Close tab
- `Ctrl + Shift + C/V`: Copy/Paste

## Troubleshooting

### Problem: Boot not working

```bash
# Reinstall bootloader
sudo nixos-rebuild switch --install-bootloader
```

### Problem: Graphics drivers

For Intel:
```bash
# Edit hosts/ashes/configuration.nix
# Add:
drivers.intel.enable = true;

# Rebuild
sudo nixos-rebuild switch --flake ~/NordValley#river
```

### Problem: Configuration not applying

```bash
# Clean and rebuild
sudo nix-collect-garbage -d
sudo nixos-rebuild switch --flake ~/NordValley#river
```

### Problem: Home Manager conflicts

```bash
# Remove conflicts
rm -rf ~/.config/gtk-*
rm -rf ~/.gtkrc-*
rm -rf ~/.zen/profiles.ini
# Rebuild
sudo nixos-rebuild switch --flake ~/NordValley#river
```

## Additional Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [River Documentation](https://github.com/riverwm/river/wiki)
- [Helix Documentation](https://docs.helix-editor.com/)

## Contributing

Feel free to open issues or pull requests!

## License

This project is under the MIT license.

---

**Note**: Always backup your data before any installation!

#### Cleanup storage

Delete stale paths: `nix-collect-garbage`

Delete stale paths and generations older than x days: `nix-collect-garbage --delete-older-than 30d`

