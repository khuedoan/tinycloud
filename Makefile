.POSIX:
.PHONY: default test update deploy

default: test

test:
	nixos-rebuild \
		--impure \
		--flake '.#testvm' \
		build-vm
	./result/bin/run-testvm-vm

update:
	nix flake update

deploy:
	nomad run -detach jobs/traefik.nomad.hcl
	nomad run -detach jobs/blog.nomad.hcl
	nomad run -detach jobs/speedtest.nomad.hcl
	nomad var put -force @variables/traefik.nv.hcl
