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
                    to = "https"
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
        data        = <<EOH
http:
  services:
    nomad:
      loadBalancer:
        servers:
          - url: "http://localhost:4646"
  middlewares:
    private:
      ipWhiteList:
        sourceRange:
          - 127.0.0.1/32
          {{ with nomadVar "nomad/jobs/traefik/know_hosts" }}
          {{ range .Values }}
          - {{ . }}
          {{end}}
          {{end}}
  routers:
    nomad:
      rule: HostRegexp(`nomad.{domain:.+}`)
      middlewares: private@file
      service: nomad
    traefik:
      rule: HostRegexp(`traefik.{domain:.+}`)
      middlewares: private@file
      service: api@internal
EOH
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
