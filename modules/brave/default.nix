{
  pkgs,
  nix-colors,
  ...
}: let
  palette = nix-colors.colorSchemes.nord.palette;
  preferences = import ./preferences.nix {inherit pkgs nix-colors;};
in {
  environment.systemPackages = [
    pkgs.brave
  ];
  imports = [
    ./policies.nix
  ];
  programs.chromium = {
    enable = true;
    extensions = [
      "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"
      "hfjbmagddngcpeloejdejnfgbamkjaeg"
      "dhdgffkkebhmkfjojejmpbldmpobfkfo"
      "ammjkodgmmoknidbanneddgankgfejfh"
      "eimadpbcbfnmbkopoojfekhnkhdbieeh"
      "mnjggcdmjocbbbhaepdhchncahnbgone"
    ];
    extraOpts = {
      "AdvancedProtectionAllowed" = true;
      "BlockThirdPartyCookies" = true;
      "BrowserSignin" = 0;
      "BrowserThemeColor" = "#${palette.base01}";
      "DnsOverHttpsMode" = "automatic";
      "HttpsOnlyMode" = "allowed";
      "SyncDisabled" = true;
      "PasswordManagerEnabled" = false;
      "SpellcheckEnabled" = true;
      "SpellcheckLanguage" = [
        "en-US"
        "pt-BR"
      ];
      "MasterPreferences" = preferences.preferencesFile;
    };
  };
}
