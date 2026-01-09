{
  pkgs,
  config,
  ...
}: let
  palette = config.colorScheme.palette;
in {
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
        "browser.display.os-zoom-behavior" = 0;
      };
      search = {
        force = true;
        default = "ddg";
        engines = {
          "ddg" = {
            urls = [{template = "https://duckduckgo.com/?q={searchTerms}&ia=web";}];
            icon = "https://duckduckgo.com/favicon.ico";
            definedAliases = ["@ddg"];
          };
        };
      };
      extensions = {
        force = true;
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          darkreader
          privacy-badger
          keepassxc-browser
          sponsorblock
          betterttv
          vimium-c
        ];

        settings = {
          "uBlock0@raymondhill.net".settings = {
            userSettings = rec {
              advancedUserEnabled = true;
              cloudStorageEnabled = false;
              # collapseBlocked = false;
              uiAccentCustom = true;
              uiAccentCustom0 = "${palette.base0D}";
              externalLists = pkgs.lib.concatStringsSep "\n" importedLists;
              importedLists = [
                "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/anti.piracy.txt"
                "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/doh-vpn-proxy-bypass.txt"
                "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/dyndns.txt"
                "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/fake.txt"
                "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/gambling.txt"
                "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/hoster.txt"
                "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/nsfw.txt"
                "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.mini.txt"
                "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/spam-tlds-ublock.txt"
                "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/tif.txt"
                "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/ultimate.txt"
              ];
              largeMediaSize = 250;
              # popupPanelSections = 31;
              tooltipsDisabled = true;
            };
            dynamicFilteringString = ''
              no-cosmetic-filtering: * true
              no-cosmetic-filtering: appleid.apple.com false
              no-cosmetic-filtering: bing.com false
              no-cosmetic-filtering: cnn.com false
              no-cosmetic-filtering: google.com false
              no-cosmetic-filtering: www.notion.com false
              no-cosmetic-filtering: www.notion.so false
              no-cosmetic-filtering: old.reddit.com false
              no-cosmetic-filtering: slack.com false
              no-cosmetic-filtering: kadena-io.slack.com false
              no-cosmetic-filtering: twitch.tv false
              no-cosmetic-filtering: youtube.com false
              no-csp-reports: * true
              no-large-media: * true
              no-large-media: www.amazon.com false
              no-large-media: appleid.apple.com false
              no-large-media: login.bmwusa.com false
              no-large-media: www.ftb.ca.gov false
              no-large-media: www.notion.com false
              no-large-media: www.notion.so false
              no-large-media: old.reddit.com false
              no-large-media: client.schwab.com false
              no-large-media: sws-gateway-nr.schwab.com false
              no-large-media: slack.com false
              no-large-media: kadena-io.slack.com false
              no-large-media: www.youtube.com false
              no-remote-fonts: * true
              no-remote-fonts: www.amazon.com false
              no-remote-fonts: appleid.apple.com false
              no-remote-fonts: login.bmwusa.com false
              no-remote-fonts: www.ftb.ca.gov false
              no-remote-fonts: docs.google.com false
              no-remote-fonts: drive.google.com false
              no-remote-fonts: gemini.google.com false
              no-remote-fonts: notebooklm.google.com false
              no-remote-fonts: www.google.com false
              no-remote-fonts: kadena.latticehq.com false
              no-remote-fonts: www.notion.com false
              no-remote-fonts: www.notion.so false
              no-remote-fonts: usa.onlinesrp.org false
              no-remote-fonts: old.reddit.com false
              no-remote-fonts: client.schwab.com false
              no-remote-fonts: sws-gateway-nr.schwab.com false
              no-remote-fonts: slack.com false
              no-remote-fonts: app.slack.com false
              no-remote-fonts: kadena-io.slack.com false
              no-remote-fonts: www.youtube.com false
              * * 3p-frame block
              * * 3p-script block
              * cloudflare.com * noop
              www.amazon.com * 3p noop
              www.amazon.com * 3p-frame noop
              www.amazon.com * 3p-script noop
              console.anthropic.com * 3p-frame noop
              console.anthropic.com * 3p-script noop
              appleid.apple.com * 3p-frame noop
              appleid.apple.com * 3p-script noop
              app.asana.com * 3p-frame noop
              app.asana.com * 3p-script noop
              behind-the-scene * * noop
              behind-the-scene * 1p-script noop
              behind-the-scene * 3p noop
              behind-the-scene * 3p-frame noop
              behind-the-scene * 3p-script noop
              behind-the-scene * image noop
              behind-the-scene * inline-script noop
              app01.us.bill.com * 3p-frame noop
              app01.us.bill.com * 3p-script noop
              login.bmwusa.com * 3p-frame noop
              login.bmwusa.com * 3p-script noop
              www.facebook.com * 3p noop
              www.facebook.com * 3p-frame noop
              www.facebook.com * 3p-script noop
              www.fidium.net * 3p-frame noop
              www.fidium.net * 3p-script noop
              file-scheme * 3p-frame noop
              file-scheme * 3p-script noop
              github.com * 3p noop
              github.com * 3p-frame noop
              github.com * 3p-script noop
              accounts.google.com * 3p-frame noop
              accounts.google.com * 3p-script noop
              docs.google.com * 3p-frame noop
              docs.google.com * 3p-script noop
              drive.google.com * 3p noop
              drive.google.com * 3p-frame noop
              drive.google.com * 3p-script noop
              notebooklm.google.com * 3p noop
              notebooklm.google.com * 3p-frame noop
              notebooklm.google.com * 3p-script noop
              huggingface.co * 3p-frame noop
              huggingface.co * 3p-script noop
              kadena.latticehq.com * 3p-frame noop
              kadena.latticehq.com * 3p-script noop
              www.linkedin.com * 3p noop
              www.notion.com * 3p-frame noop
              www.notion.com * 3p-script noop
              www.notion.so * 3p-frame noop
              www.notion.so * 3p-script noop
              old.reddit.com * 3p noop
              old.reddit.com * 3p-frame noop
              old.reddit.com * 3p-script noop
              www.reddit.com * 3p noop
              www.reddit.com * 3p-frame noop
              www.reddit.com * 3p-script noop
              respected-meat-54f.notion.site * 3p noop
              myprofile.saccounty.gov * 3p-frame noop
              myprofile.saccounty.gov * 3p-script noop
              myutilities.saccounty.gov * 3p-frame noop
              myutilities.saccounty.gov * 3p-script noop
              client.schwab.com * 3p-frame noop
              client.schwab.com * 3p-script noop
              sws-gateway-nr.schwab.com * 3p-frame noop
              sws-gateway-nr.schwab.com * 3p-script noop
              slack.com * 3p-frame noop
              slack.com * 3p-script noop
              app.slack.com * 3p noop
              app.slack.com * 3p-frame noop
              app.slack.com * 3p-script noop

              www.youtube.com * 3p-frame noop
              www.youtube.com * 3p-script noop
            '';
            urlFilteringString = "";

            userFilters = "";
            selectedFilterLists = [
              "user-filters"
              "ublock-filters"
              "ublock-badware"
              "ublock-privacy"
              "ublock-quick-fixes"
              "ublock-unbreak"
              "easylist"
              "easyprivacy"
              "adguard-spyware"
              "adguard-spyware-url"
              "urlhaus-1"
              "plowe-0"
              "fanboy-cookiemonster"
              "ublock-cookies-easylist"
              "fanboy-social"
              "easylist-chat"
              "easylist-newsletters"
              "easylist-notifications"
              "easylist-annoyances"
              "ublock-annoyances"
              "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/hoster.txt"
              "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/fake.txt"
              "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.mini.txt"
              "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/spam-tlds-ublock.txt"
            ];
            whitelist = [
              "chrome-extension-scheme"
              "moz-extension-scheme"
            ];
          };

          "vimium-c@gdh1995.cn".settings = {
            keyMappings = "#!no-check\nunmap x\nmap t Vomnibar.activateTabs";
          };
        };
      };
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
