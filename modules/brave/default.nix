{
  pkgs,
  nix-colors,
  ...
}: let
  preferences = import ./preferences.nix {inherit nix-colors;};
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
    initialPrefs =
      preferences.initialPreferences
      // {
        BrowserSignin = 0;
        SyncDisabled = true;
        PasswordManagerEnabled = false;
        SpellcheckEnabled = true;
        SpellcheckLanguage = ["en-US" "pt-BR"];
      };
  };
}
