{ pkgs, profiles, ... }:

{
  imports = [
    profiles.os.gaming.base
    profiles.os.gaming.emulation
  ];

  environment.systemPackages = [
    pkgs.archipelago # The archipelago launcher
    pkgs.poptracker # Universal tracker

    pkgs.olympus # Cross-platform GUI Everest installer and Celeste mod manager.
  ];
}
