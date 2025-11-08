{
  description = "NixOS configuration with River and MangoWC window managers";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    helix.url = "github:helix-editor/helix/master";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
    nur.url = "github:nix-community/NUR";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nur,
      ...
    }@inputs:
    let
      userInfo = {
        userName = "joaov";
        fullName = "João Víctor Santos Silva";
        userEmail = "joao.victor.ss.dev@gmail.com";
      };

      system = "x86_64-linux";

      defaults = {
        withGUI = true;
        homeDir = "/home/${userInfo.userName}";
      };

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      # RiverWM
      nixosConfigurations.river = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs =
          inputs
          // userInfo
          // {
            inherit pkgs;
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
          ./modules/river.nix
          { nixpkgs.overlays = [ nur.overlays.default ]; }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${userInfo.userName} = import ./modules/home.nix;
              extraSpecialArgs = {
                inherit (inputs) helix zen-browser;
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
            inherit pkgs;
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
          # ./modules/mangowc.nix
          { nixpkgs.overlays = [ nur.overlays.default ]; }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${userInfo.userName} = import ./modules/home.nix;
              extraSpecialArgs = {
                inherit (inputs) helix zen-browser;
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
          inherit system;
          config.allowUnfree = true;
        };
        extraSpecialArgs = {
          withGUI = defaults.withGUI;
          homeDir = defaults.homeDir;
          helix = inputs.helix;
          zen-browser = inputs.zen-browser;
          isRiver = false;
          isMango = false;
        }
        // userInfo;
        modules = [ ./modules/home.nix ];
      };

      # Build ISO image
      nixosConfigurations.iso = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./hosts/iso/configuration.nix ];
      };
    };
}
