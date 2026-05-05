# Makefile for NixOS configuration management
#
# Usage:
#   make switch        # rebuild and switch to current host
#   make switch HOST=work  # rebuild and switch to a specific host
#   make update        # update all flake inputs
#   make gc            # garbage collect old generations
#   make optimise      # optimise the nix store
#   make clean         # gc + optimise

# Detect current hostname by default
HOST ?= $(shell hostname)
FLAKE = .#$(HOST)

.PHONY: switch dry boot update update-input gc optimise clean hardware-config diff history rollback

# ── Rebuild ──────────────────────────────────────────────────────────────────

switch: tidy
	sudo nixos-rebuild switch --flake $(FLAKE)

dry: tidy
	sudo nixos-rebuild dry-activate --flake $(FLAKE)

boot: tidy
	sudo nixos-rebuild boot --flake $(FLAKE)

# ── Flake inputs ─────────────────────────────────────────────────────────────

update: tidy
	nix flake update
	@echo "Run 'make switch' to apply updated inputs."

# Update a single input: make update-input INPUT=nixpkgs-unstable
update-input: tidy
	nix flake update $(INPUT)

# ── Maintenance ──────────────────────────────────────────────────────────────

gc:
	sudo nix-collect-garbage --delete-older-than 30d
	nix-collect-garbage --delete-older-than 30d
	@echo "Nix store usage:"; du -sh /nix/store

optimise:
	sudo nix store optimise
	@echo "Nix store usage:"; du -sh /nix/store

clean: tidy gc optimise
	@echo "Nix store usage:"; du -sh /nix/store

tidy:
	find . -name "*~" -type f -delete

# ── New machine setup ────────────────────────────────────────────────────────

# Generate hardware config for the current host and write it into the repo.
# Usage: make hardware-config
#        make hardware-config HOST=newmachine
hardware-config:
	@mkdir -p hosts/$(HOST)
	sudo nixos-generate-config --show-hardware-config > hosts/$(HOST)/hardware-configuration.nix
	@echo "Written to hosts/$(HOST)/hardware-configuration.nix"

# ── Inspection ───────────────────────────────────────────────────────────────

# Show what changed between the current and previous system generation
diff:
	nix store diff-closures $$(ls -dt /nix/var/nix/profiles/system-*-link | sed -n '2p') $$(ls -dt /nix/var/nix/profiles/system-*-link | sed -n '1p')

history:
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

rollback:
	sudo nixos-rebuild switch --rollback
