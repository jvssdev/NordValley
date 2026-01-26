{
  description = "NordValley NixOS with River, MangoWC and Niri";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wezterm = {
      url = "github:wezterm/wezterm?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    niri-flake = {
      url = "github:sodiboo/niri-flake";
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
    inputs@{
      nixpkgs,
      home-manager,
      nur,
      mango,
      # nixpkgs-unstable,
      niri-flake,
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
          inputs.niri-flake.overlays.niri
          (final: prev: {
            quickshell = inputs.quickshell.packages.${system}.default;
            mango = inputs.mango.packages.${system}.default;
          })
        ];
      };

      defaults = {
        homeDir = "/home/${userInfo.userName}";
      };

      commonModules = [
        {
          nixpkgs = {
            hostPlatform = system;
            inherit pkgs;
          };
        }
        ./hosts/ashes/configuration.nix
        ./hosts/ashes/hardware-configuration.nix
        ./modules/theme.nix
        ./modules/cache.nix
        ./modules/path.nix
        ./modules/services.nix
        ./modules/elevated-packages.nix
        ./modules/intel-drivers.nix
        ./modules/power-management.nix
        # ./modules/thunar.nix
        ./modules/sddm-theme.nix
        ./modules/environment.nix
        ./modules/brave/default.nix
      ];

      mkSystem =
        isRiver: isMango: isNiri: extraModules: extraSharedModules:
        nixpkgs.lib.nixosSystem {
          specialArgs =
            inputs
            // userInfo
            // {
              inherit (defaults) homeDir;
              inherit (inputs) silentSDDM;
              inherit isRiver isMango isNiri;
            };

          modules =
            commonModules
            ++ extraModules
            ++ [
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  backupFileExtension = "hm-backup";
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.${userInfo.userName} = import ./modules/home.nix;
                  extraSpecialArgs = {
                    inherit (inputs)
                      zen-browser
                      quickshell
                      mango
                      niri-flake
                      nvf
                      wezterm
                      ;
                    inherit (userInfo) userName userEmail fullName;
                    inherit (defaults) homeDir;
                    inherit isRiver isMango isNiri;
                  };
                  sharedModules = [
                    inputs.zen-browser.homeModules.default
                    inputs.nvf.homeManagerModules.default
                  ]
                  ++ extraSharedModules;
                };
              }
            ];
        };
    in
    {
      nixosConfigurations = {
        river =
          mkSystem true false false
            [
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
                    passthru.providedSessions = [ "river" ];
                  })
                ];
              }
            ]
            [ ];

        mangowc =
          mkSystem false true false
            [
              mango.nixosModules.mango
              {
                programs.mango.enable = true;
              }
            ]
            [
              mango.hmModules.mango
            ];

        niri =
          mkSystem false false true
            [
              niri-flake.nixosModules.niri
              {
                programs.niri.enable = true;
                programs.niri.package = pkgs.niri-unstable;
              }
            ]
            [ ];
      };

      homeConfigurations.universal = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit (defaults) homeDir;
          inherit (inputs) quickshell;
          inherit (inputs) zen-browser;
          inherit (inputs) nvf;
          inherit (inputs) wezterm;
          isRiver = true;
          isMango = false;
          isNiri = false;
        }
        // userInfo;

        modules = [
          ./modules/home.nix
        ];
      };
    };
}
