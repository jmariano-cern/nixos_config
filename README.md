# NixOS Multi-Machine Configuration

## Directory layout

```
.
├── flake.nix                        # Inputs + auto-discovers all hosts
├── flake.lock                       # Pinned channel commits — commit this
│
├── packages/
│   └── groups.nix                   # Named package groups (compose these)
│
├── modules/
│   ├── base.nix                     # Shared: WM, terminal, fonts, sound
│   ├── users.nix                    # Shared: user accounts
│   └── nvidia.nix                   # Optional: import per-host for Nvidia
│
├── hosts/
│   ├── work/
│   │   ├── work.nix                 # Work machine config
│   │   └── hardware-configuration.nix
│   ├── editing/
│   │   ├── editing.nix              # Editing machine config
│   │   └── hardware-configuration.nix
│   └── laptop/
│       ├── laptop.nix               # Laptop config
│       └── hardware-configuration.nix
│
└── home/
    └── youruser.nix                 # Home Manager (shared across machines)
```

## Building for a specific machine

```bash
sudo nixos-rebuild switch --flake .#work
sudo nixos-rebuild switch --flake .#editing
sudo nixos-rebuild switch --flake .#laptop
```

Or use the shell alias defined in `home/youruser.nix`:

```bash
nixswitch work
```

## How package groups work

Groups are defined in `packages/groups.nix` and injected as a module argument
(`groups`). A host config picks which groups to install:

```nix
# hosts/work/default.nix
{ pkgs, groups, ... }: {
  environment.systemPackages =
    groups.sysTools
    ++ groups.programming
    ++ (with pkgs; [ someExtraPackage ]);  # one-off additions
}
```

To add a new group, add an entry to `packages/groups.nix`:

```nix
myGroup = with pkgs; [ foo bar baz ];
```

Then reference it in any host.

## Adding a new machine

```bash
mkdir hosts/newmachine
cp hosts/work/work.nix hosts/newmachine/newmachine.nix
# On the target machine:
sudo nixos-generate-config --show-hardware-config > hosts/newmachine/hardware-configuration.nix
```

`flake.nix` auto-discovers all subdirectories of `hosts/`, so no edits to
`flake.nix` are needed. Build with:

```bash
sudo nixos-rebuild switch --flake .#newmachine
```

## Nvidia

Import `../../modules/nvidia.nix` in any host that has an Nvidia GPU:

```nix
# hosts/editing/default.nix
imports = [ ../../modules/nvidia.nix ];
```

Omit the import on machines without Nvidia — no conditionals needed.

## Updating channels

```bash
nix flake update          # update all inputs
nix flake update nixpkgs-unstable  # update one input
sudo nixos-rebuild switch --flake .#<hostname>
```
