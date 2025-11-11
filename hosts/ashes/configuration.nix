{
  pkgs,
  lib,
  userName,
  fullName,
  helix,
  zen-browser,
  ...
}:
{
  environment.variables.EDITOR = "hx";
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://helix.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "helix.cachix.org-1:ejp9KQpR1FBI2nYpDUq3mXRLc41P4Y1kFnkmNjvC7cc="
      ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
  programs.zsh.enable = true;
  programs.starship.enable = true;
  users.users.${userName} = {
    isNormalUser = true;
    description = fullName;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "libvirtd"
      "kvm"
    ];
    shell = pkgs.zsh;
  };
  environment.etc."direnv/direnv.toml".text = ''
    [global]
    hide_env_diff = true
    warn_timeout = 0
    log_filter="^$"
  '';
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
      gfxmodeEfi = "800x600";
      fontSize = 30;
    };
  };
  powerManagement = {
    powertop.enable = true;
    cpuFreqGovernor = lib.mkDefault "powersave";
  };
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      font-awesome
      roboto
    ];
  };
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  system.stateVersion = "25.05";
}
