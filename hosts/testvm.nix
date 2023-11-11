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
    memorySize = 8192;
    diskImage = null;
    qemu = {
      options = [
        "-nographic"
      ];
    };
    forwardPorts = [
      { from = "host"; host.port = 4646; guest.port = 4646; }
      { from = "host"; host.port = 8080; guest.port = 80; }
      { from = "host"; host.port = 8443; guest.port = 443; }
      { from = "host"; host.port = 8081; guest.port = 8081; }
    ];
  };

  users.users.admin = {
    password = "testvm";
  };
  services.getty.autologinUser = "admin";
}
