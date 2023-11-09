.POSIX:
.PHONY: default test update

default: test

test:
	nixos-rebuild \
		--impure \
		--flake '.#testvm' \
		build-vm
	./result/bin/run-testvm-vm

update:
	nix flake update
