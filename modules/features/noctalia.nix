{ self, inputs, ... }: {
  perSystem = { pkgs, ... }: {
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
                formatHorizontal = "HH:mm ddd; MMM dd";
                formatVertical = "HH mm - dd MM";
                id = "Clock";
                tooltipFormat = "HH:mm ddd; MMM dd";
                useCustomFont = false;
              }
            ];
          };
        };
      };
    };
  };
}
