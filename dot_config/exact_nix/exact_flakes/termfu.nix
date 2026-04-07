{ config, pkgs, lib, ... }:
let
  termfu = pkgs.stdenv.mkDerivation rec {
    pname = "termfu";
    version = "unstable-2024-01-01";
    src = pkgs.fetchFromGitHub {
      owner = "jvalcher";
      repo = "termfu";
      rev = "07e6cd3a6e4b2d7fb62ebd3988de9ec7d16e9de6";
      hash = "sha256-Gow2tn8Pziowh8L7xHgG3TivlYOZCd7Fe6nx2/GQ0Pw=";
    };
    buildInputs = with pkgs; [
      ncurses
      python3
      gdb
    ];
    makeFlags = [ "PREFIX=$(out)" ];
    
    # Fix the linking issue
    preBuild = ''
      substituteInPlace Makefile \
        --replace '-lform' '-lform -lncursesw'
    '';

    # Fix the installation path
    installPhase = ''
      mkdir -p $out/bin
      cp termfu $out/bin/
    '';

    meta = with lib; {
      description = "Terminal-based debugger frontend";
      homepage = "https://github.com/jvalcher/termfu";
      license = licenses.unfree;
      platforms = platforms.linux;
      maintainers = [];
    };
  };
in
{
  environment.systemPackages = [ termfu ];
}
