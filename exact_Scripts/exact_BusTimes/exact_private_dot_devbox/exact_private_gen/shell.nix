let
  pkgs = import
    (fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/75a52265bda7fd25e06e3a67dee3f0354e73243c.tar.gz";
    })
    { };
in
with pkgs;
mkShell {
  packages = [];
}
