# Tiny Cloud

> [!WARNING]
> Experimental software

A lightweight "cloud" provider (think AWS, GCP, Azure) designed to run on your
own hardware. It has a much smaller footprint compared to solutions like
OpenStack, but it comes with some trade-offs in terms of reliability and
capabilities.

## Usage

Still experimetal for now, so it may not work:

- Install NixOS
- SSH to the NixOS instance
- Build and switch:

```sh
git clone https://github.com/khuedoan/tinycloud
cd tinycloud
sudo make switch
nomad acl bootstrap # Copy Secret ID
NOMAD_TOKEN=$SECRET_ID
make deploy
```

- Connect to Yggdrasil network on your desktop/laptop/mobile/whatever ([installation](https://yggdrasil-network.github.io/installation.html))
- Get the domain based on public Yggdrasil IP:

```sh
echo $(ip a | awk '/inet6.*200/ {split($2, arr, "/"); gsub(":", "-", arr[1]); print arr[1]}').sslip.io
```

- Now you can access nomad.$DOMAIN, traefik.$DOMAIN, etc.
