{ pkgs, ... }:

{
  imports = [
  ];

  environment.systemPackages = [
    pkgs.archipelago # The archipelago launcher
    pkgs.poptracker # Universal tracker
  ];

}
