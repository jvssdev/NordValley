{
  description = "NordValley NixOS with River, MangoWC and Niri";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
      nixpkgs-unstable,
      nix-colors,
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
        localSystem = system;
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
        homeDir = "/home/${userInfo.userName}";
      };

      nixpkgsModule = {
        nixpkgs = {
          hostPlatform = system;
          inherit pkgs;
        };
      };

      commonModules = [
        nixpkgsModule
        ./hosts/ashes/configuration.nix
        ./hosts/ashes/hardware-configuration.nix
        ./modules/path.nix
        ./modules/services.nix
        ./modules/elevated-packages.nix
        ./modules/intel-drivers.nix
        ./modules/power-management.nix
        ./modules/thunar.nix
        ./modules/sddm-theme.nix
      ];

      mkSystem =
        isRiver: isMango: isNiri: extraModules: extraSharedModules:
        nixpkgs.lib.nixosSystem {

          specialArgs =
            inputs
            // userInfo
            // {
              homeDir = defaults.homeDir;
              inherit nix-colors;
              silentSDDM = inputs.silentSDDM;
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
                      helix
                      zen-browser
                      helium-browser
                      quickshell
                      nix-colors
                      zsh-hlx
                      mango
                      niri-flake
                      ;
                    inherit (userInfo) userName userEmail fullName;
                    inherit (defaults) homeDir;
                    inherit isRiver isMango isNiri;
                  };

                  sharedModules = [
                    inputs.zen-browser.homeModules.default
                    nix-colors.homeManagerModules.default
                  ]
                  ++ extraSharedModules;
                };
              }
            ];
        };

    in
    {
      # ========================= RIVER =========================
      nixosConfigurations.river =
        mkSystem true false false
          [
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
          ]
          [ ];

      # ========================= MANGOWC =========================
      nixosConfigurations.mangowc =
        mkSystem false true false
          [
            mango.nixosModules.mango
            { programs.mango.enable = true; }
          ]
          [ mango.hmModules.mango ];

      # ========================= NIRI =========================
      nixosConfigurations.niri =
        mkSystem false false true
          [
            niri-flake.nixosModules.niri
            { programs.niri.enable = true; }
          ]
          [
            niri-flake.homeModules.niri
          ];

      # ========================= UNIVERSAL HM =========================
      homeConfigurations.universal = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          homeDir = defaults.homeDir;
          helix = inputs.helix;
          quickshell = inputs.quickshell;
          zen-browser = inputs.zen-browser;
          helium-browser = inputs.helium-browser;
          nix-colors = inputs.nix-colors;
          zsh-hlx = inputs.zsh-hlx;
          isRiver = true;
          isMango = false;
          isNiri = false;
        }
        // userInfo;

        modules = [
          ./modules/home.nix
          nix-colors.homeManagerModules.default
        ];
      };

      # ========================= ISO =========================
      nixosConfigurations.iso = nixpkgs.lib.nixosSystem {
        modules = [
          {
            nixpkgs = {
              hostPlatform = "x86_64-linux";
              pkgs = nixpkgs.legacyPackages.x86_64-linux;
            };
          }
          ./hosts/iso/configuration.nix
        ];
      };
    };
}
