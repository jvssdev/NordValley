{
  description = "NixOS configuration with River window manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:helix-editor/helix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:MarceColl/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium-browser = {
      url = "github:ominit/helium-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nur,
      mango,
      ...
    }:
    let
      userInfo = {
        userName = "joaov";
        fullName = "João Víctor Santos Silva";
        userEmail = "joao.victor.ss.dev@gmail.com";
      };
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        overlays = [ nur.overlays.default ];
      };
      system = pkgs.stdenv.hostPlatform.system;
      defaults = {
        withGUI = true;
        homeDir = "/home/${userInfo.userName}";
      };
    in
    {
      # RiverWM configuration
      nixosConfigurations.river = nixpkgs.lib.nixosSystem {
        inherit system;
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
          { nixpkgs.config.allowUnfree = true; }
          ./hosts/ashes/configuration.nix
          ./hosts/ashes/hardware-configuration.nix
          ./modules/path.nix
          ./modules/services.nix
          ./modules/elevated-packages.nix
          ./modules/intel-drivers.nix
          ./modules/power-management.nix
          ./modules/river.nix
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
                  ;
                inherit (userInfo) userName userEmail fullName;
                inherit (defaults) withGUI homeDir;
                isRiver = true;
                isMango = false;
              };
            };
          }
        ];
      };

      # MangoWC
      nixosConfigurations.mangowc = nixpkgs.lib.nixosSystem {
        inherit system;
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
          { nixpkgs.config.allowUnfree = true; }
          ./hosts/ashes/configuration.nix
          ./hosts/ashes/hardware-configuration.nix
          ./modules/path.nix
          ./modules/services.nix
          ./modules/elevated-packages.nix
          ./modules/power-management.nix
          ./modules/intel-drivers.nix
          ./modules/mango.nix
          mango.nixosModules.mango
          { programs.mango.enable = true; }
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
                  ;
                inherit (userInfo) userName userEmail fullName;
                inherit (defaults) withGUI homeDir;
                isRiver = false;
                isMango = true;
              };
            };
          }
        ];
      };

      homeConfigurations.universal = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        extraSpecialArgs = {
          withGUI = defaults.withGUI;
          homeDir = defaults.homeDir;
          helix = inputs.helix;
          quickshell = inputs.quickshell;
          zen-browser = inputs.zen-browser;
          helium-browser = inputs.helium-browser;
          isRiver = true;
          isMango = false;
        }
        // userInfo;
        modules = [ ./modules/home.nix ];
      };

      nixosConfigurations.iso = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./hosts/iso/configuration.nix ];
      };
    };
}
