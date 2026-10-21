{ config, ... }:

{
  # TODO: Push secrets/ you dummy and then delete the eduroam + other removed wifi stuff
  networking.networkmanager = {
    # Enable networking with NetworkManager
    enable = true;

    ensureProfiles = {
      environmentFiles = [
        config.age.secrets."wifi/networkmanager-env".path
      ];

      profiles = {
        "Home" = {
          connection = {
            id = "Celeste Mountain";
            interface-name = "wlp0s20f3";
            type = "wifi";
            uuid = "4b899b53-7cd4-48c5-a7d5-56b598c6b9aa";
          };
          ipv4 = {
            method = "auto";
          };
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
          proxy = { };
          wifi = {
            mode = "infrastructure";
            ssid = "Celeste Mountain";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$CELESTE_MOUNTAIN_PSK";
          };
        };

        "Parents" = {
          connection = {
            id = "Domaine des fleurs de jardin";
            interface-name = "wlp0s20f3";
            type = "wifi";
            uuid = "15f9f454-b8c8-4441-8ab8-a42acbfd6c6c";
          };
          ipv4 = {
            method = "auto";
          };
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
          proxy = { };
          wifi = {
            mode = "infrastructure";
            ssid = "Domaine des fleurs de jardin";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$DOMAINE_DES_FLEURS_DE_JARDIN_PSK";
          };
        };
      };
    };
  };
}
