{
  description = "NordValley NixOS with River and MangoWC window manager";
  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    helix = {
      url = "github:helix-editor/helix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zsh-hlx = {
      url = "github:multirious/zsh-helix-mode/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helium-browser = {
      url = "github:ominit/helium-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };
  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nur,
      mango,
      nixpkgs-unstable,
      nix-colors,
      zsh-hlx,
      ...
    }:
    let
      userInfo = {
        userName = "joaov";
        fullName = "João Víctor Santos Silva";
        userEmail = "joao.victor.ss.dev@gmail.com";
      };
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          nur.overlays.default
          (final: prev: {
            quickshell = inputs.quickshell.packages.${system}.default;
            mango = inputs.mango.packages.${system}.default;
          })
        ];
      };
      defaults = {
        withGUI = true;
        homeDir = "/home/${userInfo.userName}";
      };
    in
    {
      # RiverWM configuration
      nixosConfigurations.river = nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        specialArgs =
          inputs
          // userInfo
          // {
            withGUI = defaults.withGUI;
            homeDir = defaults.homeDir;
            isRiver = true;
            isMango = false;
          };
        modules = [
          ./hosts/ashes/configuration.nix
          ./hosts/ashes/hardware-configuration.nix
          ./modules/path.nix
          ./modules/services.nix
          ./modules/elevated-packages.nix
          ./modules/intel-drivers.nix
          ./modules/power-management.nix
          ./modules/thunar.nix
          # RiverWM SDDM Desktop Entry
          {
            services.displayManager.sessionPackages = [
              (pkgs.writeTextFile {
                name = "river-session";
                destination = "/share/wayland-sessions/river.desktop";
                text = ''
                  [Desktop Entry]
                  Name=River
                  Comment=A dynamic tiling Wayland compositor
                  Exec=river
                  Type=Application
                '';
              })
            ];
          }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${userInfo.userName} = import ./modules/home.nix;
              extraSpecialArgs = {
                inherit (inputs)
                  helix
                  zen-browser
                  helium-browser
                  quickshell
                  nix-colors
                  zsh-hlx
                  ;
                inherit (userInfo) userName userEmail fullName;
                inherit (defaults) withGUI homeDir;
                isRiver = true;
                isMango = false;
              };
              sharedModules = [
                inputs.zen-browser.homeModules.default
                nix-colors.homeManagerModules.default
              ];
            };
          }
        ];
      };
      # MangoWC
      nixosConfigurations.mangowc = nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        specialArgs =
          inputs
          // userInfo
          // {
            withGUI = defaults.withGUI;
            homeDir = defaults.homeDir;
            isRiver = false;
            isMango = true;
          };
        modules = [
          ./hosts/ashes/configuration.nix
          ./hosts/ashes/hardware-configuration.nix
          ./modules/path.nix
          ./modules/services.nix
          ./modules/elevated-packages.nix
          ./modules/power-management.nix
          ./modules/intel-drivers.nix
          ./modules/thunar.nix
          mango.nixosModules.mango
          {
            programs.mango.enable = true;
          }
          # MangoWC SDDM Desktop Entry
          {
            services.displayManager.sessionPackages = [
              (pkgs.writeTextFile {
                name = "mango-session";
                destination = "/share/wayland-sessions/mango.desktop";
                text = ''
                  [Desktop Entry]
                  Name=MangoWC
                  Comment=A Wayland compositor based on wlroots
                  Exec=dbus-run-session mango
                  Type=Application
                '';
              })
            ];
          }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${userInfo.userName} = import ./modules/home.nix;
              extraSpecialArgs = {
                inherit (inputs)
                  helix
                  zen-browser
                  helium-browser
                  mango
                  quickshell
                  nix-colors
                  zsh-hlx
                  ;
                inherit (userInfo) userName userEmail fullName;
                inherit (defaults) withGUI homeDir;
                isRiver = false;
                isMango = true;
              };
              sharedModules = [
                inputs.zen-browser.homeModules.default
                nix-colors.homeManagerModules.default
              ];
            };
          }
        ];
      };
      homeConfigurations.universal = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          withGUI = defaults.withGUI;
          homeDir = defaults.homeDir;
          helix = inputs.helix;
          quickshell = inputs.quickshell;
          zen-browser = inputs.zen-browser;
          helium-browser = inputs.helium-browser;
          nix-colors = inputs.nix-colors;
          zsh-hlx = inputs.zsh-hlx;
          isRiver = true;
          isMango = false;
        }
        // userInfo;
        modules = [
          ./modules/home.nix
          nix-colors.homeManagerModules.default
        ];
      };
      nixosConfigurations.iso = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./hosts/iso/configuration.nix ];
      };
    };
}
