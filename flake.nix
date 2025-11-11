{
  description = "NordValley NixOS with River and MangoWC window manager";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = "github:helix-editor/helix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
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
    zed = {
      url = "github:zed-industries/zed";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nur,
      mango,
      fenix,
      ...
    }:
    let
      userInfo = {
        userName = "joaov";
        fullName = "João Víctor Santos Silva";
        userEmail = "joao.victor.ss.dev@gmail.com";
      };
      system = "x86_64-linux";

      # Hybrid overlay: Fenix stable Rust + unstable nixpkgs
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          nur.overlays.default

          (
            final: prev:
            let

              stableToolchain = fenix.packages.${system}.stable.toolchain;
            in
            {

              rustc = stableToolchain;
              cargo = stableToolchain;

              rustPlatform = prev.rustPlatform.override {
                rustc = stableToolchain;
                cargo = stableToolchain;
              };

              # zed-editor = prev.zed-editor.override {
              #   rustPlatform = final.rustPlatform;
              # };
            }
          )
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
          {
            nixpkgs.config.allowUnfree = true;
          }
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
                  zed
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
          {
            nixpkgs.config.allowUnfree = true;
          }
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
                  zed
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
        inherit pkgs;
        extraSpecialArgs = {
          withGUI = defaults.withGUI;
          homeDir = defaults.homeDir;
          helix = inputs.helix;
          quickshell = inputs.quickshell;
          zen-browser = inputs.zen-browser;
          helium-browser = inputs.helium-browser;
          zed = inputs.zed;
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
