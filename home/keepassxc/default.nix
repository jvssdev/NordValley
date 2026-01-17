{
  programs.keepassxc.enable = true;

  xdg.configFile."keepassxc/keepassxc.ini" = {
    force = true;
    text = ''
      [General]
      ConfigVersion=2
      UseAtomicSaves=true

      [Browser]
      AlwaysAllowAccess=true
      Enabled=true
      SearchInAllDatabases=true

      [GUI]
      ApplicationTheme=classic
      CompactMode=true

      [PasswordGenerator]
      Length=24
    '';
  };
}
