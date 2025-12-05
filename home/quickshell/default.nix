{
  config,
  pkgs,
  lib,
  ...
}:

let
  p = config.colorScheme.palette;

  themeQml = pkgs.writeText "Theme.qml" (
    builtins.concatStringsSep "\n" [
      "pragma Singleton"
      "import QtQuick"
      ""
      "QtObject {"
      "    readonly property color bg         : \"#${p.base00}\""
      "    readonly property color bgAlt      : \"#${p.base01}\""
      "    readonly property color bgLighter  : \"#${p.base02}\""
      ""
      "    readonly property color fg         : \"#${p.base05}\""
      "    readonly property color fgMuted    : \"#${p.base04}\""
      "    readonly property color fgSubtle   : \"#${p.base03}\""
      ""
      "    readonly property color red        : \"#${p.base08}\""
      "    readonly property color green      : \"#${p.base0B}\""
      "    readonly property color yellow     : \"#${p.base0A}\""
      "    readonly property color blue       : \"#${p.base0D}\""
      "    readonly property color magenta    : \"#${p.base0E}\""
      "    readonly property color cyan       : \"#${p.base0C}\""
      "    readonly property color orange     : \"#${p.base09}\""
      ""
      "    readonly property int radius       : 12"
      "    readonly property int borderWidth  : 2"
      "    readonly property int padding      : 14"
      "    readonly property int spacing      : 10"
      ""
      "    readonly property font font : Qt.font({"
      "        family: \"FiraCode Nerd Font Mono\","
      "        pixelSize: 14,"
      "        weight: Font.Medium"
      "    })"
      "}"
    ]
  );

in
{
  xdg.configFile."quickshell/qmldir".text = ''
    singleton Theme                1.0 Theme.qml
    Bar                        1.0 bar.qml
  '';
  xdg.configFile."quickshell/Theme.qml".source = themeQml;

  xdg.configFile."quickshell/shell.qml".source = ./shell.qml;
  xdg.configFile."quickshell/bar.qml".source = ./bar.qml;
}
