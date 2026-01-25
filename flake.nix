{
  description = "Robin's NixOS system";

  inputs = {
    nixpkgs-system.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-home.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-home";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = { self, nixpkgs-system, nixpkgs-home, home-manager, zen-browser, ... }:
  let
    system = "x86_64-linux";

    pkgs-home = import nixpkgs-home {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    # ─────────────────────────────────────────────
    # NixOS system (NO Home Manager here)
    # ─────────────────────────────────────────────
    nixosConfigurations.transcendent = nixpkgs-system.lib.nixosSystem {
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
        inherit pkgs-home;
        modules = [
          ./home/robin.nix
        ];
      };
  };
}

