{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.programs.brave;

  jsonFormat = pkgs.formats.json { };

  prefsFile = jsonFormat.generate "brave-preferences.json" cfg.preferences;

in
{
  options.programs.brave = {
    enable = mkEnableOption "Brave Browser with custom settings";

    package = mkOption {
      type = types.package;
      default = pkgs.brave;
      description = "Brave package to use";
    };

    preferences = mkOption {
      inherit (jsonFormat) type;
      default = { };
      description = "Brave preferences to apply";
    };

    policies = mkOption {
      type = types.attrs;
      default = { };
      description = "Brave enterprise policies";
    };

    extensions = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of extension IDs to install";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
      (pkgs.writeShellScriptBin "brave-apply-prefs" ''
        for user_home in /home/*; do
          if [ -d "$user_home" ]; then
            BRAVE_DIR="$user_home/.config/BraveSoftware/Brave-Browser"
            DEFAULT_DIR="$BRAVE_DIR/Default"
            PREFS_FILE="$DEFAULT_DIR/Preferences"
            
            if [ -d "$DEFAULT_DIR" ]; then
              if [ -f "$PREFS_FILE" ]; then
                ${pkgs.jq}/bin/jq -s '.[0] * .[1]' \
                  "$PREFS_FILE" \
                  "${prefsFile}" \
                  > "$PREFS_FILE.tmp" && \
                mv "$PREFS_FILE.tmp" "$PREFS_FILE"
                
                user=$(basename "$user_home")
                chown "$user:users" "$PREFS_FILE" 2>/dev/null || true
                echo "Applied preferences for $user"
              fi
            fi
          fi
        done
      '')
    ];

    programs.chromium = {
      enable = true;
      inherit (cfg) extensions;
      extraOpts = cfg.policies;
    };

    system.activationScripts.brave-preferences = ''
      ${pkgs.writeShellScript "apply-brave-prefs" ''
        for user_home in /home/*; do
          if [ -d "$user_home" ]; then
            username=$(basename "$user_home")
            BRAVE_DIR="$user_home/.config/BraveSoftware/Brave-Browser"
            DEFAULT_DIR="$BRAVE_DIR/Default"
            PREFS_FILE="$DEFAULT_DIR/Preferences"
            
            mkdir -p "$DEFAULT_DIR"
            
            if [ -f "$PREFS_FILE" ]; then
              ${pkgs.jq}/bin/jq -s '.[0] * .[1]' \
                "$PREFS_FILE" \
                "${prefsFile}" \
                > "$PREFS_FILE.tmp" && \
              mv "$PREFS_FILE.tmp" "$PREFS_FILE"
            else
              cp "${prefsFile}" "$PREFS_FILE"
            fi
            
            chown -R "$username:users" "$BRAVE_DIR" 2>/dev/null || true
          fi
        done
      ''}
    '';

    systemd.user.services.brave-apply-preferences = {
      description = "Apply Brave Browser preferences";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        BRAVE_DIR="$HOME/.config/BraveSoftware/Brave-Browser"
        DEFAULT_DIR="$BRAVE_DIR/Default"
        PREFS_FILE="$DEFAULT_DIR/Preferences"

        mkdir -p "$DEFAULT_DIR"

        if [ -f "$PREFS_FILE" ]; then
          ${pkgs.jq}/bin/jq -s '.[0] * .[1]' \
            "$PREFS_FILE" \
            "${prefsFile}" \
            > "$PREFS_FILE.tmp" && \
          mv "$PREFS_FILE.tmp" "$PREFS_FILE"
        else
          cp "${prefsFile}" "$PREFS_FILE"
        fi
      '';
    };
  };
}
