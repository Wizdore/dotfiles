{
  description = "WizNix";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, auto-cpufreq, ... }@inputs: {
    nixosConfigurations.capgemini = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
          
        # Main Config
        ./configuration.nix

        # My custom flakes
        ./flakes/upnote.nix

        # should be in the ./flakes/ dir, but fine for now
        auto-cpufreq.nixosModules.default
      ];
    };
  };
}
