{ pkgs-stable, user, ... }:

{
  # System packages (stable, essential)
  environment.systemPackages = with pkgs-stable; [
    # Essential system utilities
    coreutils
    curl
    wget
    git
    tmux
    
    # System tools
    htop
    tree
    openssh
    
    # Archive tools
    unzip
    zip
    unrar
    
    # Dock management
    dockutil
  ];

  # Nix configuration
  nix = {
    package = pkgs-stable.nix;
    
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "@admin" "${user}" ];
      substituters = [ "https://nix-community.cachix.org" "https://cache.nixos.org"];
      trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };
    
    # Optimise storage
    optimise.automatic = true;
    
    # Garbage collection
    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 30d";
    };
  };

  # User configuration
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs-stable.zsh;
  };

  # System defaults (your current settings + improvements)
  system = {
    stateVersion = 4;
    
    # Set primary user for system defaults
    primaryUser = "${user}";
    
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;
        KeyRepeat = 2;                    # 120, 90, 60, 30, 12, 6, 2
        InitialKeyRepeat = 15;            # 120, 94, 68, 35, 25, 15
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 1.0;
        "com.apple.sound.beep.feedback" = 1;
        NSAutomaticCapitalizationEnabled = false;      # Disable automatic capitalization
        NSAutomaticPeriodSubstitutionEnabled = false;  # Disable automatic period substitution
        NSAutomaticQuoteSubstitutionEnabled = false;   # Disable smart quotes
        NSAutomaticSpellingCorrectionEnabled = false;  # Disable auto-correct
      };

      dock = {
        autohide = false;
        show-recents = false;
        launchanim = true;
        orientation = "bottom";
        tilesize = 44;
      };

      finder = {
        _FXShowPosixPathInTitle = true;
        AppleShowAllFiles = true;
        QuitMenuItem = true;
        ShowStatusBar = true;
        ShowPathbar = true;
      };

      trackpad = {
        # Your current settings
        Clicking = true;
      };
    };

    # Deactivate macOS startup sound
    activationScripts = {
      suppressStartupSound = {
        text = "nvram StartupMute=%01";
      };
    };
  };


  # TouchID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # Nixpkgs configuration (from your shared config)
  nixpkgs.config = {
    allowUnfree = true;
  };
}
