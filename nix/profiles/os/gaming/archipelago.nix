{ pkgs, profiles, ... }:

{
  imports = [
    profiles.os.gaming.base
    profiles.os.gaming.emulation
  ];

  environment.systemPackages =
    let
      poptracker = pkgs.symlinkJoin {
        name = "poptracker";
        paths = [ pkgs.poptracker ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/poptracker --set SDL_VIDEODRIVER wayland
        '';
      };
    in
    [
      poptracker # Universal tracker
      pkgs.archipelago # The archipelago launcher

      pkgs.olympus # Cross-platform GUI Everest installer and Celeste mod manager.
    ];
}
