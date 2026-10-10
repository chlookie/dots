{
  lib2,
  pkgs,
  profiles,
  ...
}:

let
  inherit (lib2.nixos) mkHomeSymlink;
in
{
  imports = [
    profiles.os.gaming.base

    (mkHomeSymlink {
      xdgDir = "config";
      target = "steam-rom-manager/userData";
      destination = "/stuff/games/emu/steamRomManager/userData";
    })
  ];

  # Only include light emulators; heavy ones go in ./emulation2.nix
  environment.systemPackages = [
    # To manage emulators & games
    # pkgs.lutris # Game library manager
    pkgs.steam-rom-manager # Add emulated games to steam
    pkgs.custom.ukmm # Breath of the Wild mod manager
    pkgs.custom.wiiuDownloader # Wii U dumps/games downloader

    # Emulators
    pkgs.melonDS # Nintendo DS
    pkgs.snes9x-gtk # SNES

    # Emulators (unused)
    # pkgs.higan # NES, SNES, GB, GBC, GBA, ...
  ];

}
