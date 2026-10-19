{
  lib2,
  profiles,
  pkgs,
  ...
}:

let
  inherit (lib2.nixos) mkHomeSymlink;
in
{
  imports = [
    profiles.os.gaming.emulation

    (mkHomeSymlink {
      xdgDir = "data";
      target = "sudachi";
      destination = "/stuff/games/emu/switch/yuzu";
    })

    (mkHomeSymlink {
      xdgDir = "data";
      target = "yuzu";
      destination = "/stuff/games/emu/switch/yuzu";
    })

    (mkHomeSymlink {
      xdgDir = "config";
      target = "Ryujinx";
      destination = "/stuff/games/emu/switch/ryujinx";
    })

    (mkHomeSymlink {
      xdgDir = "data";
      target = "Cemu";
      destination = "/stuff/games/emu/wiiu/Cemu";
    })

    (mkHomeSymlink {
      xdgDir = "data";
      target = "ukmm";
      destination = "/stuff/games/emu/wiiu/ukmm";
    })
  ];

  # Heavy emulators that would only run on a good PC
  environment.systemPackages = [
    # Emulators
    pkgs.custom.yuzu # Switch
    # pkgs.custom.suyu # Switch (fork of yuzu)
    pkgs.ryubing # Switch (fork of ryujinx)

    pkgs.cemu # Wii U
  ];

}
