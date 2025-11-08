{ pkgs, lib, ... }:
{
  services.logind.settings = {
    HandlePowerKey = "suspend";
    HandlePowerKeyLongPress = "poweroff";
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "ignore";
  };
}
