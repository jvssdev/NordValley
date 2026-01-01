{
  pkgs,
  nix-colors,
  ...
}: let
  palette = nix-colors.colorSchemes.nord.palette;
  vimiumc = "hfjbmagddngcpeloejdejnfgbamkjaeg";
in {
  preferencesFile = pkgs.writeText "initial_preferences" (builtins.toJSON {
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
    extensions.commands."linux:Alt+Shift+A" = {
      command_name = "addSite";
      extension = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
      global = false;
    };
    extensions.settings."${vimiumc}" = {
      keyMappings = ''        #!no-check
        map t Vomnibar.activateTabs
        map L nextTab
        map H previousTab
        unmap J
        unmap K'';
      notifyUpdate = false;
      searchUrl = "https://www.google.com/search?q=$s Google";
      smoothScroll = true;
      scrollStepSize = 60;
      linkHintCharacters = "sadfjklewcmpgh";
      filterLinkHints = false;
      hideHud = false;
      grabBackFocus = false;
      userDefinedLinkHintCss = ''        div > .vimiumHintMarker {
          background: #${palette.base0A};
          border: 1px solid #${palette.base0A};
        }

        div > .vimiumHintMarker span {
          color: #${palette.base00};
          font-weight: bold;
          font-size: 12px;
          text-shadow: none !important;
        }

        #vomnibar,
        #vomnibar input,
        #vomnibar #vomnibar-search-area,
        #vomnibar ul,
        #vomnibar li {
          color: #${palette.base05} !important;
          background-color: #${palette.base00} !important;
          border: 0px !important;
        }

        #vomnibar {
          padding: 1px !important;
        }

        #vomnibar #vomnibar-search-area {
          padding: 5px !important;
          border-bottom: 2px solid #${palette.base05} !important;
        }

        #vomnibar li.selected {
          background-color: #${palette.base01} !important;
        }

        #vomnibar li em,
        #vomnibar li .title,
        #vomnibar li .relevancy {
          color: #${palette.base05} !important;
        }

        #vomnibar li .source,
        #vomnibar li em .match {
          color: #${palette.base03} !important;
        }

        #vomnibar li .match,
        #vomnibar li .title .match {
          color: #${palette.base07} !important;
        }

        #vomnibar li .url {
          color: #${palette.base0D} !important;
        }'';
    };
  });
}
