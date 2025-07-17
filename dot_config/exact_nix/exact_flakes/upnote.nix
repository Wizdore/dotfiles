{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (appimageTools.wrapType2 {
      pname = "upnote"; # Package name
      version = "9.7.2"; # Replace with the actual version number

      src = builtins.fetchurl {
        url = "https://upnote.sfo3.cdn.digitaloceanspaces.com/UpNote.AppImage";
        # Nix will compute the hash automatically if `sha256` is not provided
        # and output it during the build. Use an empty hash for first-time builds:
        sha256 = "1d3hdsz7y4lbkankgxnnp94qr2w174avni1b8nh6lbkzj0dbpgqf";
      };

      extraPkgs = pkgs: with pkgs; [
        # Essential runtime dependencies for Electron-based apps
        gtk3
        gtk4
        nss
        alsa-lib
        at-spi2-core
        
        # Wayland-specific dependencies
        wayland
        
        # Basic font support (assuming system-wide font config exists)
        fontconfig
      ];

      extraInstallCommands = ''
        # Create desktop entry
        mkdir -p $out/share/applications
        cat > $out/share/applications/upnote.desktop <<EOF
        [Desktop Entry]
        Name=UpNote
        Exec=upnote
        Terminal=false
        Type=Application
        Icon=upnote
        Categories=Office;
        EOF
      '';
    })
  ];
}

