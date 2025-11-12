{ pkgs, lib, ... }:
{
  services.logind = {
    powerKey = "suspend";
    powerKeyLongPress = "poweroff";
    lidSwitch = "suspend";
    lidSwitchExternalPower = "suspend";
    lidSwitchDocked = "ignore";
  };
}
