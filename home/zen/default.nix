{
  pkgs,
  config,
  ...
}:
let
  inherit (config.colorScheme) palette;
in
{
  programs.zen-browser = {
    enable = true;

    languagePacks = [
      "en-US"
      "pt-BR"
    ];
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
        "distribution.searchplugins.defaultLocale" = "en-US";
        "extensions.autoDisableScopes" = 0;
        "general.useragent.locale" = "en-US";
        "media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled" = false;
        "devtools.debugger.remote-enabled" = true;
        "devtools.chrome.enabled" = true;
        "browser.display.os-zoom-behavior" = 0;
        "zen.welcome-screen.seen" = true;
        "zen.theme.gradient.show-custom-colors" = true;
        "zen.view.compact.hide-toolbar" = true;
        "zen.view.compact.enable-at-startup" = true;
        "zen.tabs.vertical.right-side" = true;
        "zen.view.use-single-toolbar" = false;
        "zen.workspaces.continue-where-left-off" = true;
        "zen.view.window.scheme" = 0;
        "devtools.theme" = "dark";
        "layout.css.prefers-color-scheme.content-override" = 0;
        "zen.theme.accent-color" = "#${palette.base0D}";
      };

      containersForce = true;

      containers = {
        Personal = {
          color = "blue";
          icon = "fingerprint";
          id = 0;
        };
        Uni = {
          color = "turquoise";
          icon = "briefcase";
          id = 1;
        };
      };
      spacesForce = true;

      spaces.Personal = {
        id = "47e66c69-815b-40cb-8b41-be4fcf7a2c59";
        container = 0;
        name = "Personal";
        position = 0;
      };

      spaces.Uni = {
        id = "f700d4a8-e760-4aa5-9ada-ddc57a73454b";
        container = 1;
        name = "Uni";
        position = 1;
      };
      search = {
        force = true;
        default = "ddg";
        privateDefault = "ddg";
        engines = {
          "ddg" = {
            urls = [ { template = "https://duckduckgo.com/?q={searchTerms}&ia=web"; } ];
            icon = "https://duckduckgo.com/favicon.ico";
            definedAliases = [ "@ddg" ];
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
          vimium
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
          # TODO: Implement https://github.com/philc/vimium/issues/4600 Upstream

          # "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          #   installation_mode = "force_installed";
          #   settings = {
          #     userDefinedLinkHintCss = ''
          #       div > .vimiumHintMarker {
          #         background: -webkit-gradient(linear, left top, left bottom,
          #           color-stop(0%,#FFF785), color-stop(100%,#FFC542));
          #         border: 1px solid #E3BE23;
          #       }
          #
          #       div > .vimiumHintMarker span {
          #         color: black;
          #         font-weight: bold;
          #         font-size: 12px;
          #       }
          #
          #       div > .vimiumHintMarker > .matchingCharacter {
          #       }
          #     '';
          #
          #     normalModeKeyStateMapping = {
          #       j = {
          #         command = "scrollDown";
          #         options = {};
          #       };
          #     };
          #   };
          # };
        };
      };

      userChrome = ''
        :root {
          --zen-colors-primary: #${palette.base01} !important;
          --zen-primary-color: #${palette.base0D} !important;
          --zen-colors-secondary: #${palette.base02} !important;
          --zen-colors-tertiary: #${palette.base03} !important;
          --zen-colors-border: #${palette.base03} !important;
          --toolbarbutton-icon-fill: #${palette.base0D} !important;
          --lwt-text-color: #${palette.base05} !important;
          --toolbar-field-color: #${palette.base05} !important;
          --tab-selected-textcolor: #${palette.base05} !important;
          --toolbar-field-focus-color: #${palette.base05} !important;
          --toolbar-color: #${palette.base05} !important;
          --newtab-text-primary-color: #${palette.base05} !important;
          --arrowpanel-color: #${palette.base05} !important;
          --arrowpanel-background: #${palette.base00} !important;
          --sidebar-text-color: #${palette.base05} !important;
          --lwt-sidebar-text-color: #${palette.base05} !important;
          --lwt-sidebar-background-color: #${palette.base00} !important;
          --toolbar-bgcolor: #${palette.base00} !important;
          --newtab-background-color: #${palette.base00} !important;
          --zen-themed-toolbar-bg: #${palette.base00} !important;
          --zen-main-browser-background: #${palette.base00} !important;
          --toolbox-bgcolor-inactive: #${palette.base00} !important;
        }

        #permissions-granted-icon {
          color: #${palette.base05} !important;
        }

        .sidebar-placesTree {
          background-color: #${palette.base00} !important;
        }

        #zen-workspaces-button {
          background-color: #${palette.base00} !important;
        }

        #TabsToolbar {
          background-color: #${palette.base00} !important;
        }

        .urlbar-background {
          background-color: #${palette.base01} !important;
          border: 1px solid #${palette.base03} !important;
        }

        .content-shortcuts {
          background-color: #${palette.base01} !important;
          border-color: #${palette.base03} !important;
        }

        .urlbarView-url {
          color: #${palette.base0D} !important;
        }

        #urlbar-input::selection {
          background-color: #${palette.base0D} !important;
          color: #${palette.base00} !important;
        }

        #zenEditBookmarkPanelFaviconContainer {
          background: #${palette.base00} !important;
        }

        #zen-media-controls-toolbar {
          & #zen-media-progress-bar {
            &::-moz-range-track {
              background: #${palette.base02} !important;
            }
          }
        }

        toolbar .toolbarbutton-1 {
          &:not([disabled]) {
            &:is([open], [checked])
              > :is(
                .toolbarbutton-icon,
                .toolbarbutton-text,
                .toolbarbutton-badge-stack
              ) {
              fill: #${palette.base0D};
              background-color: #${palette.base01} !important;
            }
          }
        }

        .identity-color-blue {
          --identity-tab-color: #${palette.base0D} !important;
          --identity-icon-color: #${palette.base0D} !important;
        }

        .identity-color-turquoise {
          --identity-tab-color: #${palette.base0C} !important;
          --identity-icon-color: #${palette.base0C} !important;
        }

        .identity-color-green {
          --identity-tab-color: #${palette.base0B} !important;
          --identity-icon-color: #${palette.base0B} !important;
        }

        .identity-color-yellow {
          --identity-tab-color: #${palette.base0A} !important;
          --identity-icon-color: #${palette.base0A} !important;
        }

        .identity-color-orange {
          --identity-tab-color: #${palette.base09} !important;
          --identity-icon-color: #${palette.base09} !important;
        }

        .identity-color-red {
          --identity-tab-color: #${palette.base08} !important;
          --identity-icon-color: #${palette.base08} !important;
        }

        .identity-color-pink {
          --identity-tab-color: #${palette.base0E} !important;
          --identity-icon-color: #${palette.base0E} !important;
        }

        .identity-color-purple {
          --identity-tab-color: #${palette.base0F} !important;
          --identity-icon-color: #${palette.base0F} !important;
        }

        hbox#titlebar {
          background-color: #${palette.base00} !important;
        }

        #zen-appcontent-navbar-container {
          background-color: #${palette.base00} !important;
        }

        #contentAreaContextMenu menu,
        menuitem,
        menupopup {
          color: #${palette.base05} !important;
          background-color: #${palette.base01} !important;
        }

        menuseparator {
          border-color: #${palette.base03} !important;
        }

        .tabbrowser-tab[selected] {
          background-color: #${palette.base01} !important;
        }

        .tabbrowser-tab:not([selected]):hover {
          background-color: #${palette.base02} !important;
        }
      '';

      userContent = ''
        @-moz-document url-prefix("about:") {
          :root {
            --in-content-page-color: #${palette.base05} !important;
            --color-accent-primary: #${palette.base0D} !important;
            --color-accent-primary-hover: #${palette.base0C} !important;
            --color-accent-primary-active: #${palette.base0B} !important;
            background-color: #${palette.base00} !important;
            --in-content-page-background: #${palette.base00} !important;
            --in-content-box-background: #${palette.base01} !important;
            --in-content-box-border-color: #${palette.base03} !important;
          }
        }

        @-moz-document url("about:newtab"), url("about:home") {
          :root {
            --newtab-background-color: #${palette.base00} !important;
            --newtab-background-color-secondary: #${palette.base01} !important;
            --newtab-element-hover-color: #${palette.base02} !important;
            --newtab-text-primary-color: #${palette.base05} !important;
            --newtab-wordmark-color: #${palette.base05} !important;
            --newtab-primary-action-background: #${palette.base0D} !important;
          }

          body {
            background-color: #${palette.base00} !important;
          }

          .icon {
            color: #${palette.base0D} !important;
          }

          .card-outer:is(:hover, :focus, .active):not(.placeholder) .card-title {
            color: #${palette.base0D} !important;
          }

          .top-site-outer .search-topsite {
            background-color: #${palette.base0D} !important;
          }

          .compact-cards .card-outer .card-context .card-context-icon.icon-download {
            fill: #${palette.base0B} !important;
          }

          .top-sites-list .top-site-outer .tile {
            background-color: #${palette.base01} !important;
          }
        }

        @-moz-document url-prefix("about:preferences") {
          :root {
            --zen-colors-tertiary: #${palette.base03} !important;
            --in-content-text-color: #${palette.base05} !important;
            --link-color: #${palette.base0D} !important;
            --link-color-hover: #${palette.base0C} !important;
            --zen-colors-primary: #${palette.base01} !important;
            --in-content-box-background: #${palette.base01} !important;
            --zen-primary-color: #${palette.base0D} !important;
          }

          groupbox, moz-card {
            background: #${palette.base01} !important;
            border: 1px solid #${palette.base03} !important;
          }

          button,
          groupbox menulist {
            background: #${palette.base02} !important;
            color: #${palette.base05} !important;
            border: 1px solid #${palette.base03} !important;
          }

          button:hover {
            background: #${palette.base03} !important;
          }

          .main-content {
            background-color: #${palette.base00} !important;
          }

          .identity-color-blue {
            --identity-tab-color: #${palette.base0D} !important;
            --identity-icon-color: #${palette.base0D} !important;
          }

          .identity-color-turquoise {
            --identity-tab-color: #${palette.base0C} !important;
            --identity-icon-color: #${palette.base0C} !important;
          }

          .identity-color-green {
            --identity-tab-color: #${palette.base0B} !important;
            --identity-icon-color: #${palette.base0B} !important;
          }

          .identity-color-yellow {
            --identity-tab-color: #${palette.base0A} !important;
            --identity-icon-color: #${palette.base0A} !important;
          }

          .identity-color-orange {
            --identity-tab-color: #${palette.base09} !important;
            --identity-icon-color: #${palette.base09} !important;
          }

          .identity-color-red {
            --identity-tab-color: #${palette.base08} !important;
            --identity-icon-color: #${palette.base08} !important;
          }

          .identity-color-pink {
            --identity-tab-color: #${palette.base0E} !important;
            --identity-icon-color: #${palette.base0E} !important;
          }

          .identity-color-purple {
            --identity-tab-color: #${palette.base0F} !important;
            --identity-icon-color: #${palette.base0F} !important;
          }
        }

        @-moz-document url-prefix("about:addons") {
          :root {
            --zen-dark-color-mix-base: #${palette.base01} !important;
            --background-color-box: #${palette.base00} !important;
            --in-content-box-background: #${palette.base01} !important;
          }

          .addon-card {
            background-color: #${palette.base01} !important;
            border: 1px solid #${palette.base03} !important;
          }
        }

        @-moz-document url-prefix("about:protections") {
          :root {
            --zen-primary-color: #${palette.base0D} !important;
            --social-color: #${palette.base0E} !important;
            --coockie-color: #${palette.base0D} !important;
            --fingerprinter-color: #${palette.base0A} !important;
            --cryptominer-color: #${palette.base0F} !important;
            --tracker-color: #${palette.base0B} !important;
            --in-content-primary-button-background-hover: #${palette.base03} !important;
            --in-content-primary-button-text-color-hover: #${palette.base05} !important;
            --in-content-primary-button-background: #${palette.base02} !important;
            --in-content-primary-button-text-color: #${palette.base05} !important;
          }

          .card {
            background-color: #${palette.base01} !important;
            border: 1px solid #${palette.base03} !important;
          }

          body {
            background-color: #${palette.base00} !important;
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
        EmailTracking = true;
        Category = "strict";
      };
      HttpsOnlyMode = "force_enabled";
      SearchEngines.Default = "DuckDuckGo";
      Preferences = {
        "browser.toolbars.bookmarks.visibility" = {
          Value = "never";
          Status = "default";
        };
        "browser.tabs.unloadOnLowMemory" = {
          Value = true;
          Status = "default";
        };
        "browser.ctrlTab.sortByRecentlyUsed" = {
          Value = true;
          Status = "default";
        };
        "browser.tabs.warnOnClose" = {
          Value = false;
          Status = "default";
        };
        "browser.low_commit_space_threshold_percent" = {
          value = 100;
          status = "default";
        };
        "breakpad.reportURL" = {
          value = "";
          status = "default";
        };
        "browser.tabs.crashReporting.sendReport" = {
          value = false;
          status = "default";
        };
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = {
          value = false;
          status = "default";
        };
      };
    };
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
  };
}
