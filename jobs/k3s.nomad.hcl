job "k3s" {
  group "k3s" {
    count = 2
    task "server" {
      driver = "qemu"
      config {
        image_path = "local/Fedora-Server-KVM-39-1.5.x86_64.qcow2"
        guest_agent = true
      }
      artifact {
        source = "https://download.fedoraproject.org/pub/fedora/linux/releases/39/Server/x86_64/images/Fedora-Server-KVM-39-1.5.x86_64.qcow2"
      }
      resources {
        cpu    = 1000
        memory = 2048
      }
    }
    update {
      healthy_deadline = "1h"
      progress_deadline = 0
    }
  }
}
