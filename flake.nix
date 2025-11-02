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

      linux_x86 = "x86_64-linux";

      defaults = {
        withGUI = true;
        homeDir = "/home/${userInfo.userName}";
      };
    in
    {
      # RiverWM
      nixosConfigurations.river = nixpkgs.lib.nixosSystem {
        system = linux_x86;
        specialArgs =
          inputs
          // userInfo
          // {
            withGUI = defaults.withGUI;
            homeDir = defaults.homeDir;
            isRiver = true;
          };
        modules = [
          ./hosts/ashes/configuration.nix
          ./hosts/ashes/hardware-configuration.nix
          ./modules/path.nix
          ./modules/services.nix
          ./modules/elevated-packages.nix
          ./modules/intel-drivers.nix
          ./modules/river.nix
          { nixpkgs.overlays = [ nur.overlays.default ]; }
          home-manager.nixosModules.home-manager
          ./modules/home-manager.nix
        ];
      };

      # MangoWC
      nixosConfigurations.mangowc = nixpkgs.lib.nixosSystem {
        system = linux_x86;
        specialArgs =
          inputs
          // userInfo
          // {
            withGUI = defaults.withGUI;
            homeDir = defaults.homeDir;
            isMango = true;
          };
        modules = [
          ./hosts/ashes/configuration.nix
          ./hosts/ashes/hardware-configuration.nix
          ./modules/path.nix
          ./modules/services.nix
          ./modules/elevated-packages.nix
          ./modules/intel-drivers.nix
          # ./modules/mangowc.nix
          { nixpkgs.overlays = [ nur.overlays.default ]; }
          home-manager.nixosModules.home-manager
          ./modules/home-manager.nix
        ];
      };

      homeConfigurations.universal = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = linux_x86;
          config = {
            allowUnfree = true;
          };
        };
        extraSpecialArgs = {
          withGUI = defaults.withGUI;
          homeDir = defaults.homeDir;
          helix = inputs.helix;
        }
        // userInfo;
        modules = [ ./modules/home.nix ];
      };

      # Build ISO image
      nixosConfigurations.iso = nixpkgs.lib.nixosSystem {
        modules = [ ./hosts/iso/configuration.nix ];
      };
    };
}
