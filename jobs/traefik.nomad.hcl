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
        join(", ", [
          "traefik.http.middlewares.private.ipwhitelist.sourcerange=127.0.0.1/32",
          # In Yggdrasil, an IPv6 address is tied to the encryption keypair, so any keypair
          # changes alter the IPv6 address. This allows me to set up a whitelist that only
          # accepts connections from known Yggdrasil IPv6 addresses, like computer or phone.
          # TODO move this to Nomad Variables
          "201:3809:1f96:2c9b:e50a:4ca9:ae6:a593/128", # Khue's desktop
          "201:70eb:37ff:be68:cdc8:28c4:7eea:36d3/128", # Khue's phone
        ]),
        "traefik.http.routers.traefik.rule=HostRegexp(`traefik.{domain:.+}`)",
        "traefik.http.routers.traefik.middlewares=private@nomad",
        "traefik.http.routers.traefik.service=api@internal",
      ]
    }
  }
}
