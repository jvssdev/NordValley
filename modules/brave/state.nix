{...}: let
  localState = {
    brave.p3a.enabled = false;
    brave.stats.reporting_enabled = false;
    user_experience_metrics.reporting_enabled = false;
    brave.onboarding.last_shields_icon_highlighted_time = "1";
    brave.widevine_opted_in = true;
  };
in {
  home.file.".config/BraveSoftware/Brave-Browser/Local State" = {
    text = builtins.toJSON localState;
    force = true;
  };
}
