job "speedtest" {
  group "speedtest" {
    task "server" {
      driver = "docker"
      config {
        image = "openspeedtest/latest"
        ports = [
          "http"
        ]
      }
    }
    network {
      port "http" {
        to = 3000
      }
    }
    service {
      name     = "speedtest"
      provider = "nomad"
      port     = "http"
      tags = [
        "traefik.http.routers.speedtest.rule=HostRegexp(`speedtest.{domain:.+}`)",
      ]
    }
  }
}
