{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-23.05";
    };
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
      };
      testvm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hosts/testvm.nix
        ];
      };
    };
    devShells = nixpkgs.lib.genAttrs ["x86_64-linux"] (system: {
      default = with nixpkgs.legacyPackages.${system}; mkShell {
        packages = [
          nomad
        ];
      };
    });
  };
}
