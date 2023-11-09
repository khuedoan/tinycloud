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
        4646 # Nomad HTTP API
        4647 # Nomad RPC
        4648 # Nomad Serf WAN
        80 # HTTP
        443 # HTTPS
        8081 # Traefik API
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
    python3
    tmux
    tree
    unzip
    watch
  ];

  services = {
    openssh.enable = true;
    nomad = {
      enable = true;
      package = pkgs.nomad_1_6;
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
