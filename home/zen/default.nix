{
  pkgs,
  lib,
  specialArgs,
  ...
}:
let
  zen-browser = specialArgs.zen-browser;
in
{
  imports = [
    zen-browser.homeManagerModules.default
  ];

  home.packages = [
    zen-browser.packages.${pkgs.system}.default
  ];

  programs.zen-browser = {
    enable = true;
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      settings = {
        "apz.overscroll.enabled" = true;
        "browser.aboutConfig.showWarning" = false;
        "browser.download.start_downloads_in_tmp_dir" = true;
        "browser.ml.linkPreview.enabled" = true;
        "browser.search.isUS" = true;
        "browser.tabs.groups.enabled" = true;
        "browser.tabs.groups.smart.enabled" = true;
        "cookiebanners.service.mode.privateBrowsing" = 2;
        "cookiebanners.service.mode" = 2;
        "cookiebanners.ui.desktop.enabled" = 2;
        "distribution.searchplugins.defaultLocale" = "en-GB";
        "extensions.autoDisableScopes" = 0;
        "general.useragent.locale" = "en-GB";
        "media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled" = false;
        "devtools.debugger.remote-enabled" = true;
        "devtools.chrome.enabled" = true;
      };
      search = {
        force = true;
        default = "DuckDuckGo";
        engines = {
          "DuckDuckGo" = {
            urls = [ { template = "https://duckduckgo.com/?q={searchTerms}&ia=web"; } ];
            icon = "https://duckduckgo.com/favicon.ico";
            definedAliases = [ "@ddg" ];
          };
        };
      };
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        darkreader
        privacy-badger
        keepassxc-browser
        sponsorblock
        betterttv
      ];
      userChrome = ''
        :root:not([inDOMFullscreen="true"]):not([chromehidden~="location"]):not([chromehidden~="toolbar"]) {
          & #tabbrowser-tabbox #tabbrowser-tabpanels .browserSidebarContainer {
            & browser[transparent="true"] {
              background: none !important;
            }
          }
        }
      '';
    };
    policies = {
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
  };
}
