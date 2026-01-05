{
  initialPreferences = {
    brave.de_amp.enabled = true;
    brave.debounce.enabled = true;
    brave.reduce_language = true;
    safety_hub.unused_site_permissions_revocation.enabled = false;
    enable_do_not_track = true;
    profile.content_settings.exceptions.cosmeticFiltering."*,*".setting = 2;
    profile.content_settings.exceptions.cosmeticFiltering."*,https://firstparty".setting = 2;
    profile.content_settings.exceptions.fingerprintingV2."*,*".setting = 3;
    profile.content_settings.exceptions.shieldsAds."*,*".setting = 3;
    profile.content_settings.exceptions.trackers."*,*".setting = 3;
    profile.cookie_controls_mode = 1;
    profile.default_content_setting_values.httpsUpgrades = 2;
    https_only_mode_enabled = true;
    profile.default_content_setting_values.javascript_jit = 2;
    brave.webtorrent_enabled = false;
    brave.gcm.channel_status = false;
    brave.webcompat.report.enable_save_contact_info = false;
    search.suggest_enabled = false;
    brave.omnibox.bookmark_suggestions_enabled = false;
    brave.omnibox.commander_suggestions_enabled = false;
    brave.top_site_suggestions_enabled = false;
    brave.shields.stats_badge_visible = false;
    brave.brave_ads.should_allow_ads_subdivision_targeting = false;
    brave.rewards.badge_text = "";
    brave.rewards.show_brave_rewards_button_in_location_bar = false;
    brave.today.should_show_toolbar_button = false;
    brave.wallet.show_wallet_icon_on_toolbar = false;
    brave.show_fullscreen_reminder = false;
    brave.show_side_panel_button = false;
    brave.show_bookmarks_button = false;
    bookmark_bar.show_tab_groups = false;
    brave.tabs = {
      vertical_tabs_collapsed = true;
      vertical_tabs_enabled = true;
      vertical_tabs_on_right = false;
    };
    extensions.theme.system_theme = 1;
  };
}
