{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/virtualisation/qemu-vm.nix")
  ];

  networking = {
    hostName = "testvm";
  };

  virtualisation = {
    cores = 2;
    memorySize = 4096;
    qemu = {
      options = [
        "-nographic"
      ];
    };
    forwardPorts = [
      { from = "host"; host.port = 4646; guest.port = 4646; }
    ];
  };

  users.users.admin = {
    password = "testvm";
  };
  services.getty.autologinUser = "admin";
}
