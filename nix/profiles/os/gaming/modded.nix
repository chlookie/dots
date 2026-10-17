{ pkgs, ... }:
{

  environment.systemPackages = [
    pkgs.unstable.r2modman # A mod manager for Risk of Rain 2 and other Unity games.
    pkgs.unstable.olympus # Cross-platform GUI Everest installer and Celeste mod manager.
    pkgs.unstable.melonloader-installer # Automated installer for MelonLoader, the universal mod-loader for Unity games.
  ];
}
