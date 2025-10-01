{ config, pkgs, ... }:

{
  homebrew = {
    enable = true;

    taps = builtins.attrNames config.nix-homebrew.taps;
    
    # Cleanup on activation
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    global = {
      brewfile = true;
    };
    
    # Homebrew Casks
    casks = [
      # Development Tools
      "docker-desktop"
      "container"
      "visual-studio-code"
      "visual-studio-code@insiders"
      "mongodb-compass"
      "textmate"
      "zed"
      "warp"
      "tabby"
      
      # Communication Tools
      "discord"
      "zoom"
      "spotify"

      # Entertainment Tools
      "vlc"
      "steam"
      "parsec"
      "crossover"

      # Productivity Tools
      "raycast"
      "microsoft-word"
      "microsoft-excel"
      "microsoft-powerpoint"
      "obsidian"

      # Browsers
      "google-chrome"
      "firefox"
      "orion"
      
      # Graphic tools
      "affinity-designer"
      "affinity-photo"
      "affinity-publisher"
      "figma"
      "sf-symbols"

      # Utilities
      "audacity"
      "mac-mouse-fix@2"
      "obs"
      "xquartz"
      "handbrake-app"
      "wireshark-app"

      # AI Tools
      "lm-studio"

      # This horrible thing to remove ASAP :
      "microsoft-teams"
      "android-studio"
    ];
    
    # Homebrew packages (formula)
    brews = [
      # Add any brew packages you need here
      # Example: "wget"
    ];

    # Mac App Store apps
    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    masApps = {
      # Add Mac App Store apps here
      # Example: "Xcode" = 497799835;
    };
  };
}
