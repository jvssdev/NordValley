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
    nur.url = "github:nix-community/NUR";
    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      userInfo = {
        userName = "joaov";
        fullName = "João Víctor Santos Silva";
        userEmail = "joao.victor.ss.dev@gmail.com";
      };

      system = "x86_64-linux";

      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          inputs.nur.overlays.default
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
      nixosConfigurations.river = inputs.nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        specialArgs =
          inputs
          // userInfo
          // defaults
          // defaults
          // {
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
          ./modules/sddm-theme.nix

          {
            services.displayManager.sessionPackages = [
              (pkgs.writeTextFile rec {
                name = "river-session";
                destination = "/share/wayland-sessions/river.desktop";
                text = ''
                  [Desktop Entry]
                  Name=River
                  Comment=A dynamic tiling Wayland compositor
                  Exec=river
                  Type=Application
                '';
                passthru.providedSessions = [ "river" ];
              })
            ];
          }

          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${userInfo.userName} = import ./modules/home.nix;
            home-manager.extraSpecialArgs =
              inputs
              // userInfo
              // defaults
              // {
                isRiver = true;
                isMango = false;
              };
            home-manager.sharedModules = [
              inputs.zen-browser.homeModules.default
              inputs.nix-colors.homeManagerModules.default
            ];
          }
        ];
      };

      nixosConfigurations.mangowc = inputs.nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        specialArgs =
          inputs
          // userInfo
          // defaults
          // {
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
          inputs.mango.nixosModules.mango
          { programs.mango.enable = true; }
          ./modules/sddm-theme.nix

          {
            services.displayManager.sessionPackages = [
              (pkgs.writeTextFile rec {
                name = "mango-session";
                destination = "/share/wayland-sessions/mango.desktop";
                text = ''
                  [Desktop Entry]
                  Name=MangoWC
                  Comment=A Wayland compositor based on wlroots
                  Exec=dbus-run-session mango
                  Type=Application
                '';
                passthru.providedSessions = [ "mango" ];
              })
            ];
          }

          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${userInfo.userName} = import ./modules/home.nix;
            home-manager.extraSpecialArgs =
              inputs
              // userInfo
              // defaults
              // {
                isRiver = false;
                isMango = true;
              };
            home-manager.sharedModules = [
              inputs.zen-browser.homeModules.default
              inputs.nix-colors.homeManagerModules.default
            ];
          }
        ];
      };

      homeConfigurations.universal = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs =
          inputs
          // userInfo
          // defaults
          // {
            isRiver = true;
            isMango = false;
          };
        modules = [
          ./modules/home.nix
          inputs.nix-colors.homeManagerModules.default
        ];
      };

      nixosConfigurations.iso = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./hosts/iso/configuration.nix ];
      };
    };
}
