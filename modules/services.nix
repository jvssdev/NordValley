{
  pkgs,
  userName,
  homeDir,
  ...
}:

{
  virtualisation = {
    docker = {
      enable = true;
    };

    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
      };
    };

    spiceUSBRedirection.enable = true;

    waydroid.enable = true;
  };

  environment.systemPackages = with pkgs; [
    libvirt
    qemu
    virt-viewer
    virt-manager
    spice
    spice-gtk
    spice-protocol
    OVMF

    # Waydroid dependencies
    waydroid
    lxc
  ];

  services.envfs.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Syncthing - obrigatório
  services.syncthing = {
    enable = true;
    user = userName;
    dataDir = "/home/${userName}";
    configDir = "/home/${userName}/.config/syncthing";
  };
}
