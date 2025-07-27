{
  description = "system configuration for ..."; # TODO: update me! (e.g. the hostname)

  inputs = {
    darwin.url = "github:nix-darwin/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:NixOS/nixpkgs/..."; # TODO: update me! (e.g. `nixos-22.11`, `nixpkgs-22.11-darwin`)

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/..."; # TODO: update me! (e.g. `nixos-unstable`, `nixpkgs-unstable`)

    sys.url = "github:keysmashes/sys";
  };

  outputs = inputs: let
    system = "..."; # TODO: update me! (e.g. `x86_64-linux`, `aarch64-darwin`)
  in {
    darwinConfigurations.default = inputs.darwin.lib.darwinSystem {
      inherit system;
      inputs = { inherit inputs; };
      modules = [ ({ config, ... }: {
        imports = [ inputs.sys.darwinModules.default ];
        _module.args = { unstable = import inputs.nixpkgs-unstable { inherit system; inherit (config.nixpkgs) config overlays; }; };
        system.stateVersion = 4;
      }) ];
    };
    homeConfigurations.default = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = { inherit inputs; };
      modules = [ ({ config, ... }: {
        imports = [ inputs.sys.homeModules.default ];
        _module.args = { unstable = import inputs.nixpkgs-unstable { inherit system; inherit (config.nixpkgs) config overlays; }; };
        home.homeDirectory = "..."; # TODO: update me!
        home.username = "..."; # TODO: update me!
        home.stateVersion = "22.11";
      }) ];
    };
    nixosConfigurations.default = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [ ({ config, ... }: {
        imports = [ inputs.sys.nixosModules.default ];
        _module.args = { unstable = import inputs.nixpkgs-unstable { inherit system; inherit (config.nixpkgs) config overlays; }; };
        system.stateVersion = "22.11";
      }) ];
    };
  };
}
