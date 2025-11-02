.POSIX:
.PHONY: default switch test update deploy install fmt clean

default: test

switch:
	nixos-rebuild \
		--flake '.#' \
		switch

test:
	nixos-rebuild \
		--flake '.#testvm' \
		build-vm
	./result/bin/run-testvm-vm

update:
	nix flake update

deploy:
	# TODO optimize this
	nixos-rebuild \
		--flake .#tinycloud \
		--target-host root@192.168.1.20 \
		test

install:
	# TODO migrate to github.com/khuedoan/nixie
	# Currently can't use PXE boot because the stupid hardware
	nixos-anywhere \
		--no-substitute-on-destination \
		--flake .#tinycloud \
		--target-host root@192.168.1.20

fmt:
	nomad fmt -recursive

clean:
	rm testvm.qcow2
