{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-23.05";
    };
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      testvm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hosts/testvm.nix
        ];
      };
    };
  };
}
