{
  description = "2giosangmitom's NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./hosts/nixos
          home-manager.nixosModules.home-manager
          ./modules/nixos
          ./modules/nixos/extra/asus.nix
          ./modules/nixos/extra/ssd.nix
          ./modules/nixos/extra/nvidia.nix

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs;
              };
              users.chien = {
                imports = [
                  ./modules/home
                ];
              };
            };
          }

          {
            _module.args = {inherit inputs;};
          }
        ];
      };
    };
    formatter.${system} = pkgs.alejandra;
  };
}
