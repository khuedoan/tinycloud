{ config, pkgs, ... }:

{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/vda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "1Gi";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
  };

  networking = {
    networkmanager = {
      enable = true;
    };
    nftables = {
      enable = true;
    };
    firewall = {
      allowedTCPPorts = [
        80 # HTTP
        443 # HTTPS
        8443 # TODO incus
      ];
    };
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  environment = {
    systemPackages = with pkgs; [
      curl
      gcc
      git
      gnumake
      neovim
      tmux
    ];
  };

  services = {
    openssh = {
      enable = true;
    };
    yggdrasil = {
      enable = true;
      persistentKeys = true;
      settings = {
        Peers = [
          # https://publicpeers.neilalexander.dev
          "tls://sin.yuetau.net:6643" # Singapore
          "tls://mima.localghost.org:443" # Philippines
          "tls://133.18.201.69:54232" # Japan
          "tls://vpn.itrus.su:7992" # Netherlands
          "tls://ygg.jjolly.dev:3443" # United States
        ];
      };
    };
  };

  virtualisation = {
    incus = {
      enable = true;
      ui = {
        enable = true;
      };
      preseed = {
        config = {
          "core.https_address" = ":8443";
        };
        networks = [{
          name = "incusbr0";
          project = "default";
          type = "bridge";
          config = {
            "ipv4.address" = "auto";
            "ipv6.address" = "auto";
          };
        }];
        storage_pools = [{
          name = "default";
          driver = "btrfs";
          config = {
            size = "30GiB"; # TODO auto?
          };
        }];
        profiles = [{
          name = "default";
          devices = {
            eth0 = {
              name = "eth0";
              network = "incusbr0";
              type = "nic";
            };
            root = {
              path = "/";
              pool = "default";
              type = "disk";
            };
          };
        }];
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

  system = {
    autoUpgrade = {
      enable = true;
      flake = "github:khuedoan/tinycloud/incus";
      allowReboot = true;
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    stateVersion = "25.05"; # Did you read the comment?
  };
}
