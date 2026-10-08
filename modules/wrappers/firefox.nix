{
  flake.wrappers.firefox = {
    wlib,
    lib,
    pkgs,
    config,
    ...
  }: {
    imports = [wlib.modules.default];
    options.colors = let
      mkColorOption = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      colorKeys = ["bookmark_text" "button_background_active" "button_background_hover" "icons" "icons_attention" "frame" "frame_inactive" "ntp_background" "ntp_card_background" "ntp_text" "popup" "popup_border" "popup_highlight" "popup_highlight_text" "popup_text" "sidebar" "sidebar_border" "sidebar_highlight" "sidebar_highlight_text" "sidebar_text" "tab_background_separator" "tab_background_text" "tab_line" "tab_loading" "tab_selected" "tab_text" "toolbar" "toolbar_bottom_separator" "toolbar_field" "toolbar_field_border" "toolbar_field_border_focus" "toolbar_field_focus" "toolbar_field_highlight" "toolbar_field_highlight_text" "toolbar_field_separator" "toolbar_field_text" "toolbar_field_text_focus" "toolbar_text" "toolbar_top_separator" "toolbar_vertical_separator"];
    in
      lib.genAttrs colorKeys (_name: mkColorOption);
    config.package = pkgs.firefox.override {
      extraPrefs = ''
        // Nimbus / Experiments
        lockPref("nimbus.debug", false);
        lockPref("nimbus.rollouts.enabled", false);
        lockPref("services.sync.prefs.sync.nimbus.rollouts.enabled", false);

        // Normandy / Shield
        lockPref("app.normandy.enabled", false);
        lockPref("app.normandy.api_url", "");
        lockPref("app.shield.optoutstudies.enabled", false);

        // Telemetry (то, что не покрывается DisableTelemetry)
        lockPref("toolkit.telemetry.unified", false);
        lockPref("toolkit.telemetry.server", "");
        lockPref("toolkit.telemetry.cachedClientID", "");
        lockPref("toolkit.telemetry.newProfilePing.enabled", false);
        lockPref("toolkit.telemetry.shutdownPingSender.enabled", false);
        lockPref("toolkit.telemetry.updatePing.enabled", false);
        lockPref("toolkit.telemetry.firstShutdownPing.enabled", false);
        lockPref("toolkit.telemetry.bhrPing.enabled", false);
        lockPref("datareporting.healthreport.service.enabled", false);
        lockPref("breakpad.reportURL", "");

        // Beacon
        lockPref("beacon.enabled", false);

        // Privacy (не все privacy.* разрешены в Preferences policy)
        lockPref("privacy.donottrackheader.enabled", true);
        lockPref("privacy.query_stripping.enabled", true);
        lockPref("privacy.usercontext.about_newtab_segregation.enabled", true);

        // Security
        lockPref("security.ssl.disable_session_identifiers", true);

        // Device sensors
        lockPref("device.sensors.enabled", false);
        lockPref("device.sensors.ambientLight.enabled", false);
        lockPref("device.sensors.motion.enabled", false);
        lockPref("device.sensors.orientation.enabled", false);
        lockPref("device.sensors.proximity.enabled", false);

        // Sync-related (services.* не разрешены)
        lockPref("services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSite", false);
      '';
      extraPolicies = {
        DownloadDirectory = "\${home}/Downloads";
        RequestedLocales = [
          "ru"
          "en-US"
        ];
        Homepage = {
          Locked = false;
          StartPage = "previous-session";
        };
        SkipTermsOfUse = true;
        DisableFirefoxScreenshots = true;
        HttpsOnlyMode = "force_enabled";
        AppAutoUpdate = false;
        DisableProfileRefresh = true;
        DontCheckDefaultBrowser = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisableMasterPasswordCreation = true;
        GenerativeAI = {
          Enabled = false;
          Chatbot = false;
          LinkPreviews = false;
          TabGroups = false;
          Locked = true;
        };
        AIControls = {
          Default = {
            Value = "blocked";
            Locked = true;
          };
          Translations = {
            Value = "available";
            Locked = true;
          };
          PDFAltText = {
            Value = "blocked";
            Locked = true;
          };
          SmartTabGroups = {
            Value = "blocked";
            Locked = true;
          };
          LinkPreviewKeyPoints = {
            Value = "blocked";
            Locked = true;
          };
          SidebarChatbot = {
            Value = "blocked";
            Locked = true;
          };
          SmartWindow = {
            Value = "blocked";
            Locked = true;
          };
        };
        DNSOverHTTPS = {
          Enabled = false;
        };
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
          EmailTracking = true;
          SuspectedFingerprinting = true;
        };
        CaptivePortal = false;
        NetworkPrediction = false;
        DisableFirefoxAccounts = true;
        DisableFormHistory = true;
        NewTabPage = false;
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        NoDefaultBookmarks = true;
        EncryptedMediaExtensions = {
          Enabled = false;
          Locked = true;
        };
        OfferToSaveLogins = false;
        SanitizeOnShutdown = {
          Cache = true;
          Cookies = true;
          FormData = true;
          History = false;
          Sessions = true;
          SiteSettings = true;
          Locked = true;
        };
        SearchSuggestEnabled = false;
        FirefoxHome = {
          TopSites = false;
          SponsoredTopSites = false;
          Highlights = false;
          Pocket = false;
          Stories = false;
          SponsoredPocket = false;
          SponsoredStories = false;
          Snippets = false;
          Locked = true;
        };
        Cookies = {
          Allow = [
            "https://github.com"
            "https://yandex.ru"
            "https://deepseek.com"
            "https://reyohoho.gitlab.io"
            "https://grok.com"
            "https://mail.ru"
            "https://habr.com"
            "https://chatgpt.com"
            "https://claude.ai"
            "https://vk.com"
            "https://google.com"
            "https://steampowered.com"
            "https://steamcommunity.com"
            "https://perplexity.ai"
            "https://max.ru"
            "https://discord.com"
          ];
          AllowSession = [];
          Block = [];
          Locked = true;
          Behavior = "reject-foreign";
          BehaviorPrivateBrowsing = "reject";
        };
        Permissions = {
          Camera = {
            Allow = [];
            Block = [];
            BlockNewRequests = true;
            Locked = true;
          };
          Microphone = {
            Allow = [
              "https://telemost.yandex.ru"
            ];
            Block = [];
            BlockNewRequests = true;
            Locked = true;
          };
          Location = {
            Allow = [];
            Block = [];
            BlockNewRequests = true;
            Locked = true;
          };
          Notifications = {
            Allow = [];
            Block = [];
            BlockNewRequests = true;
            Locked = true;
          };
          Autoplay = {
            Allow = [
              "https://telemost.yandex.ru"
            ];
            Block = [];
            Default = "block-audio-video";
            Locked = true;
          };
          VirtualReality = {
            Allow = [];
            Block = [];
            BlockNewRequests = true;
            Locked = true;
          };
          ScreenShare = {
            Allow = [];
            Block = [];
            BlockNewRequests = true;
            Locked = true;
          };
        };
        ExtensionSettings = let
          colors = lib.mapAttrs (_name: c: "rgb(${toString c.r}, ${toString c.g}, ${toString c.b})") (lib.filterAttrs (_name: val: val != null) config.colors);
          themeExtensionId = "custom-nix-theme@local";
          manifestDir = pkgs.writeTextDir "manifest.json" (builtins.toJSON {
            manifest_version = 2;
            name = "Nix Generated Theme";
            version = "1.0.0";
            browser_specific_settings.gecko.id = themeExtensionId;
            theme = {
              inherit colors;
              properties.color_scheme = "auto";
            };
          });

          themeXpi = pkgs.runCommand "nix-theme.xpi" {nativeBuildInputs = [pkgs.zip];} ''
            cd ${manifestDir}
            zip -X $out manifest.json
          '';
        in
          (lib.optionalAttrs (colors != {}) {
            "${themeExtensionId}" = lib.mkIf (colors != {}) {
              install_url = "file://${themeXpi}";
              installation_mode = "force_installed";
            };
          })
          // {
            "uBlock0@raymondhill.net" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              installation_mode = "force_installed";
            };
            "sponsorBlocker@ajay.app" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
              installation_mode = "force_installed";
            };
            "jid1-BoFifL9Vbdl2zQ@jetpack" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/decentraleyes/latest.xpi";
              installation_mode = "force_installed";
            };
            "CanvasBlocker@kkapsner.de" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/canvasblocker/latest.xpi";
              installation_mode = "force_installed";
            };
            "keepassxc-browser@keepassxc.org" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/keepassxc-browser/latest.xpi";
              installation_mode = "force_installed";
            };
            "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/refined-github-/latest.xpi";
              installation_mode = "force_installed";
            };
            "firefox-extension@steamdb.info" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/steam-database/latest.xpi";
              installation_mode = "force_installed";
            };
            "floccus@handmadeideas.org" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/floccus/latest.xpi";
              installation_mode = "force_installed";
            };
            "offline-qr-code@rugk.github.io" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/offline-qr-code-generator/latest.xpi";
              installation_mode = "force_installed";
            };
          };
        Preferences = {
          "general.autoScroll" = {
            Value = true;
            Status = "locked";
          };
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = {
            Value = false;
            Status = "locked";
          };
          "sidebar.visibility" = {
            Value = "hide-sidebar";
            Status = "locked";
          };
          "browser.startup.windowsLaunchOnLogin.enabled" = {
            Value = false;
            Status = "locked";
          };
          "browser.startup.homepage_override.mstone" = {
            Value = "ignore";
            Status = "locked";
          };
          "browser.tabs.crashReporting.sendReport" = {
            Value = false;
            Status = "locked";
          };
          "media.video_stats.enabled" = {
            Value = false;
            Status = "locked";
          };
          "privacy.globalprivacycontrol.enabled" = {
            Value = true;
            Status = "locked";
          };
          "privacy.globalprivacycontrol.functionality.enabled" = {
            Value = true;
            Status = "locked";
          };
          "browser.send_pings" = {
            Value = false;
            Status = "locked";
          };
          "browser.safebrowsing.blockedURIs.enabled" = {
            Value = false;
            Status = "locked";
          };
          "browser.safebrowsing.downloads.enabled" = {
            Value = false;
            Status = "locked";
          };
          "browser.safebrowsing.downloads.remote.enabled" = {
            Value = false;
            Status = "locked";
          };
          "browser.safebrowsing.downloads.remote.url" = {
            Value = "";
            Status = "locked";
          };
          "browser.safebrowsing.malware.enabled" = {
            Value = false;
            Status = "locked";
          };
          "browser.safebrowsing.phishing.enabled" = {
            Value = false;
            Status = "locked";
          };
          "network.http.speculative-parallel-limit" = {
            Value = 15;
            Status = "locked";
          };
          "network.predictor.enable-prefetch" = {
            Value = false;
            Status = "locked";
          };
          "network.predictor.enabled" = {
            Value = false;
            Status = "locked";
          };
          "network.prefetch-next" = {
            Value = false;
            Status = "locked";
          };
          "browser.urlbar.speculativeConnect.enabled" = {
            Value = false;
            Status = "locked";
          };
          "media.gmp-widevinecdm.enabled" = {
            Value = false;
            Status = "locked";
          };
          "media.navigator.enabled" = {
            Value = true;
            Status = "user";
          };
          "media.peerconnection.enabled" = {
            Value = true;
            Status = "locked";
          };
          "browser.newtab.preload" = {
            Value = false;
            Status = "locked";
          };
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = {
            Value = false;
            Status = "locked";
          };
          "browser.urlbar.groupLabels.enabled" = {
            Value = false;
            Status = "locked";
          };
          "browser.urlbar.quicksuggest.enabled" = {
            Value = false;
            Status = "locked";
          };
          "browser.urlbar.trimURLs" = {
            Value = false;
            Status = "locked";
          };
          "browser.aboutConfig.showWarning" = {
            Value = false;
            Status = "locked";
          };
          "extensions.autoDisableScopes" = {
            Value = 14;
            Status = "locked";
          };
          "extensions.getAddons.cache.enabled" = {
            Value = false;
            Status = "locked";
          };
          "extensions.getAddons.showPane" = {
            Value = false;
            Status = "locked";
          };
          "extensions.webservice.discoverURL" = {
            Value = "";
            Status = "locked";
          };
          "dom.battery.enabled" = {
            Value = false;
            Status = "locked";
          };
          "webgl.disabled" = {
            Value = false;
            Status = "locked";
          };
          "browser.sessionstore.privacy_level" = {
            Value = 0;
            Status = "locked";
          };
          "signon.autofillForms" = {
            Value = false;
            Status = "locked";
          };
          "dom.private-attribution.submission.enabled" = {
            Value = false;
            Status = "locked";
          };
          "signon.generation.enabled" = {
            Value = false;
            Status = "locked";
          };
          "browser.search.suggest.enabled" = {
            Value = false;
            Status = "locked";
          };
          "browser.urlbar.showSearchTerms.enabled" = {
            Value = false;
            Status = "locked";
          };
          "browser.urlbar.showSearchSuggestionsFirst" = {
            Value = false;
            Status = "locked";
          };
          "browser.urlbar.suggest.trending" = {
            Value = false;
            Status = "locked";
          };
          "browser.urlbar.suggest.recentsearches" = {
            Value = false;
            Status = "locked";
          };
          "browser.urlbar.suggest.history" = {
            Value = false;
            Status = "locked";
          };
          "browser.urlbar.suggest.topsites" = {
            Value = false;
            Status = "locked";
          };
          "browser.urlbar.suggest.engines" = {
            Value = false;
            Status = "locked";
          };
          "browser.urlbar.suggest.quickactions" = {
            Value = false;
            Status = "locked";
          };
          "browser.search.separatePrivateDefault.ui.enabled" = {
            Value = true;
            Status = "locked";
          };
        };
      };
    };
  };
}
