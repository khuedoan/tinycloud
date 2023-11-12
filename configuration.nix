{ config, pkgs, ... }:

{
  imports = [
    # TODO find a way to generate hardware configuration?
    /etc/nixos/hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    networkmanager.enable = true;
    firewall = let
      nomadDynamicPortRange = { from = 20000; to = 32000; };
    in
    {
      allowedTCPPorts = [
        80 # HTTP
        443 # HTTPS
      ];
      allowedTCPPortRanges = [
        nomadDynamicPortRange
      ];
      allowedUDPPortRanges = [
        nomadDynamicPortRange
      ];
    };
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  environment.systemPackages = with pkgs; [
    curl
    gcc
    git
    gnumake
    neovim
    tmux
  ];

  services = {
    openssh.enable = true;
    nomad = {
      enable = true;
      # TODO switch to stable when 23.11 is out
      package = (import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/85f1ba3e5167.tar.gz") {}).nomad_1_6;
      extraPackages = with pkgs; [
        qemu_full
      ];
      dropPrivileges = false;
      settings = {
        server = {
          enabled = true;
          bootstrap_expect = 1;
        };
        client = {
          enabled = true;
          artifact = {
            disable_filesystem_isolation = true;
          };
        };
        acl = {
          enabled = true;
        };
      };
    };
    yggdrasil = {
      enable = true;
      persistentKeys = true;
      settings = {
        Peers = [
          # https://publicpeers.neilalexander.dev
          "tcp://sin.yuetau.net:6642"
          "tcp://mima.localghost.org:1996"
        ];
      };
    };
  };

  users.users = {
    admin = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      packages = with pkgs; [
      ];
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
