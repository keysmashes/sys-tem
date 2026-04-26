{
  description = "system configuration for ..."; # TODO: update me! (e.g. the hostname)

  inputs = {
    darwin.url = "github:nix-darwin/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz"; # TODO: update me! (e.g. on darwin, `nixpkgs-unstable`)

    sys.url = "git+https://codeberg.org/keysmashes/sys.git";
  };

  outputs = inputs: let
    system = "..."; # TODO: update me! (e.g. `x86_64-linux`, `aarch64-darwin`)
  in {
    darwinConfigurations.default = inputs.darwin.lib.darwinSystem {
      inherit system;
      inputs = { inherit inputs; };
      modules = [ ({ config, ... }: {
        imports = [ inputs.sys.darwinModules.default ];
        system.stateVersion = 4;
      }) ];
    };
    homeConfigurations.default = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = { inherit inputs; };
      modules = [ ({ config, ... }: {
        imports = [ inputs.sys.homeModules.default ];
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
        system.stateVersion = "22.11";
      }) ];
    };
  };
}
