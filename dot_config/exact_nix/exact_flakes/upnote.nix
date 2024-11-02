{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (appimageTools.wrapType2 {
      name = "upnote";
      src = pkgs.fetchurl {
        url = "https://upnote.sfo3.cdn.digitaloceanspaces.com/UpNote.AppImage";
        # Replace this with the actual hash from nix-prefetch-url
        sha256 = "0przmsp8g4y13hycwjh43xl5arrgbmi2wg5rdv2ghi33bwcbjlnb";
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
