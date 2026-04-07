{
   description = "A devbox shell";

   inputs = {
     nixpkgs.url = "github:NixOS/nixpkgs/75a52265bda7fd25e06e3a67dee3f0354e73243c";
   };

   outputs = {
     self,
     nixpkgs,
   }:
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in
      {
        devShells.x86_64-linux.default = pkgs.mkShell {
          buildInputs = [
            (builtins.trace "downloading go@1.23.2" (builtins.fetchClosure {
              
              fromStore = "https://cache.nixos.org";
              fromPath = "/nix/store/klw1ipjsqx1np7pkk833x7sad7f3ivv9-go-1.23.2";
              inputAddressed = true;
            }))
          ];
        };
      };
 }
