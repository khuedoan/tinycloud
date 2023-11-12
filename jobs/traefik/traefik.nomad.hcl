job "traefik" {
  group "traefik" {
    task "traefik" {
      driver = "docker"
      template {
        destination = "local/traefik.yaml"
        data = yamlencode({
          accessLog = {}
          entryPoints = {
            http = {
              address = ":80"
              http = {
                redirections = {
                  entryPoint = {
                    to     = "https"
                    scheme = "https"
                  }
                }
              }
            }
            https = {
              address = ":443"
              http = {
                tls = {}
              }
            }
          }
          api = {
            dashboard = true
          }
          providers = {
            nomad = {}
            file = {
              directory = "/etc/traefik/conf.d"
            }
          }
        })
      }
      template {
        destination = "local/conf.d/static.yaml"
        data        = file("./static.yaml")
      }
      config {
        image        = "traefik:v2.10"
        network_mode = "host"
        volumes = [
          "local/traefik.yaml:/etc/traefik/traefik.yaml",
          "local/conf.d:/etc/traefik/conf.d",
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
      port "https" {
        static = 443
      }
    }
  }
}
