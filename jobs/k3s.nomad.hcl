job "k3s" {
  group "k3s" {
    count = 1
    network {
      port "vnc" {
        to = 7000
      }
    }
    service {
      name = "k3s"
      provider = "nomad"
      tags = [
        "traefik.http.routers.k3s.rule=HostRegexp(`k3s.{domain:.+}`)",
      ]
      port = "vnc"
    }
    task "server" {
      driver = "qemu"
      config {
        image_path  = "local/Fedora-Server-KVM-39-1.5.x86_64.qcow2"
        guest_agent = true
        args = [
          "-vnc", ":1",
        ]
      }
      artifact {
        source = "https://download.fedoraproject.org/pub/fedora/linux/releases/39/Server/x86_64/images/Fedora-Server-KVM-39-1.5.x86_64.qcow2"
      }
      resources {
        cpu    = 1000
        memory = 2048
      }
    }
    task "novnc" {
      driver = "docker"
      # TODO not working yet
      env {
        NOVNC_PORT      = "7000"
        VNC_SERVER_IP   = "10.0.2.15"
        VNC_SERVER_PORT = "5901"
      }
      config {
        image = "voiselle/novnc"
        ports = [
          "vnc"
        ]
      }
    }
    update {
      healthy_deadline  = "1h"
      progress_deadline = 0
    }
  }
}
