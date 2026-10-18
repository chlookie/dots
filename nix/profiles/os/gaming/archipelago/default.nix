{
  pkgs,
  profiles,
  lib2,
  ...
}:

let
  inherit (lib2.nixos) mkHomeSymlink;

  dir = "/stuff/games/archipelago";

  archipelago = pkgs.symlinkJoin {
    name = "archipelago-wrapped";
    paths = [ pkgs.unstable.archipelago ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/archipelago \
        --set KIVY_METRICS_DENSITY 1.5
    '';
  };

  poptracker = pkgs.symlinkJoin {
    name = "poptracker-wrapped";
    paths = [ pkgs.unstable.poptracker ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/poptracker \
        --chdir ${dir}/poptracker \
    '';
    # --set SDL_VIDEODRIVER wayland \
    # --set QT_SCALE_FACTOR 2 \
    # --set GDK_SCALE 2
  };
in
{
  imports = [
    profiles.os.gaming.base

    (mkHomeSymlink {
      xdgDir = "data";
      target = "Archipelago";
      destination = "${dir}/archipelago-launcher";
    })
  ];

  environment.systemPackages = [
    archipelago # The archipelago launcher
    poptracker # Cool visual tracker
  ];

  services.syncthing.settings.folders."Archipelago" = {
    id = "archi-pelag";
    path = dir;
  };
}
