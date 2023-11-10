job "bastion" {
  group "bastion" {
    task "server" {
      driver = "docker"
      config {
        image   = "nixos/nix"
        command = "sleep"
        args = [
          "infinity",
        ]
      }
    }
  }
}
