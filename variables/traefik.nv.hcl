path = "nomad/jobs/traefik/know_hosts"

items {
  # In Yggdrasil, an IPv6 address is tied to the encryption keypair, so any keypair
  # changes alter the IPv6 address. This allows me to set up a whitelist that only
  # accepts connections from known Yggdrasil IPv6 addresses, like computer or phone.
  # TODO add document for each client type
  khue-desktop = "201:3809:1f96:2c9b:e50a:4ca9:ae6:a593/128"
  khue-phone   = "201:70eb:37ff:be68:cdc8:28c4:7eea:36d3/128"
}