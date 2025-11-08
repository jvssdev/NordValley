{ pkgs, lib, ... }:
{
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "suspend";
    lidSwitchDocked = "ignore";
    powerKey = "suspend";
    powerKeyLongPress = "poweroff";
  };
}
