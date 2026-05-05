{
  description = "NixOS multi-machine configuration";

  inputs = {
    nixpkgs.url         = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      unstableOverlay = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };

      # Build a NixOS system for a given host directory.
      # The hostname is the directory name under hosts/.
      mkHost = hostname: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          { nixpkgs.overlays = [ unstableOverlay ]; }

          # Shared base modules (apply to every machine)
          ./modules/base.nix
          ./modules/users.nix

          # Package group definitions (provides the `groups` argument)
          ./packages/groups.nix

          # Per-host configuration and hardware scan
          ./hosts/${hostname}/${hostname}.nix
          ./hosts/${hostname}/hardware-configuration.nix # import from etc?
          # /etc/nixos/hardware-configuration.nix # causes error

          # Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs    = true;
            home-manager.useUserPackages  = true;
            home-manager.backupFileExtension  = "backup";
            home-manager.users.youruser   = {
              imports = [
                ./home/youruser.nix
                ./home/hosts/${hostname}.nix
              ];
            };
          }
        ];
      };

      # Enumerate every subdirectory of hosts/ as a machine name.
      # Adding a new machine is as simple as mkdir hosts/<name>.
      hostNames = builtins.attrNames (builtins.readDir ./hosts);

    in
    {
      nixosConfigurations =
        builtins.listToAttrs (map (name: {
          inherit name;
          value = mkHost name;
        }) hostNames);
    };
}
