{
  pkgs,
  userName,
  ...
}:
{
  virtualisation = {
    docker = {
      enable = true;
    };
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        runAsRoot = false;
        verbatimConfig = ''
          user = "${userName}"
          group = "libvirtd"
        '';
      };
    };
    spiceUSBRedirection.enable = true;
    waydroid = {
      enable = true;
      package = pkgs.waydroid-nftables;
    };
  };

  systemd.services.libvirt-guests.enable = false;

  environment.systemPackages = with pkgs; [
    libvirt
    qemu_kvm
    virt-viewer
    virt-manager
    spice
    spice-gtk
    spice-protocol
    virglrenderer
    mesa
    waydroid
    lxc
  ];

  hardware.bluetooth.enable = true;
  services = {

    envfs.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    blueman.enable = true;

    syncthing = {
      enable = true;
      user = userName;
      dataDir = "/home/${userName}";
      configDir = "/home/${userName}/.config/syncthing";
    };
  };
}
