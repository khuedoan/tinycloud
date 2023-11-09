job "traefik" {
  group "traefik" {
    task "traefik" {
      driver = "docker"
      template {
        data = yamlencode({
          accessLog = {}
          entryPoints = {
            http = {
              address = ":80"
            }
          }
          api = {
            dashboard = true
          }
          providers = {
            nomad = {}
          }
        })
        destination = "local/traefik.yaml"
      }
      config {
        image        = "traefik:v2.10"
        network_mode = "host"
        volumes = [
          "local/traefik.yaml:/etc/traefik/traefik.yaml",
        ]
      }
      resources {
        cpu    = 100
        memory = 128
      }
    }
    network {
      port "http" {
        static = 80
      }
    }
    service {
      name     = "traefik"
      provider = "nomad"
      port     = "http"
      tags = [
        "traefik.http.routers.traefik.rule=HostRegexp(`traefik.{domain:.+}`)",
        "traefik.http.routers.traefik.service=api@internal",
      ]
    }
  }
}
