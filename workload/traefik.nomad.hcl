job "traefik" {
  group "traefik" {
    task "traefik" {
      driver = "docker"
      template {
        data = yamlencode({
          entryPoints = {
            http = {
              address = ":80"
            }
            traefik = {
              address = ":8081"
            }
          }
          api = {
            dashboard = true
            insecure = true
          }
          providers = {
            nomad = {}
          }
        })
        destination = "local/traefik.yaml"
      }
      config {
        image        = "traefik:v3.0"
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
      port "api" {
        static = 8081
      }
    }
  }
}
