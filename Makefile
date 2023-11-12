.POSIX:
.PHONY: default switch test update deploy fmt clean

default: test

switch:
	nixos-rebuild \
		--impure \
		--flake '.#' \
		switch

test:
	nixos-rebuild \
		--impure \
		--flake '.#testvm' \
		build-vm
	./result/bin/run-testvm-vm

update:
	nix flake update

# TODO optimize this
deploy:
	nomad var put -force @variables/nomad/jobs/traefik/known_hosts.nv.hcl
	cd jobs/bastion && nomad run -detach bastion.nomad.hcl
	cd jobs/blog && nomad run -detach blog.nomad.hcl
	cd jobs/k3s && nomad run -detach k3s.nomad.hcl
	cd jobs/speedtest && nomad run -detach speedtest.nomad.hcl
	cd jobs/traefik && nomad run -detach traefik.nomad.hcl

fmt:
	nomad fmt -recursive

clean:
	rm testvm.qcow2
