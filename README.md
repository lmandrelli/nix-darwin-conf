# macOS nix-darwin configuration

This is a clean, well-structured nix-darwin configuration with home-manager integration.

## Structure

```
~/.config/darwin/
├── flake.nix          # Main orchestration file
├── configuration.nix  # System configuration (stable packages)
├── brew.nix          # Homebrew casks and packages
├── home.nix          # User environment (unstable packages)
└── README.md         # This file
```

## Key Features

- **Dual Package Sources**: 
  - System packages use stable nixpkgs for reliability
  - Development tools use unstable nixpkgs for latest versions
- **Clean Separation**: Each concern is in its own file
- **Modern Practices**: Uses flakes and follows current best practices
- **Your Current Settings**: All your macOS preferences and dock setup preserved

## Installation

1. Make sure you have nix-darwin installed
2. Navigate to the configuration directory:
   ```bash
   cd ~/.config/darwin
   ```
3. Build and switch to the new configuration:
   ```bash
   darwin-rebuild switch --flake .#lmandrelli
   ```

## Making Changes

### Adding System Packages
Edit `configuration.nix` and add packages to the `environment.systemPackages` list.

### Adding Development Tools
Edit `home.nix` and add packages to the `home.packages` list.

### Adding Homebrew Apps
Edit `brew.nix` and add casks to the `casks` list or formulas to the `brews` list.

### Changing macOS Settings
Edit the `system.defaults` section in `configuration.nix`.

## Updating

To update packages:
```bash
nix flake update
darwin-rebuild switch --flake .#lmandrelli
```

## Advantages of This Structure

1. **Maintainable**: Each file has a single responsibility
2. **Modern**: Uses latest nix-darwin and home-manager patterns
3. **Flexible**: Easy to add/remove packages and settings
4. **Stable**: System packages use stable channel for reliability
5. **Current**: Development tools use unstable for latest features
6. **Clean**: No complex inheritance or shared modules to understand

## Migration from Old Config

This configuration includes:
- ✅ All your current macOS system defaults
- ✅ All your homebrew casks 
- ✅ All your development packages
- ✅ Your complete zsh, git, vim, tmux setup
- ✅ Your dock configuration
- ✅ Added smart quote/capitalization disable features

The old complex structure in `/Users/lmandrelli/nixos-config` can be removed once you've verified everything works correctly.
