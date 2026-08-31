{ self, inputs, ... }: {
  flake.homeModules.firefox = { pkgs, lib, ... }: {
    stylix.targets.firefox = {
      profileNames = [ "default" ];
    };
    programs.firefox = {
      enable = true;
      languagePacks = [ "ru" ];
      profiles = {
        default = { };
      };
      policies = {
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
          AllowSession = [ ];
          Block = [ ];
          Locked = true;
          Behavior = "reject-foreign";
          BehaviorPrivateBrowsing = "reject";
        };
        Permissions = {
          Camera = {
            Allow = [ ];
            Block = [ ];
            BlockNewRequests = true;
            Locked = true;
          };
          Microphone = {
            Allow = [
              "https://telemost.yandex.ru"
            ];
            Block = [ ];
            BlockNewRequests = true;
            Locked = true;
          };
          Location = {
            Allow = [ ];
            Block = [ ];
            BlockNewRequests = true;
            Locked = true;
          };
          Notifications = {
            Allow = [ ];
            Block = [ ];
            BlockNewRequests = true;
            Locked = true;
          };
          Autoplay = {
            Allow = [
              "https://telemost.yandex.ru"
            ];
            Block = [ ];
            Default = "block-audio-video";
            Locked = true;
          };
          VirtualReality = {
            Allow = [ ];
            Block = [ ];
            BlockNewRequests = true;
            Locked = true;
          };
          ScreenShare = {
            Allow = [ ];
            Block = [ ];
            BlockNewRequests = true;
            Locked = true;
          };
        };
        ExtensionSettings = {
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
          browser.crashReports.unsubmittedCheck.autoSubmit2 = {
            Value = false;
            Status = "locked";
          };
          nimbus.debug = {
            Value = false;
            Status = "locked";
          };
          services.sync.prefs.sync.nimbus.rollouts.enabled = {
            Value = false;
            Status = "locked";
          };
          nimbus.rollouts.enabled = {
            Value = false;
            Status = "locked";
          };
          sidebar.visibility = {
            Value = "hide-sidebar";
            Status = "locked";
          };
          browser.startup.windowsLaunchOnLogin.enabled = {
            Value = false;
            Status = "locked";
          };
          browser.startup.homepage_override.mstone = {
            Value = "ignore";
            Status = "locked";
          };
          app.normandy.api_url = {
            Value = "";
            Status = "locked";
          };
          app.normandy.enabled = {
            Value = false;
            Status = "locked";
          };
          app.shield.optoutstudies.enabled = {
            Value = false;
            Status = "locked";
          };
          breakpad.reportURL = {
            Value = "";
            Status = "locked";
          };
          browser.tabs.crashReporting.sendReport = {
            Value = false;
            Status = "locked";
          };
          toolkit.telemetry.bhrPing.enabled = {
            Value = false;
            Status = "locked";
          };
          toolkit.telemetry.cachedClientID = {
            Value = "";
            Status = "locked";
          };
          toolkit.telemetry.firstShutdownPing.enabled = {
            Value = false;
            Status = "locked";
          };
          toolkit.telemetry.newProfilePing.enabled = {
            Value = false;
            Status = "locked";
          };
          toolkit.telemetry.server = {
            Value = "";
            Status = "locked";
          };
          toolkit.telemetry.shutdownPingSender.enabled = {
            Value = false;
            Status = "locked";
          };
          toolkit.telemetry.unified = {
            Value = false;
            Status = "locked";
          };
          toolkit.telemetry.updatePing.enabled = {
            Value = false;
            Status = "locked";
          };
          datareporting.healthreport.service.enabled = {
            Value = false;
            Status = "locked";
          };
          beacon.enabled = {
            Value = false;
            Status = "locked";
          };
          media.video_stats.enabled = {
            Value = false;
            Status = "locked";
          };
          privacy.donottrackheader.enabled = {
            Value = true;
            Status = "locked";
          };
          privacy.globalprivacycontrol.enabled = {
            Value = true;
            Status = "locked";
          };
          privacy.globalprivacycontrol.functionality.enabled = {
            Value = true;
            Status = "locked";
          };
          privacy.query_stripping.enabled = {
            Value = true;
            Status = "locked";
          };
          browser.send_pings = {
            Value = false;
            Status = "locked";
          };
          privacy.usercontext.about_newtab_segregation.enabled = {
            Value = true;
            Status = "locked";
          };
          security.ssl.disable_session_identifiers = {
            Value = true;
            Status = "locked";
          };
          browser.safebrowsing.blockedURIs.enabled = {
            Value = false;
            Status = "locked";
          };
          browser.safebrowsing.downloads.enabled = {
            Value = false;
            Status = "locked";
          };
          browser.safebrowsing.downloads.remote.enabled = {
            Value = false;
            Status = "locked";
          };
          browser.safebrowsing.downloads.remote.url = {
            Value = "";
            Status = "locked";
          };
          browser.safebrowsing.malware.enabled = {
            Value = false;
            Status = "locked";
          };
          browser.safebrowsing.phishing.enabled = {
            Value = false;
            Status = "locked";
          };
          network.http.speculative-parallel-limit = {
            Value = 15;
            Status = "locked";
          };
          network.predictor.enable-prefetch = {
            Value = false;
            Status = "locked";
          };
          network.predictor.enabled = {
            Value = false;
            Status = "locked";
          };
          network.prefetch-next = {
            Value = false;
            Status = "locked";
          };
          browser.urlbar.speculativeConnect.enabled = {
            Value = false;
            Status = "locked";
          };
          media.gmp-widevinecdm.enabled = {
            Value = false;
            Status = "locked";
          };
          media.navigator.enabled = {
            Value = true;
            Status = "user";
          };
          media.peerconnection.enabled = {
            Value = true;
            Status = "locked";
          };
          browser.newtab.preload = {
            Value = false;
            Status = "locked";
          };
          browser.newtabpage.activity-stream.section.highlights.includePocket = {
            Value = false;
            Status = "locked";
          };
          browser.urlbar.groupLabels.enabled = {
            Value = false;
            Status = "locked";
          };
          browser.urlbar.quicksuggest.enabled = {
            Value = false;
            Status = "locked";
          };
          browser.urlbar.trimURLs = {
            Value = false;
            Status = "locked";
          };
          browser.aboutConfig.showWarning = {
            Value = false;
            Status = "locked";
          };
          extensions.autoDisableScopes = {
            Value = 14;
            Status = "locked";
          };
          extensions.getAddons.cache.enabled = {
            Value = false;
            Status = "locked";
          };
          extensions.getAddons.showPane = {
            Value = false;
            Status = "locked";
          };
          extensions.webservice.discoverURL = {
            Value = "";
            Status = "locked";
          };
          "extensions.ClearURLs@kevinr.whiteList" = {
            Value = "";
            Status = "locked";
          };
          "extensions.Decentraleyes@ThomasRientjes.whiteList" = {
            Value = "";
            Status = "locked";
          };
          extensions.greasemonkey.stats.optedin = {
            Value = false;
            Status = "locked";
          };
          extensions.greasemonkey.stats.url = {
            Value = "";
            Status = "locked";
          };
          device.sensors.enabled = {
            Value = false;
            Status = "locked";
          };
          device.sensors.ambientLight.enabled = {
            Value = false;
            Status = "locked";
          };
          device.sensors.motion.enabled = {
            Value = false;
            Status = "locked";
          };
          device.sensors.orientation.enabled = {
            Value = false;
            Status = "locked";
          };
          device.sensors.proximity.enabled = {
            Value = false;
            Status = "locked";
          };
          dom.battery.enabled = {
            Value = false;
            Status = "locked";
          };
          webgl.disabled = {
            Value = false;
            Status = "locked";
          };
          browser.sessionstore.privacy_level = {
            Value = 0;
            Status = "locked";
          };
          signon.autofillForms = {
            Value = false;
            Status = "locked";
          };
          services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSite = {
            Value = false;
            Status = "locked";
          };
          dom.private-attribution.submission.enabled = {
            Value = false;
            Status = "locked";
          };
          signon.generation.enabled = {
            Value = false;
            Status = "locked";
          };
          browser.search.suggest.enabled = {
            Value = false;
            Status = "locked";
          };
          browser.urlbar.showSearchTerms.enabled = {
            Value = false;
            Status = "locked";
          };
          browser.urlbar.showSearchSuggestionsFirst = {
            Value = false;
            Status = "locked";
          };
          browser.urlbar.suggest.trending = {
            Value = false;
            Status = "locked";
          };
          browser.urlbar.suggest.recentsearches = {
            Value = false;
            Status = "locked";
          };
          browser.urlbar.suggest.history = {
            Value = false;
            Status = "locked";
          };
          browser.urlbar.suggest.topsites = {
            Value = false;
            Status = "locked";
          };
          browser.urlbar.suggest.engines = {
            Value = false;
            Status = "locked";
          };
          browser.urlbar.suggest.quickactions = {
            Value = false;
            Status = "locked";
          };
          browser.search.separatePrivateDefault.ui.enabled = {
            Value = true;
            Status = "locked";
          };
        };
      };
    };

    #preferences.persistance.data.directories = [
    #  ".mozilla"
    #  ".config/mozilla"
    #];

    #preferences.persistance.cache.directories = [
    #  ".cache/mozilla"
    #];
  };
}
