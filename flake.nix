{
  description = "Luca's macOS Configuration";

  inputs = {
    # Stable nixpkgs for system packages
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    
    # Unstable nixpkgs for development tools and latest packages
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    # nix-darwin for macOS system configuration (latest master with Touch ID support)
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    
    # Home Manager for user environment
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    
    # Specific nixpkgs commit for tamarin-prover
    nixpkgs-tamarin = {
      url = "github:NixOS/nixpkgs/a421ac6595024edcfbb1ef950a3712b89161c359";
    };
    
    # Homebrew integration
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs-stable, nixpkgs-unstable, nixpkgs-tamarin, home-manager, nix-homebrew, homebrew-core, homebrew-cask }:
  let
    user = "lmandrelli";
    system = "aarch64-darwin";
    
    # Configuration for allowing unfree packages
    nixpkgsConfig = {
      allowUnfree = true;
    };
    
    # Stable packages for system
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config = nixpkgsConfig;
    };
    
    # Unstable packages for development
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config = nixpkgsConfig;
    };
    
    # Tamarin-prover packages from specific commit
    pkgs-tamarin = import nixpkgs-tamarin {
      inherit system;
      config = nixpkgsConfig;
    };
    
  in {
    darwinConfigurations.${user} = nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { 
        inherit inputs user pkgs-stable pkgs-unstable pkgs-tamarin; 
      };
      modules = [
        # System configuration
        ./configuration.nix
        
        # Homebrew configuration
        ./brew.nix
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true; # For x86_64 compatibility on Apple Silicon
            user = "${user}";
            autoMigrate = true;
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };
          };
        }
        
        # Home Manager integration
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = false; # Use separate unstable packages for home
            useUserPackages = true;
            users.${user} = import ./home.nix;
            extraSpecialArgs = { 
              inherit inputs user pkgs-unstable pkgs-tamarin; 
            };
          };
        }
      ];
    };
  };
}
