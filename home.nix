{ config, pkgs-unstable, user, ... }:

{
  # User home configuration
  home = {
    username = user;
    homeDirectory = "/Users/${user}";
    stateVersion = "25.05";
    enableNixpkgsReleaseCheck = true;
    
    # Development packages (unstable for latest versions)
    packages = with pkgs-unstable; [
      # General packages for development and system management
      fastfetch
      gnumake
      imagemagick
      lld
      baobab
      fd
      gh

      # Text edition
      typst
      
      # LaTeX distribution with pdflatex, biblatex and common packages
      (texlive.withPackages (ps: with ps; [
        scheme-full
        # Bibliography and citation
        biblatex biber
        # Font collections
        collection-fontsrecommended
        collection-fontutils
        # Math and science
        amsmath amsfonts
        # Graphics and figures
        graphics float subfig
        # Page layout and formatting
        geometry fancyhdr hyperref
        microtype booktabs
        # Lists and enumeration
        enumitem
        # Code listings
        listings
        # Colors
        xcolor
        # Additional useful packages
        pgf pgfplots beamer
        # Language support
        collection-langenglish
        # Extra packages
        collection-latexextra
      ]))

      # Cloud-related tools and SDKs
      docker
      docker-compose

      # Media-related packages
      ffmpeg

      # Node.js development tools
      nodejs  # npm is included automatically
      prettier  # now a standalone package
      bun

      # Fonts
      jetbrains-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.meslo-lg
      
      # Text and terminal utilities
      ripgrep
      tree

      # Python packages
      python3
      virtualenv
      uv

      # Rust + Cargo
      rustc
      cargo

      # Gradle
      gradle

      # Go
      go
      go-task

      # Java
      jdk

      # Development tools
      lazygit
      lazydocker

      # Cybersecurity tools
      # exegol  # Temporarily disabled due to dependency conflicts
      tamarin-prover

      # AI/LLM tools
      claude-code
      gemini-cli
    ];
  };

  # Programs configuration
  programs = {
    # Shell configuration
    zsh = {
      enable = true;
      autocd = false;
      oh-my-zsh = {
        enable = true;
        theme = "jaischeema";
        plugins = [
          "git"
          "npm"
          "node"
          "python"
          "rust"
          "docker"
          "docker-compose"
          "golang"
          "gradle"
          "macos"
          "virtualenv"
          "direnv"
        ];
      };
      initContent = ''
        if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
          . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
          . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
        fi
        
        # Define variables for directories
        export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
        export PATH=$HOME/.local/share/bin:$PATH
        export PATH=$HOME/.cargo/bin:$PATH

        # Remove history data we don't want to see
        export HISTIGNORE="pwd:ls:cd"

        # Ripgrep alias
        alias search='rg -p --glob "!node_modules/*"'

        # Always color ls and group directories
        alias ls='ls --color=auto'
        
        # Environment display configuration
        # Show nix-shell info
        export SHOW_NIX_SHELL_INFO=1
        
        # Enhance prompt with environment info
        setopt PROMPT_SUBST
        
        # Function to show current environment
        function environment_info() {
          local env_info=""
          
          # Check for nix-shell
          if [[ -n "$IN_NIX_SHELL" ]]; then
            env_info="$env_info%F{blue}[nix-shell]%f "
          fi
          
          # Check for direnv
          if [[ -n "$DIRENV_DIR" ]]; then
            env_info="$env_info%F{green}[direnv]%f "
          fi
          
          # Check for Python virtual environment
          if [[ -n "$VIRTUAL_ENV" ]]; then
            env_info="$env_info%F{yellow}[$(basename $VIRTUAL_ENV)]%f "
          fi
          
          # Check for Conda environment
          if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
            env_info="$env_info%F{cyan}[conda:$CONDA_DEFAULT_ENV]%f "
          fi
          
          echo "$env_info"
        }
        
        # Add environment info to right prompt
        RPS1='$(environment_info)'
      '';
    };

    git = {
      enable = true;
      userName = "Luca Mandrelli";
      userEmail = "luca.mandrelli@icloud.com";
      lfs.enable = true;

      ignores = [
        # direnv
        ".direnv"
        ".direnv/"
        ".envrc"

        # Linux
        "*~"
        ".fuse_hidden*"
        ".directory" 
        ".Trash-*"
        ".nfs*"

        # macOS
        ".DS_Store"
        ".AppleDouble"
        ".LSOverride"
        "Icon"
        "._*"
        ".DocumentRevisions-V100"
        ".fseventsd"
        ".Spotlight-V100"
        ".TemporaryItems"
        ".Trashes"
        ".VolumeIcon.icns"
        ".com.apple.timemachine.donotpresent"
        ".AppleDB"
        ".AppleDesktop"
        "Network Trash Folder"
        "Temporary Items"
        ".apdisk"
        "*.icloud"

        # VSCode
        ".vscode/*"
        "!.vscode/settings.json"
        "!.vscode/tasks.json"
        "!.vscode/launch.json"
        "!.vscode/extensions.json"
        "!.vscode/*.code-snippets"
        ".history/"
        "*.vsix"
        ".history"
        ".ionide"

        # Nix
        "result"
        "result-*"

        # Zed
        ".zed/"

        # Editor/IDE
        ".idea/"
        "*.swp"
        "*.swo"
        "*~"
        ".*.sw[a-z]"

        # Roo Code
        ".roo"
        ".roorules"

        # Zed rules 
        "AGENT.md"

        # Claude Code
        "CLAUDE.md"
        ".claude"
      ];

      extraConfig = {
        init.defaultBranch = "main";
        core = {
          editor = "code";
          autocrlf = "input";
        };
        pull.rebase = false;
        rebase.autoStash = true;
        push.autoSetupRemote = true;
      };
    };

    ssh = {
      enable = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      config = {
        global = {
          # Enable nix-direnv manual reload mode system-wide
          nix_direnv_manual_reload = true;
        };
      };
    };

    # Enable Home Manager to manage itself
    home-manager.enable = true;
  };

  # Marked broken Oct 20, 2022 check later to remove this
  # https://github.com/nix-community/home-manager/issues/3344
  manual.manpages.enable = false;
}
