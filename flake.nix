{
  description = "Robin's NixOS system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = { self, nixpkgs, home-manager, zen-browser, ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    # ─────────────────────────────────────────────
    # NixOS system (NO Home Manager here)
    # ─────────────────────────────────────────────
    nixosConfigurations.transcendent = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit zen-browser; };
      modules = [
        ./configuration.nix
      ];
    };

    # ─────────────────────────────────────────────
    # Home Manager (standalone)
    # ─────────────────────────────────────────────
    homeConfigurations.robin =
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home/robin.nix
        ];
      };
  };
}

