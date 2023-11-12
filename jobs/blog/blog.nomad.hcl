job "blog" {
  group "blog" {
    task "server" {
      driver = "docker"
      env {
        PORT = "3000"
      }
      config {
        image = "hashicorp/demo-webapp-lb-guide"
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
      name     = "blog"
      provider = "nomad"
      port     = "http"
      tags = [
        "traefik.http.routers.blog.rule=HostRegexp(`blog.{domain:.+}`)",
      ]
    }
  }
}
