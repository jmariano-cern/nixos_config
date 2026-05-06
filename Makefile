# Makefile for NixOS configuration management
#
# Usage:
#   make switch            # rebuild and switch to current host
#   make switch HOST=work  # rebuild and switch to a specific host
#   make update            # update all flake inputs
#   make gc                # garbage collect old generations
#   make optimise          # optimise the nix store
#   make clean             # gc + optimise

HOST ?= $(shell hostname)
FLAKE = .#$(HOST)

.PHONY: switch dry boot update update-input gc optimise clean hardware-config diff history rollback git-check

# ── Git checks ─────────────────────────────────────────────────────────────────────────────

git-check:
	@{ \
	  UNTRACKED=$$(git ls-files --others --exclude-standard); \
	  UNSTAGED=$$(git diff --name-only); \
	  UNCOMMITTED=$$(git diff --cached --name-only); \
	  PROMPT=0; \
	  if [ -n "$$UNTRACKED" ]; then \
	    echo "Warning: untracked files (invisible to nix flake):"; \
	    echo "$$UNTRACKED"; \
	    echo ""; \
	    PROMPT=1; \
	  fi; \
	  if [ -n "$$UNSTAGED" ] || [ -n "$$UNCOMMITTED" ]; then \
	    echo "Warning: unstaged or uncommitted changes:"; \
	    git status --short; \
	    echo ""; \
	    PROMPT=1; \
	  fi; \
	  if [ "$$PROMPT" = "1" ]; then \
	    read -p "Build anyway? [y/N] " ans; \
	    if [ "$$ans" != "y" ] && [ "$$ans" != "Y" ]; then \
	      echo "Aborted."; \
	      exit 1; \
	    fi; \
	  else \
	    git fetch --quiet 2>/dev/null; \
	    if [ -n "$$(git log HEAD..@{u} --oneline 2>/dev/null)" ]; then \
	      echo "Remote has new commits:"; \
	      git log HEAD..@{u} --oneline; \
	      echo ""; \
	      read -p "Pull before building? [y/N] " ans; \
	      if [ "$$ans" = "y" ] || [ "$$ans" = "Y" ]; then \
	        git pull; \
	      fi; \
	    fi; \
	  fi; \
	}

# ── Rebuild ──────────────────────────────────────────────────────────────────────────────

switch: git-check
	sudo nixos-rebuild switch --flake $(FLAKE)

dry: git-check
	sudo nixos-rebuild dry-activate --flake $(FLAKE)

boot: git-check
	sudo nixos-rebuild boot --flake $(FLAKE)

# ── Flake inputs ──────────────────────────────────────────────────────────────────────────

update:
	nix flake update
	@echo "Run 'make switch' to apply updated inputs."

update-input:
	nix flake update $(INPUT)

# ── Maintenance ───────────────────────────────────────────────────────────────────────────

gc:
	sudo nix-collect-garbage --delete-older-than 30d
	nix-collect-garbage --delete-older-than 30d
	@echo "Nix store usage:"; du -sh /nix/store

optimise:
	sudo nix store optimise
	@echo "Nix store usage:"; du -sh /nix/store

clean: gc optimise
	@echo "Nix store usage:"; du -sh /nix/store

# ── New machine setup ────────────────────────────────────────────────────────────────────

hardware-config:
	@mkdir -p hosts/$(HOST)
	sudo nixos-generate-config --show-hardware-config > hosts/$(HOST)/hardware-configuration.nix
	@echo "Written to hosts/$(HOST)/hardware-configuration.nix"

# ── Inspection ────────────────────────────────────────────────────────────────────────────

diff:
	nix store diff-closures $$(ls -dt /nix/var/nix/profiles/system-*-link | sed -n '2p') $$(ls -dt /nix/var/nix/profiles/system-*-link | sed -n '1p')

history:
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

rollback:
	sudo nixos-rebuild switch --rollback
