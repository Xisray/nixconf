{ self, inputs, ... }: {
  perSystem = { pkgs, config, ... }: {
    packages.noctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      colors = {
        mPrimary = self.theme.base07;
        mOnPrimary = self.theme.base00;
        mSecondary = self.theme.base06; # ?
        mOnSecondary = self.theme.base00;
        mTertiary = self.theme.base0E;
        mOnTertiary = self.theme.base00;
        mError = self.theme.base08;
        mOnError = self.theme.base00;
        mSurface = self.theme.base00;
        mOnSurface = self.theme.base05;
        mSurfaceVariant = self.theme.base02;
        mOnSurfaceVariant = self.theme.base04; # ?
        mOutline = self.theme.base03; # ?
        mShadow = self.theme.base01; # ?
        mHover = self.theme.base03;
        mOnHover = self.theme.base05;
      };
      settings = {
        appLauncher = {
          customLaunchPrefixEnabled = false;
          enableClipboardHistory = false;
          iconMode = "tabler";
          pinnedExecs = [ ];
          position = "center";
          showCategories = true;
          sortByMostUsed = true;
          terminalCommand = "kitty -e";
          useApp2Unit = false; # ?
          viewMode = "list";
        };
        audio = {
          mprisBlacklist = [ ];
          preferredPlayer = "";
          visualizerType = "none";
          volumeOverdrive = false;
          volumeStep = 5;
        };
        bar = {
          position = "top";
          outerCorners = false;
          showCapsule = false;
          rightClickAction = "settings";
          widgets = {
            left = [
              {
                colorizeDistroLogo = true;
                enableColorization = true;
                id = "ControlCenter";
                useDistroLogo = true;
              }
            ];
            center = [
              {
                characterCount = 2;
                colorizeIcons = false;
                enableScrollWheel = true;
                followFocusedScreen = false;
                hideUnoccupied = true;
                id = "Workspace";
                labelMode = "none";
                showApplications = false;
                showLabelsOnlyWhenOccupied = true;
              }
            ];
            right = [
              {
                blacklist = [ ];
                chevronColor = "none";
                colorizeIcons = false;
                drawerEnabled = true;
                hidePassive = false;
                id = "Tray";
                pinned = [ ];
              }
              {
                hideWhenZero = false;
                id = "NotificationHistory";
                showUnreadBadge = true;
              }
              {
                displayMode = "graphic-clean";
                hideIfIdle = false;
                hideIfNotDetected = true;
                id = "Battery";
                showNoctaliaPerformance = false;
                showPowerProfiles = false;
              }
              {
                displayMode = "onhover";
                iconColor = "none";
                id = "Volume";
                middleClickCommand = "pwvucontrol || pavucontrol";
                textColor = "none";
              }
              {
                applyToAllMonitors = false;
                displayMode = "onhover";
                iconColor = "none";
                id = "Brightness";
                textColor = "none";
              }
              {
                displayMode = "forceOpen";
                iconColor = "none";
                id = "KeyboardLayout";
                showIcon = true;
                textColor = "none";
              }
              {
                clockColor = "none";
                customFont = "";
                formatHorizontal = "HH:mm ddd, MMM dd";
                formatVertical = "HH mm - dd MM";
                id = "Clock";
                tooltipFormat = "HH:mm ddd; MMM dd";
                useCustomFont = false;
              }
            ];
          };
        };
        calendar = {
          cards = [
            {
              enabled = true;
              id = "calendar-header-card";
            }
            {
              enabled = true;
              id = "calendar-month-card";
            }
            {
              enabled = false;
              id = "weather-card";
            }
          ];
        };
        controlCenter = {
          position = "close_to_bar_button";
          cards = [
            {
              enabled = true;
              id = "profile-card";
            }
            {
              enabled = true;
              id = "shortcuts-card";
            }
            {
              enabled = true;
              id = "audio-card";
            }
            {
              enabled = false;
              id = "brightness-card";
            }
            {
              enabled = false;
              id = "weather-card";
            }
            {
              enabled = true;
              id = "media-sysmon-card";
            }
          ];
          shortcuts = {
            left = [
              { id = "WiFi"; }
              { id = "Bluetooth"; }
            ];
            right = [
              { id = "Notifications"; }
              { id = "PowerProfile"; }
            ];
          };
        };
        desktopWidgets = {
          enabled = false;
        };
        dock = {
          enabled = false;
        };
        general = {
          telemetryEnabled = false;
          showChangelogOnStartup = false;

          compactLockScreen = true;
          lockScreenAnimations = true;
          passwordChars = true;
          showSessionButtonsOnLockScreen = false;

          enableShadows = false;
          enableBlurBehind = false;
        };
        ui = {
          panelBackgroundOpacity = 1.0;
          tooltipsEnabled = true;
        };

        hooks = {
          enabled = false;
        };
        location = {
          weatherEnabled = false;
        };
        nightLight = {
          autoSchedule = false;
          dayTemp = "6500";
          enabled = true;
          forced = false;
          manualSunrise = "06:30";
          manualSunset = "19:30";
          nightTemp = "4500";
        };
        wallpaper = {
          enabled = true;
          directory = "/home/${config.preferences.user.name}/Pictures/Wallpapers/${self.themeName}";
        };
        notifications = {
          criticalUrgencyDuration = 15;
          enableKeyboardLayoutToast = false;
          enableMediaToast = false;
          enabled = true;
          location = "top_right";
          lowUrgencyDuration = 5;
          normalUrgencyDuration = 8;
          overlayLayer = true;
          respectExpireTimeout = false;
          sounds.enabled = false;
        };
        idle = {
          enabled = true;
          screenOffTimeout = 300;
          lockTimeout = 600;
          suspendTimeout = 1800;
          fadeDuration = 5;
          suspendCommand = "systemctl hibernate || loginctl hibernate";
        };
        sessionMenu = {
          enableCountdown = false;

          showKeybinds = true;
          largeButtonsStyle = true;
          largeButtonsLayout = "single-row";
          powerOptions = [
            {
              action = "lock";
              command = "";
              countdownEnabled = true;
              enabled = false;
              keybind = "";
            }
            {
              action = "suspend";
              command = "";
              countdownEnabled = true;
              enabled = false;
              keybind = "";
            }
            {
              action = "hibernate";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "1";
            }
            {
              action = "logout";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "2";
            }
            {
              action = "shutdown";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "3";
            }
            {
              action = "reboot";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "4";
            }
            {
              action = "rebootToUefi";
              command = "";
              countdownEnabled = true;
              enabled = false;
              keybind = "";
            }
            {
              action = "userspaceReboot";
              command = "";
              countdownEnabled = true;
              enabled = false;
              keybind = "";
            }
          ];
        };
      };
    };
  };
}
